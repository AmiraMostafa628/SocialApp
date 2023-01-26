import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/Register/Register_cubit/states.dart';
import 'package:social_app/modules/socialApp/login/LoginScreen.dart';
import 'package:social_app/shared/components/components.dart';

class SocialRegisterCubit extends Cubit <SocialRegisterStates>{

  SocialRegisterCubit() : super(SocialRegisterIntialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  
  Future userRegister ({
    required String email,
    required String password,
    required BuildContext context

})async
  {
    emit(SocialRegisterLoadingState());
    try {
      UserCredential usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(usercredential.user!.emailVerified==false) {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.sendEmailVerification();
        showToast(text: 'check your email to verify it', state: ToastState.SUCCESS);
        NavigateTo(context, SocialLoginScreen());
      }
      emit(SocialRegisterSuccessState());
      return usercredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AwesomeDialog(
          context: context,
          title: 'Error',
          desc:'The password provided is too weak.',
          btnOkOnPress: () {},
          onDismissCallback: (type) {
            Navigator.pop;
          },

        )..show();

        emit(SocialRegisterErrorState());
      } else if (e.code == 'email-already-in-use') {
        AwesomeDialog(
          context: context,
          title: 'Error',
          desc:'The account already exists for that email.',
          btnOkOnPress: () {},
          onDismissCallback: (type) {
            Navigator.pop;
          },
        )..show();
        emit(SocialRegisterErrorState());
      }
    } catch (e) {
      print(e);
      emit(SocialRegisterErrorState());
    }

    }
  void usercreate({
    required String name,
    required String email,
    required String uId,

  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      uId: uId,
      image: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      cover: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
      bio: 'write your bio...',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()!).then((value) {
            emit(SocialCreateUserSuccessState(uId));
    }).catchError((error)
    {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

    IconData suffix =Icons.visibility_outlined;
    bool ispassword= true;
    void changePasswordVisibility()
    {
      ispassword = !ispassword;
      suffix = ispassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
      emit(SocialRegisterChangePasswordVisibilityState());
    }
  }
