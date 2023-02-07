import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/models/MessageModel.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/color.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({required this.userModel});

  var messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId!);
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){
            if(state is SocialSendMessageSuccessStates)
              {
                messageController.text='';
                SocialCubit.get(context).removeMessageImage();
              }

          },
          builder: (context,state){
            final now = DateTime.now();
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text('${userModel.name}')
                  ],
                ),
              ),
              body:Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: SocialCubit.get(context).messages.length>0,
                        builder: (context)=> Column(
                          children: [
                           Expanded(
                             child: ListView.separated(
                                 itemBuilder: (context,index){
                                   var message = SocialCubit.get(context).messages[index];
                                   if(uId==message.senderId)
                                     return buildSenderItem(message,context);

                                   return buildReceiverItem(message,context);
                                 },
                                 separatorBuilder: (context,index)=>SizedBox(height: 10.0,),
                                 itemCount: SocialCubit.get(context).messages.length),
                           ),
                            if(SocialCubit.get(context).messageImage !=null)
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      height: 20.0.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4.0),
                                          image:  DecorationImage(
                                              image: FileImage(SocialCubit.get(context).messageImage!),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        SocialCubit.get(context).removeMessageImage();
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
                          ],
                        ),
                        fallback: (context)=>Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              SocialCubit.get(context).getmessageImage();
                            },
                            icon: Icon(IconBroken.Image),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0
                              ),
                              child: TextFormField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'write your message here',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: defaultColor,
                            height: 50.0,
                            child: MaterialButton(
                              onPressed: (){
                                if(SocialCubit.get(context).messageImage==null) {
                                  SocialCubit.get(context).sendMessage(
                                      receiverId: userModel.uId!,
                                      dateTime: now.toString(),
                                      text: messageController.text);
                                }else
                                {
                                  SocialCubit.get(context).uploadMessageImage(
                                      receiverId: userModel.uId!,
                                      dateTime: now.toString(),
                                      text: messageController.text);
                                }
                                /*SocialCubit.get(context).sendNotification(
                                    token: userModel.token!,
                                    name: SocialCubit.get(context).userModel!.name!,
                                    text: 'sent you a message');*/
                              },
                              minWidth: 1.0,
                              child: Icon(
                                IconBroken.Send,
                                size: 16.0,
                                color: Colors.white,
                              ),

                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget buildReceiverItem(MessageModel model,context)=> Align(
    alignment: AlignmentDirectional.centerStart,
    child: Column(
      children: [
        if(model.text!='')
          Container(
          padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomEnd: Radius.circular(10.0),

              )
          ),
          child: Text(model.text!,
            style: TextStyle(color: Colors.black),
          ),
        ),
        if(model.messageImage !=null)
          Container(
            height: 150,
            width: 120,
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage('${model.messageImage}'),
                fit: BoxFit.cover,
              ),
            ),
          )
      ],
    ),
  );

  Widget buildSenderItem(MessageModel model,context)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Column(
      children: [
        if(model.text!='')
          Container(
          padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0
          ),
          decoration: BoxDecoration(
              color: defaultColor.withOpacity(.2),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomStart: Radius.circular(10.0),

              )
          ),
          child: Text(model.text!),
        ),
        if(model.messageImage !=null)
          Container(
            height: 150,
            width: 120,
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage('${model.messageImage}'),
                fit: BoxFit.cover,
              ),
            ),
          )

      ],
    ),
  );
}
