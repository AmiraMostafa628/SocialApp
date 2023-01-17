/*
{
"email": "amira.mostafa@gmail.com",
"password": "123456"
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/socialApp/login/LoginScreen.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import '../cubit/cubit.dart';
import 'components.dart';

void signOut({context}){
  FirebaseAuth.instance.signOut();
  CacheHelper.removeData(key: 'uId',).then((value) {
    if (value) {
      navigateAndFinish(context, SocialLoginScreen(),);
    }
  });
}


void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

var token ;

var uId;

//flutter pub upgrade --major-versions

/*{
"to":
"fHsT_puYQmGnZK_T9t08on:APA91bEzOkK16nu5VecjrpOT75UVyPZK5voPF0BtMW3TjkaK1FtaftRTkey58usyCcVFWfKiDovdzjTsUBAYuW1z092hM5Pp3uf2wKZ3neJIs7o8GynBfj2Btih4o66A36_e-pqtxsQ2",
"notification": {
"title": "HELLO",
"body": "Rich Notification testing (body)",
"mutable_content": true,
"sound": "Tri-tone"
},

"data": {
"type": "order",
"id": "87",
"click_action":"FKUTTER_NOTIFICATION_CLICK",
}
}*/



