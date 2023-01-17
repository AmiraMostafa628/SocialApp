import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/HomeLayout.dart';
import 'package:social_app/modules/socialApp/login/LoginScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/style/color.dart';
import '../../../shared/components/constant.dart';
import '../../../shared/components/constant.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'Register_cubit/register_cubit.dart';
import 'Register_cubit/states.dart';

class SocialRegisterScreen extends StatelessWidget {

  var formKey= GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
        listener: (context,state){
          if(state is SocialCreateUserSuccessState)
            {
              CacheHelper.saveData(key: 'uId', value: state.uId)
                  .then((value) {
                uId = state.uId;
                SocialCubit.get(context).currentIndex=0;
                SocialCubit.get(context).getUserData();
                SocialCubit.get(context).getAllUsers();
                navigateAndFinish(context, HomeLayout());
              });
            }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REGISTER',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: SocialCubit.get(context).isDark?Colors.white:Colors.black
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: ( value)
                          {
                            if (value!.isEmpty) {
                              return 'name must not be Empty';
                            }
                          },
                          label: 'UserName',
                          prefix: Icons.person),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: ( value)
                          {
                            if (value!.isEmpty) {
                              return 'Email must not be Empty';
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
                        isPassword: SocialRegisterCubit.get(context).ispassword,
                        suffixPressed: (){
                          SocialRegisterCubit.get(context).changePasswordVisibility();
                        },
                        validate: ( value)
                        {
                          if (value!.isEmpty) {
                            return 'password is too short';
                          }
                        },
                        label: 'Password',
                        prefix: Icons.lock,
                        suffix: SocialRegisterCubit.get(context).suffix,

                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: ( value)
                          {
                            if (value!.isEmpty) {
                              return 'phone must not be Empty';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone),

                      SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is !SocialRegisterLoadingState,
                        builder: (context)=>defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            background: defaultColor,
                            text: 'Sign up'
                        ) ,
                        fallback: (context)=>Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already  have an account',
                            style: TextStyle(
                            ),
                          ),
                          defaultTextButten(
                              function:(){
                                NavigateTo(
                                    context,
                                    SocialLoginScreen());
                              },
                              color: defaultColor,
                              text: 'Login')
                        ],
                      )
                    ],

                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
