import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';



class EditProfileScreen extends StatelessWidget {


  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder:  (context,state){
        var userModel = SocialCubit.get(context).userModel!;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        
        nameController.text= userModel.name!;
        bioController.text=userModel.bio!;
        phoneController.text=userModel.phone!;

        return Scaffold(
            appBar: defaultAppbar(
                context: context,
                title: 'Edit Profile',
                actions: [
                  defaultTextButten(
                      function: (){
                        SocialCubit.get(context).updateUserData(
                            name: nameController.text,
                            phone: phoneController.text,
                            bio: bioController.text,
                            context: context
                        );
                      },
                      text: 'UPDATE'),
                  SizedBox(
                    width: 15.0,
                  ),
                ]
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(1.0.h),
                child: Column(
                  children: [
                    if(state is SocialUpdateUserdataLoadingStates)
                      LinearProgressIndicator(),
                    if(state is SocialUpdateUserdataLoadingStates)
                      SizedBox(
                        height: 15.0,
                      ),

                    Container(
                      height: 37.0.h,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 30.0.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(4.0),
                                        topLeft: Radius.circular(4.0),
                                      ),
                                      image:  DecorationImage(
                                          image: coverImage==null? 
                                          NetworkImage('${userModel.cover}') as ImageProvider:FileImage(coverImage),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                    icon: CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        IconBroken.Camera,
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
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 54,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: profileImage==null? 
                                    NetworkImage('${userModel.image}')as ImageProvider:FileImage(profileImage),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 18.0,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[300],
                                ),
                                color: Theme.of(context).scaffoldBackgroundColor,

                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(profileImage!=null||coverImage!=null)
                      Row(
                      children: [
                        if(profileImage!=null)
                           Expanded(
                              child: Column(
                                children: [
                                  defaultButton(
                                      function: (){
                                        SocialCubit.get(context).uploadProfileImage(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text,
                                          context: context,
                                        );
                                      },
                                      radius: 20.0,
                                      text: 'Upload Profile'),
                                  if(state is SocialUploadUserdataLoadingStates)
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  if(state is SocialUploadUserdataLoadingStates)
                                    LinearProgressIndicator(),
                                ],
                              ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if(coverImage!=null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    function: (){
                                      SocialCubit.get(context).uploadCoverImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text,
                                        context: context
                                      );
                                    },
                                     radius: 20.0,
                                     text:'Upload Cover',


                                ),
                                if(state is SocialUploadUserdataLoadingStates)
                                  SizedBox(
                                     height: 5.0,
                                  ),
                                if(state is SocialUploadUserdataLoadingStates)
                                    LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if(profileImage!=null||coverImage!=null)
                      SizedBox(
                      height: 15.0,
                    ),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        label: 'Name',
                        validate: (value)
                        {
                          if(value.isEmpty)
                            return 'name mustn\'t be empty';
                        },
                        prefix: IconBroken.User),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: bioController,
                        type: TextInputType.text,
                        label: 'bio...',
                        validate: (value)
                        {
                          if(value.isEmpty)
                            return 'bio mustn\'t be empty';
                        },
                        prefix: IconBroken.Info_Circle),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        label: 'Phone',
                        validate: (value)
                        {
                          if(value.isEmpty)
                            return 'phone mustn\'t be empty';
                        },
                        prefix: IconBroken.Call),
                  ],
                ),
              ),
            )
        );
      }
    );
  }
}
