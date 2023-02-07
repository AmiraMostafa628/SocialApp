import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/socialApp/notification/notificationScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 5.0,
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              SocialCubit.get(context).Notifications.length>0?IconButton(
                  onPressed: (){
                    NavigateTo(context, NotificationScreen());
                  },
                  icon: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Icon(IconBroken.Notification,
                        size: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            '${SocialCubit.get(context).Notifications.length}',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white
                            ),
                          ),
                          radius: 10.0,
                        ),
                      )
                    ],
                  )):
              IconButton(
                  onPressed: (){
                    NavigateTo(context, NotificationScreen());
                  },
                  icon: Stack(
                    children: [
                      Icon(IconBroken.Notification,
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: (){},
                  icon: Icon(IconBroken.Search)),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },

            items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      IconBroken.Home
                    ),
                    label: 'Home'
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      IconBroken.User
                  ),
                  label: 'Users'
              ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.account_circle_sharp
                  ),
                  label: 'profile'
              ),
                BottomNavigationBarItem(
                  icon: Icon(
                      IconBroken.Chat
                  ),
                  label: 'Chats'
              ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.menu
                  ),
                  label: 'Seting'
              ),
            ],
          ),
        );
      },
    );
  }
}
