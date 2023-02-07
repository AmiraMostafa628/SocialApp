import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../models/SocialUserModel.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constant.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class FriendRequestScreen extends StatelessWidget {

const FriendRequestScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


        return BlocConsumer<SocialCubit,SocialStates>(
         listener: (context, state) {},
          builder: ( context,state) {
            return Scaffold(
              appBar: AppBar(
                title:Text(
                  'Friend Requests',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 17.0
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: SocialCubit.get(context).friendRequest.length>0,
                        builder: (context)=>ListView.separated(
                            itemBuilder: (context,index)=>buildFriendRequestItem(
                                SocialCubit.get(context).friendRequest[index],
                                context),
                            separatorBuilder: (context,index)=> myDivider(),
                            itemCount: SocialCubit.get(context).friendRequest.length),
                        fallback: (context)=>Center(child: Text('No Friend Request Yet')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
         );


  }

  Widget buildFriendRequestItem(SocialUserModel model,context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 17.0
      ),
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
                style: TextStyle(
                    height: 1.4,
                    fontSize: 17.0
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Container(
                    height: 35.0,
                    //padding: EdgeInsetsDirectional.zero,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MaterialButton(
                      onPressed: () {
                        print(model.name);
                        SocialCubit.get(context).acceptFriend(
                          friendId: model.uId!,
                          name: model.name!,
                          image: model.image!,
                          cover: model.cover!,
                          bio: model.bio!,
                        );
                        SocialCubit.get(context).confirmFriendRequest(
                            friendId: model.uId!,
                            valuefriend: true,
                        );
                        SocialCubit.get(context).getFriendRequest(uId);
                        SocialCubit.get(context).getFriends();
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 12.0,),
                  Container(
                    height: 35.0,
                    //padding: EdgeInsetsDirectional.zero,
                    decoration: BoxDecoration(
                        color: SocialCubit
                            .get(context)
                            .isDark
                            ? HexColor('272a2c').withOpacity(.5)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MaterialButton(
                      onPressed: () {
                        SocialCubit.get(context).confirmFriendRequest(
                            friendId: model.uId!,
                          valuefriend: false,
                        );
                        SocialCubit.get(context).getFriendRequest(uId);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0
                        ),
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
