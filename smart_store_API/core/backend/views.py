import datetime
from django.shortcuts import HttpResponse
from django.shortcuts import get_object_or_404, render
import requests
from rest_framework.response import Response

from backend.models import *
from backend.utils import (
    IsAuthenticatedUser,
    new_token,
    send_otp,
    send_password_reset_email,
    token_response,
)
from django.contrib.auth.hashers import make_password, check_password
from core.settings import TEMPLATES_BASE_URL
from django.template.loader import get_template

from rest_framework.decorators import api_view, permission_classes
from rest_framework.pagination import LimitOffsetPagination


from backend.serializers import (
    AddressSerializer,
    CartSerializar,
    CategorySerializer,
    PageItemSerializer,
    ProductSerializer,
    SlideSerializer,
    UserSerializer,
    WishListSerializer,
)


@api_view(["POST"])
def request_otp(request):
    email = request.data.get("email")
    phone = request.data.get("phone")

    if email and phone:
        if User.objects.filter(email=email).exists():
            return Response("email already exists", status=400)
        if User.objects.filter(phone=phone).exists():
            return Response("phone already exists", status=400)
        return send_otp(phone)
    else:
        return Response("data_missing", status=400)


@api_view(["POST"])
def resend_otp(request):
    phone = request.data.get("phone")
    if not phone:
        return Response("data_missing", status=400)
    return send_otp(phone)


@api_view(["POST"])
def verify_otp(request):
    phone = request.data.get("phone")
    otp = request.data.get("otp")

    otp_obj = get_object_or_404(Otp, phone=phone, verified=False)
    if otp_obj.validity.replace(tzinfo=None) > datetime.datetime.utcnow():
        print(otp_obj.validity, otp_obj.otp)
        if otp_obj.otp == int(otp):
            otp_obj.verified = True
            otp_obj.save()
            return Response("otp verified successfully")
        else:
            print(otp_obj.otp, otp)
            return Response("Incorrect otp", status=400)
    else:
        return Response("otp expired", status=400)


@api_view(["POST"])
def create_account(request):
    email = request.data.get("email")
    phone = request.data.get("phone")
    fullname = request.data.get("fullname")
    password = request.data.get("password")

    # checking if all the fields are present
    if email and phone and fullname and password:
        otp_obj = get_object_or_404(Otp, phone=phone, verified=True)
        otp_obj.delete()
        user = User()
        user.email = email
        user.phone = phone
        user.fullname = fullname
        user.password = make_password(password)
        user.save()
        return token_response(user)
    else:
        return Response("data_missing", status=400)


@api_view(["POST"])
def login(request):
    email = request.data.get("email")
    phone = request.data.get("phone")
    password = request.data.get("password")

    if email:
        user = get_object_or_404(User, email=email)
    elif phone:
        user = get_object_or_404(User, phone=phone)
    else:
        return Response("data_missing", status=400)
    if check_password(password, user.password):
        return token_response(user)
    else:
        return Response("Incorrect password", status=400)


@api_view(["POST"])
def password_reset_email(request):
    email = request.data.get("email")
    if email:
        user = get_object_or_404(User, email=email)
        return send_password_reset_email(user)
    else:
        return Response("data_missing", status=400)


@api_view(["GET"])
def password_reset_form(request, email, token):
    token_instance = PasswordResetToken.objects.filter(
        user__email=email,
        token=token,
    ).first()
    link_expired = get_template("pages/link-expired.html").render()
    if token_instance:
        if token_instance.created_at.replace(tzinfo=None) > datetime.datetime.utcnow():
            return render(
                request,
                "pages/new-password-form.html",
                {
                    "email": email,
                    "token": token,
                    "base_url": TEMPLATES_BASE_URL,
                },
            )
        else:
            token_instance.delete()
            return HttpResponse(link_expired)
    else:
        return HttpResponse(link_expired)


