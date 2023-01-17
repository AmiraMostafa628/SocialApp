import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/Friends/Friends.dart';
import 'package:social_app/modules/socialApp/friendRequests/friendRequests.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constant.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                child: ConditionalBuilder(
                  condition: SocialCubit.get(context).users.length>0,
                  builder: (context)=>ListView.separated(
                      itemBuilder: (context,index)=>buildUserItem(
                          SocialCubit.get(context).users[index],
                          state,
                          context),
                      separatorBuilder: (context,index)=> myDivider(),
                      itemCount: SocialCubit.get(context).users.length),
                  fallback: (context)=>Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildUserItem(SocialUserModel model,state,context) {
    SocialCubit.get(context).isFriendRequestExist(friendId:model.uId!);
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
              Row(
                children: [

                  state is SocialFriendRequestSuccessState ?
                  Container(
                          height: 35.0,
                          //padding: EdgeInsetsDirectional.zero,
                          decoration: BoxDecoration(
                              color: SocialCubit.get(context).isDark
                                  ? HexColor('272a2c').withOpacity(.5)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context)
                                  .deleteFriendRequest(friendId: model.uId!);
                            },
                            child: Text(
                              'requested',
                              style: TextStyle(
                                  color: SocialCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15.0),
                            ),
                          ),
                        )
                      : Container(
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
                                SocialCubit.get(context).getFriendRequest(uId);
                              },
                              child: Text(
                                'Add friend',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              )),
                        ),
                  SizedBox(
                    width: 10.0,
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
                        SocialCubit.get(context).users.remove(model);
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
