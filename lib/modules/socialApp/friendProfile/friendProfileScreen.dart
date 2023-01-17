import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/shared/components/components.dart';

import '../../../models/SocialUserModel.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/network/style/icon_broken.dart';

class FriendProfileScreen extends StatelessWidget {
  SocialUserModel friendModel;
  FriendProfileScreen({required this.friendModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return  Scaffold(
          appBar: AppBar(
            title:Text(
              '${friendModel.name}',
              style: TextStyle(
                  fontSize: 24
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: friendModel!=null,
            builder: (context)=>SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(1.0.h),
                child: Column(
                  children: [
                    Container(
                      height: 37.0.h,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Container(
                              height: 30.0.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    topLeft: Radius.circular(4.0),
                                  ),
                                  image:  DecorationImage(
                                      image:  NetworkImage('${friendModel.cover}'),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          CircleAvatar(
                            radius: 54,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                                radius: 50,
                                backgroundImage:NetworkImage('${friendModel.image}')
                            ),
                          )

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${friendModel.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${friendModel.bio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: 10.0,),
                    SocialCubit.get(context).friendPosts.length>0?
                      ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index)=> buildPostItem(
                          SocialCubit.get(context).friendPosts[index],
                          SocialCubit.get(context).postsId[index],
                          SocialCubit.get(context).MyLikedPost[SocialCubit.get(context).postsId[index]],
                          SocialCubit.get(context).commentsNumber[SocialCubit.get(context).postsId[index]],
                          context),
                      separatorBuilder:(context,index)=>SizedBox(height: 8.0,),
                      itemCount: SocialCubit.get(context).friendPosts.length,):Center(child: Text('No posts yet'))


                  ],
                ),
              ),
            ),
            fallback: (context)=>Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
