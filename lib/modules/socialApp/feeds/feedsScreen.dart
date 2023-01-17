import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/modules/socialApp/Post/postScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';
import '../commentScreen/commentScreen.dart';

class FeedsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {
        if(SocialCubit.get(context).postImage!=null)
          {
            NavigateTo(context, NewPostsScreen());

          }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (SocialCubit.get(context).userModel!=null)
              Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5.0,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5.0,
                    left: 5.0
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 27.0,
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).userModel!.image}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0,),
                          child: CircleAvatar(
                            radius: 6.0,
                            backgroundColor: Colors.green,
                          ),
                        ),

                      ],),
                    SizedBox(width: 15.0,),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],
                          ) ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0,bottom: 5.0,top: 6.0),
                            child: Text(
                                'What\'s in your mind?',
                              style: TextStyle(
                                  color: SocialCubit.get(context).isDark?Colors.white:Colors.black,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        onTap: (){
                          NavigateTo(context, NewPostsScreen());
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          SocialCubit.get(context).getPostImage();
                        }, icon: Icon(
                          IconBroken.Image,
                          size: 35,
                        ),
                        ),
                        Text('Photo'),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: ConditionalBuilder(
                condition: SocialCubit.get(context).posts.length>0&&SocialCubit.get(context).userModel!=null,
                builder: (context)=>SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index)=> buildPostItem(
                        SocialCubit.get(context).posts[index],
                        SocialCubit.get(context).postsId[index],
                        SocialCubit.get(context).MyLikedPost[SocialCubit.get(context).postsId[index]],
                        SocialCubit.get(context).commentsNumber[SocialCubit.get(context).postsId[index]],
                        context),
                    separatorBuilder:(context,index)=>SizedBox(height: 8.0,),
                    itemCount: SocialCubit.get(context).posts.length,),
                ),
                fallback: (context)=>Center(child: CircularProgressIndicator()),

              ),
            ),
          ],
        );
      },
    );
  }

}

