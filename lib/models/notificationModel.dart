import 'package:flutter/cupertino.dart';

class NotificationModel
{
  String? receiverId;
  String? dateTime;
  String? name;
  String? text;
  String? image;
  String? icon;

  NotificationModel({
    this.receiverId,
    this.dateTime,
    this.name,
    this.text,
    this.image,
    this.icon,
  });
  NotificationModel.fromJson(Map<String,dynamic>json)
  {
    receiverId=json['receiverId'];
    dateTime=json['dateTime'];
    text =json['text'];
    name =json['name'];
    image=json['image'];
    icon=json['icon'];
  }

  Map<String,dynamic>? toMap() {
    return
      {
        'receiverId': receiverId,
        'dateTime': dateTime,
        'text': text,
        'name': name,
        'image': image,
        'icon': icon,

      };
  }

}