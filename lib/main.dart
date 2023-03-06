import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/HomeLayout.dart';
import 'package:social_app/modules/socialApp/login/Login_cubit/Login_cubit.dart';
import 'package:social_app/shared/blocObserver.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/network/style/theme.dart';

import 'modules/socialApp/login/LoginScreen.dart';
import 'package:sizer/sizer.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  token = await FirebaseMessaging.instance.getToken();
  print(token);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
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
          return MultiBlocProvider(
           providers: [
             BlocProvider(
                 create: (BuildContext context)=>SocialCubit()
                   ..getUserData()..getPosts()
                   ..getAllUsers()
                   ..getNotification()
                   ..changeMode(fromShared: isDark)),
             BlocProvider(create: (BuildContext context)=>SocialLoginCubit())
           ],
              child:  BlocConsumer<SocialCubit,SocialStates>(
                listener: (context,state){},
                builder: (context,state){
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme,
                    darkTheme:darkTheme,
                    themeMode: SocialCubit.get(context).isDark==true?ThemeMode.dark:ThemeMode.light,
                    home: startWidget,
                  );
                }
              ),

            );
        }
    );

  }
}


