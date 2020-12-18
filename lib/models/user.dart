class UserModel{
  String id;
  String email;
  String name;
  bool isOnline;
  UserModel({this.id,this.email,this.name});
  UserModel.fromJson(id,map){
    this.id=id;
    this.email=map['email'];
    this.name=map['name'];
  }
}