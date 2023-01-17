import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/login/Login_cubit/states.dart';
import 'package:social_app/shared/components/constant.dart';


class SocialLoginCubit extends Cubit <SocialLoginStates> {

  SocialLoginCubit() : super(SocialLoginIntialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  SocialUserModel? userLoginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
          print(value.user!.uid);
      emit(SocialLoginSuccessState(value.user!.uid));
    }).
    catchError((error) {
      print(error.toString());
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    emit(SocialLoginGoogleUserLoadingState());
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      isUserExist(
        name: value.user!.displayName!,
        email: value.user!.email!,
        uId: value.user!.uid,
        profilePic: value.user!.photoURL!,
      );
      emit(SocialLoginGoogleUserSuccessState(value.user!.uid));
    });
  }
 bool userState=false;
  Future <void> isUserExist({
    required String uId,
    required String name,
    required String email,
    required String profilePic

  }) async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.id == uId)
          userState = true;
      });
      if(userState == false) {
        createGoogleUser(
            uId: uId,
            name: name,
            email: email,
            image: profilePic,

        );
      }
      else
        emit(SocialLoginGoogleUserSuccessState(uId));
    });
  }

  void createGoogleUser({
    required String name,
    required String email,
    required String uId,
    required String image,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone:'00000000000',
      uId: uId,
      image: image,
      cover: 'https://img.freepik.com/free-photo/group-people-working-out-business-plan-office_1303-15779.jpg',
      bio: 'write your bio...',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()!).then((value) {
      emit(SocialCreateGoogleUserSuccessState());
    }).catchError((error)
    {
      emit(SocialCreateGoogleUserErrorState());
    });
  }


    IconData suffix =Icons.visibility_outlined;
    bool ispassword= true;
    void changePasswordVisibility()
    {
      ispassword = !ispassword;
      suffix = ispassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
      emit(SocialChangePasswordVisibilityState());
    }
  }
