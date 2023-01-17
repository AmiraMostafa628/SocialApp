class CommentModel {
  String? name;
  String? uId;
  String? image;
  String? commentImage;
  String? dateTime;
  String? text;

  CommentModel({
    this.name,
    this.uId,
    this.image,
    this.commentImage,
    this.text,
    this.dateTime,

  });

  CommentModel.fromJson(Map<String, dynamic>json)
  {
    name = json['name'];
    uId = json['uid'];
    image = json['image'];
    commentImage = json['commentImage'];
    text = json['text'];
    dateTime=json['dateTime'];
  }

  Map<String, dynamic>? toMap() {
    return
      {
        'name': name,
        'uid  ': uId,
        'image': image,
        'commentImage': commentImage,
        'text': text,
        'dateTime':dateTime,
      };
  }
}
