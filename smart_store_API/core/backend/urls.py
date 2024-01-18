from django.urls import path
from backend.views import (
    cart,
    updateaddress,
    wishlist,
    update_cart,
    update_wishlist,
    categories,
    create_account,
    login,
    pageItems,
    password_reset_confirm,
    password_reset_email,
    password_reset_form,
    product_details,
    request_otp,
    resend_otp,
    slides,
    userdata,
    verify_otp,
)


urlpatterns = [
    path("request_otp/", request_otp),
    path("resend_otp/", resend_otp),
    path("verify_otp/", verify_otp),
    path("create_account/", create_account),
    path("login/", login),
    path("password_reset_email/", password_reset_email, name="password_reset_email"),
    path(
        "password_reset_form/<email>/<token>/",
        password_reset_form,
        name="password_reset_form",
    ),
    path(
        "password_reset_confirm/", password_reset_confirm, name="password_reset_confirm"
    ),
    path("userdata/", userdata, name="userdata"),
    path("categories/", categories, name="categories"),
    path("slides/", slides, name="slides"),
    path("pageitems/", pageItems),
    path("productdetails/", product_details),
    path("updatewishlist/", update_wishlist),
    path("updatecart/", update_cart),
    path("wishlist/", wishlist),
    path("cart/", cart),
    path("updateaddress/", updateaddress),
]
