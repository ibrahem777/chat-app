class Doctor{
  String id;
  String name;
  String specialty;
  String imgUrl;
  String education;
  String description;
  Doctor({this.id,this.description,this.education,this.imgUrl,this.name,this.specialty});
  toJson(){
    Map<String,dynamic> map={
      'name':this.name,
      'specialty':this.specialty,
      
    };
    return map;

  }
  Doctor.fromJson(Map map){
    this.id=map['id'];
    this.name=map['name'];
      this.specialty=map['specialty'];
  }
}