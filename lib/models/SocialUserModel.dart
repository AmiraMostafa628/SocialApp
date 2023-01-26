class SocialUserModel{
  String? name;
  String? email;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  String? token;

  SocialUserModel({
    this.name,
    this.email,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.token,
});
  SocialUserModel.fromJson(Map<String,dynamic>json)
  {
    name=json['name'];
    email=json['email'];
    uId =json['uId'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
    token=json['token'];
  }

  Map<String,dynamic>? toMap()
  {
      return
        {
          'name'  : name,
          'email' : email,
          'uId' : uId,
          'image' : image,
          'cover' : cover,
          'bio':bio,
          'token':token,
        };

  }

}