import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/modules/socialApp/feeds/feedsScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

class NewPostsScreen extends StatelessWidget {

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {
        if(state is SocialCreatePostSuccessStates)
          {
            Navigator.pop(context);
            SocialCubit.get(context).removePostImage();
            textController.text='';
          }
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        return StreamBuilder<SocialCubit>(
          builder: (context, snapshot) {
            return Scaffold(
              appBar: defaultAppbar(
                  context: context,
                  title: 'Create Post',
                  actions: [
                    defaultTextButten(
                        function: (){
                          final now = DateTime.now();
                          if(SocialCubit.get(context).postImage == null){
                          SocialCubit.get(context).createNewPost(
                              text: textController.text,
                              datetime: now.toString(),
                              name: userModel.name,
                              image: userModel.image,
                          );
                        }else
                          {
                            SocialCubit.get(context).uploadPostImage(
                                text: textController.text,
                                datetime:now.toString(),
                                name: userModel.name,
                                image: userModel.image,
                            );
                          }
                      },
                        text: 'Post'),
                    SizedBox(
                      width: 15.0,
                    ),
                  ]
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            if(state is SocialCreatePostLoadingStates)
                              LinearProgressIndicator(),
                            if(state is SocialCreatePostLoadingStates)
                              SizedBox(
                                height: 10.0,
                              ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage('${userModel.image}'),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${userModel.name}',
                                          style: TextStyle(
                                              height: 1.4,
                                            fontSize: 17.0
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                           Container(
                             height: 100,
                             child: TextFormField(
                                 controller: textController,
                                 keyboardType: TextInputType.multiline,
                                 decoration: InputDecoration(
                                     hintText:'What is in your mind...',
                                     border: InputBorder.none
                                 )
                             ),
                           ),
                           SizedBox(height: 50,),
                           if (SocialCubit.get(context).postImage != null)
                             Stack(
                               alignment: AlignmentDirectional.topEnd,
                               children: [
                                 Container(
                                   height: 30.0.h,
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(4.0),
                                       image:  DecorationImage(
                                           image: FileImage(SocialCubit.get(context).postImage!),
                                           fit: BoxFit.cover
                                       )
                                   ),
                                 ),
                                 IconButton(
                                   onPressed: (){
                                     SocialCubit.get(context).removePostImage();
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: (){
                              SocialCubit.get(context).getPostImage();
                            }, child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Add Photo')
                          ],
                        ) ),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: (){}, child:Text('# tags') ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,)
                ],
              ),
            );
          }
        );
    });

  }
}
