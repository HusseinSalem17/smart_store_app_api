class SlideModel {
  int? position;
  String? image;

  SlideModel({this.position, this.image});

  factory SlideModel.fromJson(Map<String, dynamic> json) => SlideModel(
        position: json['position'] as int?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'position': position,
        'image': image,
      };
}
