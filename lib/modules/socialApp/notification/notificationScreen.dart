import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/models/notificationModel.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../../models/SocialUserModel.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SocialCubit>(

      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title:Text(
              'Notifications',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ConditionalBuilder(
                    condition: SocialCubit.get(context).Notifications.length>0,
                    builder:(context)=> ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)=>buildNovItem(SocialCubit.get(context).Notifications[index],context),
                        separatorBuilder:(context,index)=>SizedBox(height: 5.0,),
                        itemCount: SocialCubit.get(context).Notifications.length),
                    fallback:(context)=> Center(child: Text('No Notification yet'))),
              ),
            ],
          ),
        );
      }
    );
  }
}

Widget buildNovItem(NotificationModel model,context) => Container(
  width: double.infinity,
  color: SocialCubit.get(context).isDark?HexColor('272a2c').withOpacity(.5):Colors.grey[300],
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${model.image}'),
              radius: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CircleAvatar(
                backgroundImage: NetworkImage('${model.icon}'),
                radius: 12,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10.0,
        ),
       Expanded(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               '${model.name}',
               style: TextStyle(
                   height: 1.4,
                   fontWeight: FontWeight.bold,
                   fontSize: 17
               ),
             ),
             SizedBox(
               width: 5.0,
             ),
             Text(
               '${model.text}',
               style: TextStyle(
                   height: 1.4,
                   fontSize: 15
               ),
             )
           ],
         ),
       )
       

      ],
    )
));