from itertools import product
from rest_framework.serializers import ModelSerializer, SerializerMethodField

from backend.models import *


class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = [
            "email",
            "phone",
            "fullname",
            "wishlist",
            "cart",
            "name",
            "address",
            "contact_no",
            "pincode",
            "district",
            "state",
        ]

class AddressSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = [
            "name",
            "address",
            "contact_no",
            "pincode",
            "district",
            "state",
        ]


class CategorySerializer(ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "position", "image"]


class SlideSerializer(ModelSerializer):
    class Meta:
        model = Slide
        fields = ["position", "image"]


class ProductSerializer(ModelSerializer):
    options = SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            "id",
            "title",
            "description",
            "price",
            "offer_price",
            "delivery_charge",
            "cod",
            "star_5",
            "star_4",
            "star_3",
            "star_2",
            "star_1",
            "options",
        ]

    def get_options(self, obj):
        options = obj.options_set.all()
        data = ProductOptionSerializer(options, many=True).data
        return data


class ProductOptionSerializer(ModelSerializer):
    images = SerializerMethodField()

    class Meta:
        model = ProductOption
        fields = ["id", "product", "option", "quantity", "images"]

    def get_images(self, obj):
        images = obj.images_set.all()
        data = ProductImageSerializer(images, many=True).data
        return data


class ProductImageSerializer(ModelSerializer):
    class Meta:
        model = ProductImage
        fields = "__all__"


class WishListSerializer(ModelSerializer):
    title = SerializerMethodField()
    price = SerializerMethodField()
    offer_price = SerializerMethodField()
    image = SerializerMethodField()

    def get_title(self, obj):
        return obj.__str__()

    def get_price(self, obj):
        return obj.product.price

    def get_offer_price(self, obj):
        return obj.product.offer_price

    def get_image(self, obj):
        return ProductImageSerializer(
            obj.images_set.order_by("position").first(),
            many=False,
        ).data.get("image")

    class Meta:
        model = ProductOption
        fields = ["id", "title", "price", "offer_price", "image"]


class CartSerializar(ModelSerializer):
    title = SerializerMethodField()
    price = SerializerMethodField()
    offer_price = SerializerMethodField()
    image = SerializerMethodField()
    cod = SerializerMethodField()
    delivery_charge = SerializerMethodField()

    def get_title(self, obj):
        return obj.__str__()

    def get_price(self, obj):
        return obj.product.price

    def get_offer_price(self, obj):
        return obj.product.offer_price

    def get_image(self, obj):
        return ProductImageSerializer(
            obj.images_set.order_by("position").first(),
            many=False,
        ).data.get("image")

    def get_cod(self, obj):
        return obj.product.cod

    def get_delivery_charge(self, obj):
        return obj.product.delivery_charge

    class Meta:
        model = ProductOption
        fields = [
            "id",
            "title",
            "image",
            "price",
            "offer_price",
            "quantity",
            "cod",
            "delivery_charge",
        ]


class PageItemSerializer(ModelSerializer):
    product_options = SerializerMethodField()

    class Meta:
        model = PageItem
        fields = [
            "position",
            "image",
            "category",
            "title",
            "viewtype",
            "product_options",
        ]

    def get_product_options(self, obj):
        options = obj.product_options.all()[:8]
        data = []
        for option in options:
            data.append(
                {
                    "id": option.id,
                    "image": ProductImageSerializer(
                        option.images_set.order_by("position").first(),
                        many=False,
                    ).data.get("image"),
                    "product": option.product.id,
                    "title": option.__str__(),
                    "price": option.product.price,
                    "offer_price": option.product.offer_price,
                }
            )
        return data