@api_view(["POST"])
def password_reset_confirm(request):
    email = request.data.get("email")
    token = request.data.get("token")
    password1 = request.data.get("password1")
    password2 = request.data.get("password2")

    token_instance = PasswordResetToken.objects.filter(
        user__email=email, token=token
    ).first()
    link_expired = get_template("pages/link-expired.html").render()

    if token_instance:
        if token_instance.created_at.replace(tzinfo=None) > datetime.datetime.utcnow():
            if len(password1) < 8:
                return render(
                    request,
                    "pages/new-password-form.html",
                    {
                        "email": email,
                        "token": token,
                        "base_url": TEMPLATES_BASE_URL,
                        "error": "Password must be at least 8 characters long",
                    },
                )
            if password1 == password2:
                user = token_instance.user
                user.password = make_password(password1)
                user.save()
                token_instance.delete()
                Token.objects.filter(user=user).delete()
                return Response("password updated successfully")
            else:
                return render(
                    request,
                    "pages/new-password-form.html",
                    {
                        "email": email,
                        "token": token,
                        "base_url": TEMPLATES_BASE_URL,
                        "error": "password doesn't matched!",
                    },
                )
        else:
            token_instance.delete()
            return HttpResponse(link_expired)
    else:
        return Response("Updated")


@api_view(["GET"])
@permission_classes([IsAuthenticatedUser])
def userdata(request):
    user = request.user
    data = UserSerializer(user, many=False).data
    return Response(data)


@api_view(["GET"])
def categories(request):
    list = Category.objects.all().order_by("position")
    data = CategorySerializer(list, many=True).data
    return Response(data)


@api_view(["GET"])
def slides(request):
    list = Slide.objects.all().order_by("position")
    data = SlideSerializer(list, many=True).data
    return Response(data)


@api_view(["GET"])
def pageItems(request):
    category = request.GET.get("category")
    # LimitOffsetPagination is used to paginate the queryset and send reqested number of items
    pagination = LimitOffsetPagination()
    page_items = PageItem.objects.filter(category=category)
    # pagination.paginate_queryset(page_items, request) will return the queryset with requested number of items
    queryset = pagination.paginate_queryset(page_items, request)
    data = PageItemSerializer(queryset, many=True).data
    return pagination.get_paginated_response(data)


@api_view(["GET"])
def product_details(request):
    productId = request.GET.get("productId")
    product = get_object_or_404(Product, id=productId)
    data = ProductSerializer(product, many=False).data
    return Response(data)


@api_view(["GET"])
@permission_classes([IsAuthenticatedUser])
def update_wishlist(request):
    id = request.GET.get("id")
    action = request.GET.get("action")
    user = request.user

    if action == "ADD":
        user.wishlist.add(id)
        user.save()
        return Response("Added to wishlist")
    elif action == "REMOVE":
        user.wishlist.remove(id)
        user.save()
        return Response("Removed from wishlist")


@api_view(["GET"])
@permission_classes([IsAuthenticatedUser])
def update_cart(request):
    id = request.GET.get("id")
    action = request.GET.get("action")
    user = request.user

    if action == "ADD":
        user.cart.add(id)
        user.save()
        return Response("Added to Cart")
    elif action == "REMOVE":
        user.cart.remove(id)
        user.save()
        return Response("Removed from Cart")


@api_view(["GET"])
@permission_classes([IsAuthenticatedUser])
def wishlist(request):
    _wishlist = request.user.wishlist.all()
    data = WishListSerializer(_wishlist, many=True).data
    return Response(data)


@api_view(["GET"])
@permission_classes([IsAuthenticatedUser])
def cart(request):
    id = request.GET.get("id")
    data = []
    if id:
        # load all cart items
        products = ProductOption.objects.filter(id=id)
        data = CartSerializar(products, many=True).data
    else:
        # load all cart items
        products = request.user.cart.all()
        data = CartSerializar(products, many=True).data
    return Response(data)


@api_view(["POST"])
# @permission_classes([IsAuthenticatedUser])
def updateaddress(request):
    name = request.data.get("name")
    address = request.data.get("address")
    pincode = request.data.get("pincode")
    contact_no = request.data.get("contact_no")

    if name and address and pincode and contact_no:
        try:
            pincode_response = requests.get(
                "https://api.postalpincode.in/pincode/" + str(pincode)
            ).json()
            if pincode_response[0]["Status"] == "Success":
                district = pincode_response[0]["PostOffice"][0]["District"]
                state = pincode_response[0]["PostOffice"][0]["State"]
                user = request.user
                user.name = name
                user.address = address
                user.pincode = pincode
                user.contact_no = contact_no
                user.district = district
                user.state = state
                user.save()
                return Response(AddressSerializer(user, many=False).data)
            else:
                return Response("Invalid Pincode", status=400)
        except:
            return Response("Invalid Pincode", status=400)

        return Response(pincode_response)
    else:
        return Response("data_missing", status=400)
