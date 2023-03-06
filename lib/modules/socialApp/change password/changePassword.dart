import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/socialApp/login/Login_cubit/Login_cubit.dart';
import 'package:social_app/shared/network/style/color.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../login/Login_cubit/states.dart';

class ChangePasswordScreeen extends StatelessWidget {


  var formKey= GlobalKey<FormState>();
  var emailController= TextEditingController();
  var password1Controller = TextEditingController();
  var password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context,state){},
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(image: AssetImage('assets/images/pass.jpg'),
                        height: 200,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Enter your Account',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
                        height: 20,
                      ),
                      defaultButton(
                          function: (){
                            if(formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).
                              changePassword(context, emailController.text);
                            }
                            showToast(text: 'check your email to change password',
                                state: ToastState.SUCCESS);
                          },
                          background: defaultColor,
                          text: 'Search'),
                    ],

                  ),
                ),
              ),
            ),
          );
    },
    );
  }
}
