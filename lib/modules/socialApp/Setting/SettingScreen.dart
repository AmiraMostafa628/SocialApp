import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/modules/socialApp/Friends/Friends.dart';
import 'package:social_app/modules/socialApp/profiles/profileScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

import '../../../shared/components/constant.dart';

class SettingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    SocialCubit.get(context).changeBottomNav(2);
                  },
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all((10.0)),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 27.0,
                              backgroundImage: NetworkImage('${SocialCubit
                                  .get(context)
                                  .userModel!
                                  .image}'),
                            ),
                            SizedBox(width: 15.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${SocialCubit.get(context).userModel!.name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                    'view main profile',
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                      height: 1.4,
                                    fontSize: 13.0
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    NavigateTo(context, FriendsScreen());
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(IconBroken.User),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text('Friends',
                          style: TextStyle(
                            fontSize: 20.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_sharp),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text('Dark Mode',
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: (){
                            SocialCubit.get(context).changeMode();
                          }, icon:
                      state is SocialChangeCurrentModeState?Icon(Icons.brightness_4):Icon(Icons.brightness_4_outlined)
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    signOut(context: context);
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text('Log Out',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}