import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/HomeLayout.dart';
import 'package:social_app/shared/blocObserver.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/style/theme.dart';

import 'modules/socialApp/login/LoginScreen.dart';
import 'package:sizer/sizer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async
{
  showToast(text: 'on Background message', state: ToastState.SUCCESS);
  print(message.data.toString());

}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();

  //print(token);
  // foreground
  FirebaseMessaging.onMessage.listen((event) {
    showToast(text: 'on message', state: ToastState.SUCCESS);
    print(event.data.toString());
  });

  // when click notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {

    showToast(text: 'on message opened app', state: ToastState.SUCCESS);
    print(event.data.toString());
  });
  //background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  late Widget widget;

  uId = CacheHelper.getData(key: 'uId');
  dynamic isDark= CacheHelper.getData(key: 'isDark');

  print(uId);

  if(uId != null)
      widget = HomeLayout();
  else
    widget = SocialLoginScreen();

  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(startWidget: widget,isDark:isDark));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
    final Widget? startWidget;
    final dynamic isDark;

    MyApp({this.startWidget,this.isDark});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
          return BlocProvider(
            create: (BuildContext context)=>SocialCubit()
              ..getUserData()..getPosts()..getAllUsers()..getFriendRequest(uId)..getFriends()..changeMode(fromShared: isDark),
            child:  BlocConsumer<SocialCubit,SocialStates>(
              listener: (context,state){},
              builder: (context,state){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  darkTheme:darkTheme,
                  themeMode: SocialCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
                  home: startWidget,
                );
              }
            ),

          );
        }
    );

  }
}


