import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/HomeLayout.dart';
import 'package:social_app/modules/socialApp/Register/socialRegisterScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/style/color.dart';
import '../change password/changePassword.dart';
import 'Login_cubit/Login_cubit.dart';
import 'Login_cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {

  var formKey= GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<SocialLoginCubit,SocialLoginStates>(
      listener: (context,state){
        if(state is SocialLoginSuccessState)
          {
            CacheHelper.saveData(key: 'uId', value: state.uId)
                .then((value) {
                  uId = state.uId;
                  SocialCubit.get(context).currentIndex=0;
                  SocialCubit.get(context).getUserData();
                  SocialCubit.get(context).getAllUsers();
                  SocialCubit.get(context).getFriendRequest(uId);
                  SocialCubit.get(context).getFriends();
                  SocialCubit.get(context).getPosts();
                  navigateAndFinish(context, HomeLayout());
            });

          }
       /* if(state is SocialLoginGoogleUserSuccessState)
        {
          CacheHelper.saveData(key: 'uId', value: state.uId)
              .then((value) {
            uId = state.uId;
            SocialCubit.get(context).currentIndex=0;
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getAllUsers();
            SocialCubit.get(context).getFriendRequest(uId);
            SocialCubit.get(context).getFriends();
            SocialCubit.get(context).getPosts();
            navigateAndFinish(context, HomeLayout());
          });

        }*/
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(image: AssetImage('assets/images/Login.jpg'),
                        height: 150,
                        width: double.infinity,
                      ),
                      Text('Login',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 25,
                              color: SocialCubit.get(context).isDark?Colors.white:Colors.black
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: ( value)
                          {
                            if (value!.isEmpty) {
                              return 'Email Can not be Empty';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        isPassword: SocialLoginCubit.get(context).ispassword,
                        suffixPressed: (){
                          SocialLoginCubit.get(context).changePasswordVisibility();
                        },
                        validate: ( value)
                        {
                          if (value!.isEmpty) {
                            return 'password is too short';
                          }
                        },
                        label: 'Password',
                        prefix: Icons.lock,
                        suffix: SocialLoginCubit.get(context).suffix,

                      ),
                      SizedBox(
                        height: 30,
                      ),
                      defaultButton(
                          function: (){
                            if(formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              );

                            }
                          },
                          background: defaultColor,
                          text: 'login'),
                     defaultTextButten(
                         function: (){
                               NavigateTo(context, ChangePasswordScreeen());
                         },
                         text: 'Forgotten Password?'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(height: 1.1),
                          ),
                          defaultTextButten(
                              function:(){
                                NavigateTo(
                                    context,
                                    SocialRegisterScreen());
                              },
                              color: defaultColor,
                              text: 'Register')
                        ],
                      ),
                     /* Center(
                        child: InkWell(
                          onTap: (){
                            SocialLoginCubit.get(context).signInWithGoogle();
                          },
                          child: CircleAvatar(
                            child: state is SocialLoginGoogleUserLoadingState?
                            CircularProgressIndicator() :
                            Image(
                              image:AssetImage('assets/images/Google_Logo.png',),
                              width: 50,
                              height: 50,),
                            backgroundColor: Colors.white.withOpacity(0),
                          ),
                        ),
                      ),*/
                    ],

                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}