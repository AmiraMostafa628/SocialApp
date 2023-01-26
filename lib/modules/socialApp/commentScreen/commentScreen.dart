import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  String? PostId;
  CommentScreen(this.PostId);

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppbar(
              context: context,
            title: 'Comments'
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ConditionalBuilder(
                  condition:  SocialCubit.get(context).comments.length>0,
                  builder: (context)=>Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>buildCommentItem(
                              SocialCubit.get(context).comments[index],context) ,
                          separatorBuilder: (context, index) =>SizedBox(
                            height: 20,
                          ),
                          itemCount: SocialCubit.get(context).comments.length),
                    ),
                  ),
                  fallback: (context)=>Expanded(child: Center(child: Text('No Comments yet'))),
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    if(SocialCubit.get(context).commentImage !=null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 30.0.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  image:  DecorationImage(
                                      image: FileImage(SocialCubit.get(context).commentImage!),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                SocialCubit.get(context).removeCommentImage();
                              },
                              icon: CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.close,
                                  //Icons.camera_alt_rounded,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.grey[300],
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,

                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0
                      ),
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],

                       ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              SocialCubit.get(context).getcommentImage();
                            },
                            icon: Icon(IconBroken.Image),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: commentController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'write a comment',
                                  border: InputBorder.none
                            ),
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              final now = DateTime.now();
                              if(SocialCubit.get(context).commentImage == null){
                                SocialCubit.get(context).UploadCommentText(
                                  postId: PostId!,
                                  text: commentController.text,
                                    dateTime: now.toString()
                                );
                                commentController.text='';
                                }else
                                {
                                  SocialCubit.get(context).uploadCommentImage(
                                      text: commentController.text,
                                      postId: PostId!,
                                      dateTime: now.toString()

                                  );
                                  commentController.text='';
                                  SocialCubit.get(context).removeCommentImage();
                                }

                            },
                            icon: Icon(IconBroken.Send),
                          ),
                        ],
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }
  Widget buildCommentItem(CommentModel model,context)
  {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('${model.image}'),
          radius: 30,
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10.0),
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: SocialCubit.get(context).isDark
                      ? HexColor('272a2c').withOpacity(.5)
                      : Colors.grey[300],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    Text(
                      '${model.text}',


                    ),

                  ],
                ),
              ),
              if(model.commentImage !=null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage('${model.commentImage}'),
                        fit: BoxFit.cover,
                    ),
                ),
              ),
                  )
            ],
          ),
        ),

      ],
    );
  }
}
