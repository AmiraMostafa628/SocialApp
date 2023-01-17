import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/chat_details/chat_details_Screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).friends.length>0,
          builder: (context)=>ListView.separated(
              itemBuilder: (context,index)=>buildChatItem(
                  SocialCubit.get(context).friends[index],context),
              separatorBuilder: (context,index)=> myDivider(),
              itemCount: SocialCubit.get(context).friends.length),
          fallback: (context)=>Center(child: Text('No friends yet')),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model,context) => InkWell(
    onTap: (){
      NavigateTo(context, ChatDetailsScreen(userModel: model));
    },
    child: Padding(
      padding: const EdgeInsets.all(17.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${model.image}'),
            radius: 32,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
                height: 1.4,
              fontSize: 20.0
            ),
          ),

        ],
      ),
    ),
  );
}
