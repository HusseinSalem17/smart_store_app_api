class UserModel {
  String? email;
  String? phone;
  String? fullName;

  UserModel({this.email, this.phone, this.fullName});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    fullName = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['phone'] = phone;
    map['fullname'] = fullName;
    return map;
  }
}
