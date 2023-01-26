import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/socialApp/friendProfile/friendProfileScreen.dart';

import '../../../models/SocialUserModel.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constant.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(

            title:Text(
              'Friends',
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
                    condition: SocialCubit.get(context).friends.length>0,
                    builder: (context)=>ListView.separated(
                        itemBuilder: (context,index)=>buildFriendItem(
                            SocialCubit.get(context).friends[index],
                            context),
                        separatorBuilder: (context,index)=> myDivider(),
                        itemCount: SocialCubit.get(context).friends.length),
                    fallback: (context)=>Center(child: Text('No Friends Yet')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFriendItem(SocialUserModel model,context) => InkWell(
    onTap: (){
      SocialCubit.get(context).getfriendPosts(friendId: model.uId!);
      NavigateTo(context, FriendProfileScreen(friendModel: model));
    },
    child: Padding(
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
          Text(
            '${model.name}',
            style: TextStyle(
                height: 1.4,
                fontSize: 17.0
            ),
          ),
          Spacer(),
          IconButton(
              onPressed: ()
          {
            showAlertDialog(
                text: 'Are you Sure to unFriend this Person',
                context: context,
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              SocialCubit.get(context).unFriend(friendId: model.uId!);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'unfriend',
                              style: TextStyle(color: Colors.white,fontSize: 15.0),
                            )


                        ),
                      ),
                      SizedBox(width: 30,),
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
                    ],
                  )
                ]
            );
          }, icon: Icon(Icons.delete))

        ],
      ),
    ),
  );
}
