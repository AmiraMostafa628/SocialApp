import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/Friends/Friends.dart';
import 'package:social_app/modules/socialApp/friendRequests/friendRequests.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constant.dart';

class UsersScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return  BlocConsumer<SocialCubit,SocialStates>(
          listener: (context, state) {

          },
          builder: (context, state) {
            var users= SocialCubit.get(context).users;
            SocialCubit cubit=SocialCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35.0,
                        //padding: EdgeInsetsDirectional.zero,
                        decoration: BoxDecoration(
                            color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: MaterialButton(
                          onPressed: (){
                            NavigateTo(context, FriendRequestScreen());
                          },
                          child: Text(
                            'Friend Requests',
                            style: TextStyle(
                                color: SocialCubit.get(context).isDark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                            ),
                          ),

                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        height: 35.0,
                        //padding: EdgeInsetsDirectional.zero,
                        decoration: BoxDecoration(
                            color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: MaterialButton(
                          onPressed: (){
                            NavigateTo(context, FriendsScreen());
                          },
                          child: Text(
                            'Your Friends',
                            style: TextStyle(
                                color: SocialCubit.get(context).isDark?Colors.white:Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                            ),
                          ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,),
                  Text(
                    'Peaple you may know',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                    ),
                  ),
                  SizedBox(
                    height: 10.0,),
                  Expanded(
                    child: StreamBuilder<SocialCubit>(
                      builder: (context, snapshot) {
                        return ConditionalBuilder(
                              condition: state is !SocialGetAllUsersLoadingStates && SocialCubit.get(context).users.length>0,
                              builder: (context)=>ListView.separated(
                                  itemBuilder: (context,index)
                                  {
                                    return  buildUserItem(
                                          users[index],
                                          cubit.isFriend[users[index].uId],
                                          cubit.isrequest[users[index].uId],

                                          context);},
                                  separatorBuilder: (context,index)=> myDivider(),
                                  itemCount: SocialCubit.get(context).users.length),
                              fallback: (context)=>Center(child: CircularProgressIndicator()),
                            );

                      }
                    )
                    ),
                ],
              ),
            );
          },
        );

  }

  Widget buildUserItem(SocialUserModel model,bool? isfriend,bool? isrequest,context) {

    return Padding(
              padding: const EdgeInsets.symmetric(vertical: 17.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${model.image}'),
                    radius: 32,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style: TextStyle(height: 1.4, fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      if(isrequest==true)
                        Row(
                        children: [
                          Container(
                            height: 35.0,
                            decoration: BoxDecoration(
                                color: SocialCubit.get(context).isDark
                                    ? HexColor('272a2c').withOpacity(.5)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MaterialButton(
                                onPressed: () {
                                  showAlertDialog(
                                      text: 'Are you Sure to unrequest this Person',
                                      context: context,
                                      actions: [
                                        Container(
                                          height: 35.0,
                                          //padding: EdgeInsetsDirectional.zero,
                                          decoration: BoxDecoration(
                                              color:Colors.blue,
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          child: MaterialButton(
                                              onPressed: (){
                                                SocialCubit.get(context).deleteFriendRequest(friendId: model.uId!);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'unrequest',
                                                style: TextStyle(color: Colors.white,fontSize: 15.0),
                                              )


                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Container(
                                          height: 35.0,
                                          //padding: EdgeInsetsDirectional.zero,
                                          decoration: BoxDecoration(
                                              color:Colors.grey[300],
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          child: MaterialButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.black,fontSize: 15.0),
                                              )


                                          ),
                                        ),
                                      ]
                                  );
                                },
                                child: Text(
                                  'requested',
                                  style: TextStyle(
                                      color: SocialCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black, fontSize: 15.0),
                                )),
                          ),
                        ],
                      )
                      else if(isfriend==true)
                        Row(
                          children: [
                            Container(
                              height: 35.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  color: SocialCubit.get(context).isDark
                                      ? HexColor('272a2c').withOpacity(.5)
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10.0)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Center(
                                child: Text(
                                  'friend',
                                  style: TextStyle(
                                     color: SocialCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 17.0
                                  ),
                                ),
                              )

                            ),

                          ],
                        )
                      else
                        Row(
                          children: [
                            Container(
                              height: 35.0,
                              //padding: EdgeInsetsDirectional.zero,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: MaterialButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendFriendRequest(
                                      friendId: model.uId!,
                                    );
                                    SocialCubit.get(context).sendNotification(
                                        token: model.token!,
                                        name: SocialCubit.get(context).userModel!.name!,
                                        text: 'sent you a friend request',
                                    );
                                    SocialCubit.get(context).sendNotificationInApp(
                                        name: SocialCubit.get(context).userModel!.name!,
                                        text: 'sent you a friend request',
                                        dateTime: DateTime.now().toString(),
                                        friendId: model.uId!,
                                        image: SocialCubit.get(context).userModel!.image!,
                                        icon: 'https://cdn-icons-png.flaticon.com/512/1057/1057240.png',

                                    );
                                    SocialCubit.get(context).getNotification();
                                  },
                                  child: Text(
                                    'Add friend',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  )),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Container(
                              height: 35.0,
                              decoration: BoxDecoration(
                                color: SocialCubit.get(context).isDark
                                    ? HexColor('272a2c').withOpacity(.5)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: MaterialButton(
                                onPressed: () {
                                  SocialCubit.get(context).removeuser(model);
                                },
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      color: SocialCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            );

  }
}
