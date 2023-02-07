import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/modules/socialApp/edit_profile/edit_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

import '../Post/postScreen.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        var userModel = SocialCubit.get(context).userModel!;
        return  ConditionalBuilder(
          condition:  userModel !=null,
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
                                    image:  NetworkImage('${userModel.cover}'),
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
                              backgroundImage:NetworkImage('${userModel.image}')
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${userModel.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${userModel.bio}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child:Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: MaterialButton(
                        color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],
                        onPressed: () {
                          NavigateTo(context,EditProfileScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10.0,),
                            Text(
                                'Edit Profile',
                              style: TextStyle(
                                  fontSize: 17.0,

                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  ),
                  SizedBox(height: 10.0,),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5.0,
                    margin: EdgeInsets.zero,
                    child: Center(
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
                                          color: SocialCubit.get(context).isDark?Colors.white:Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  NavigateTo(context, NewPostsScreen());
                                },
                              ),
                            ),
                            Column(
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
                  ),
                  SizedBox(height: 10.0,),
                  SocialCubit.get(context).myPosts.length>0?
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index)=> buildPostItem(
                        SocialCubit.get(context).myPosts[index],
                        SocialCubit.get(context).mypostsId[index],
                        SocialCubit.get(context).MyLikedPost[SocialCubit.get(context).mypostsId[index]],
                        SocialCubit.get(context).commentsNumber[SocialCubit.get(context).mypostsId[index]],
                        context),
                    separatorBuilder:(context,index)=>SizedBox(height: 8.0,),
                    itemCount: SocialCubit.get(context).myPosts.length,):Center(child: Text('No posts yet')),
                  SizedBox(height: 30.0,),

                ],
              ),
            ),
          ),
          fallback:(context) =>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
