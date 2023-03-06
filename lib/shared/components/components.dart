import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/shared/network/style/color.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';

import '../../models/PostModel.dart';
import '../../modules/socialApp/commentScreen/commentScreen.dart';
import '../cubit/cubit.dart';
import 'constant.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  double radius = 10.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButten({
  required Function function,
  required String text,
  Color color = Colors.blue,

})=>TextButton(
    onPressed: (){function();},
    child: Text(
        text,
      style: TextStyle(
        color: color,
        height: 1.1
      ),
    )

);

Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  FormFieldValidator? validate,
  Function? onSubmit,
  double radius = 10.0,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword =false,
  Function? suffixPressed,
  bool isClickable = true,
  Color? color,
  Color? iconColor,
}

) => TextFormField(
  controller: controller,
  style: TextStyle(
      color: color,
    fontSize: 16,
    height: 1.2,
  ),
  keyboardType:type ,
  obscureText: isPassword,
  onFieldSubmitted:(s){
    onSubmit!(s);
  },
  validator: (value) {
    return validate!(value);
  },
  enabled: isClickable,

  decoration: InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: color,
      fontSize: 14,
    ) ,
    prefixIcon: Icon(
      prefix,
      color: color,),
    suffixIcon: suffix!= null ? IconButton(
        onPressed: () {
          suffixPressed!();
        },
        icon:Icon(suffix),color: iconColor,) : null ,
    border:OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius)
    ),

  ),



);

PreferredSizeWidget defaultAppbar(
{
  required BuildContext? context,
  String? title,
  List <Widget>? actions,

}
    )=>AppBar(
     leading: IconButton(
       onPressed: (){
         Navigator.pop(context!);
       },
       icon: Icon(IconBroken.Arrow___Left_2),
     ),
     title: Text(title!),
  titleSpacing: 5.0,
  actions: actions,
);

void NavigateTo(context,Widget)=>Navigator.push(
    context,
    MaterialPageRoute(
      builder:(context) => Widget,
    )
);

void navigateAndFinish(context,Widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder:(context) => Widget,
    ),
        (route) => false);

void showToast(
    {
      required text,
      required ToastState state,

    }
)=>Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum ToastState {SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastState state)
{
  Color? color;

  switch(state)
  {
    case ToastState.SUCCESS:
       color = Colors.green;
       break;
    case ToastState.ERROR:
       color = Colors.red;
       break;
    case ToastState.WARNING:
       color = Colors.amber;
       break;
  }
  return color;
}

/*
void showSnackBar(
    context,
    {
      required text,
      required ToastState state,

    }
    )
{
  final snackBar=  SnackBar(
      content: Text('$text'),
      backgroundColor:chooseToastColor(state),

    );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}
*/
void showAlertDialog({
  required String text,
  required List <Widget>? actions,
  required BuildContext context
})
{
AlertDialog alert = AlertDialog(
content: Text(text),
actions: actions,
);
showDialog(
  context: context,
  builder: (BuildContext context) {
    return alert;
  },
);
}


Widget myDivider() =>Padding(
  padding: const EdgeInsetsDirectional.only(start: 10.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget buildPostItem(
      PostModel model,
      String id,
      String? MylikedPost,
      int? commentNumber,
    context){
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${model.image}'),
                radius: 25,
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(
                                height: 1.4
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      Text(
                        '${model.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.4
                        ),
                      )
                    ],
                  )),
              SizedBox(
                width: 15.0,
              ),
              if(model.uId==uId)
                IconButton(
                onPressed: ()
                {
                  showAlertDialog(
                      text: 'Are you Sure to remove this post',
                      actions: [
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

                                 SocialCubit.get(context).removePost(postId: id);
                                 Navigator.of(context).pop();
                              },
                              child: Text(
                                'remove',
                                style: TextStyle(color: Colors.white,fontSize: 15.0),
                              )


                          ),
                        ),
                        SizedBox(width: 15,),
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
                      ], context: context);

                  },
                icon: Icon(
                  Icons.more_horiz,
                  size: 16.0,
                ),

              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 15.0
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          if(model.text !='')
            Text(
              '${model.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          if(model.postImage !=null)
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 5.0,
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                        image: NetworkImage('${model.postImage}'),
                        fit: BoxFit.cover)),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        MylikedPost==uId?Icon(
                          Icons.favorite,
                          size: 16.0,
                          color: Colors.red,
                        ):Icon(
                          IconBroken.Heart,
                          size: 16.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${SocialCubit.get(context).LikesNumber[id]}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  onTap: (){},
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          IconBroken.Chat,
                          size: 16.0,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${commentNumber} comments',
                          style: Theme.of(context).textTheme.caption,
                        ),

                      ],
                    ),
                  ),
                  onTap: (){
                    SocialCubit.get(context).getComment(id);
                    NavigateTo(context, CommentScreen(id,model));
                  },
                ),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${SocialCubit.get(context).userModel!.image}'),
                        radius: 18,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'write a comment...',
                        style: Theme.of(context).textTheme.caption!.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                  onTap: (){
                    SocialCubit.get(context).getComment(id);
                    NavigateTo(context, CommentScreen(id,model));
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).sendNotificationInApp(
                    name: SocialCubit.get(context).userModel!.name!,
                    text: 'reacted with your post',
                    dateTime: DateTime.now().toString(),
                    friendId: model.uId!,
                    image: SocialCubit.get(context).userModel!.image!,
                    icon: 'https://cdn-icons-png.flaticon.com/512/1182/1182670.png',
                  );
                  SocialCubit.get(context).getNotification();
                  if(MylikedPost==uId)
                    SocialCubit.get(context).disLikePost(id);
                  if(MylikedPost!=uId)
                    SocialCubit.get(context).LikePosts(id);
                },
              ),

            ],
          )
        ],

      ),
    ),
  );
}


