// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  static const String collectionName = "Users";
  UserModel({this.uid, this.email, this.userName, this.password});
  //fromJson
  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        uid: json['uid'],
        email: json['email'],
        userName: json['user_name'],
        password: json['password'],
      );
  String? uid;
  String? email;
  String? userName;
  String? password;

  //toJson

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'user_name': userName,
    'password': password,
  };
}
