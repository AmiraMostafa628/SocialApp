class PostModel{
  String? name;
  String? uId;
  String? image;
  String? text;
  String? dateTime;
  String? postImage;
  String? token;


  PostModel({
    this.name,
    this.uId,
    this.image,
    this.text,
    this.dateTime,
    this.postImage,
    this.token,
  });
  PostModel.fromJson(Map<String,dynamic>json)
  {
    name=json['name'];
    uId =json['uId'];
    image=json['image'];
    text=json['text'];
    dateTime=json['dateTime'];
    postImage =json['postImage'];
    token =json['token'];

  }

  Map<String,dynamic>? toMap()
  {
    return
      {
        'name'  : name,
        'uId' : uId,
        'image' : image,
        'text' : text,
        'dateTime':dateTime,
        'postImage' : postImage,
        'token':token,
      };

  }

}