import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/Register/Register_cubit/states.dart';

class SocialRegisterCubit extends Cubit <SocialRegisterStates>{

  SocialRegisterCubit() : super(SocialRegisterIntialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,

})
  {
    emit(SocialRegisterLoadingState());
     FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: email,
         password: password)
         .then((value) {
           usercreate(
               name: name,
               email: email,
               phone: phone,
               uId: value.user!.uid);

     }).catchError((error){
       print(error.toString());
           emit(SocialRegisterErrorState(error));
     });
    }
  void usercreate({
    required String name,
    required String email,
    required String phone,
    required String uId,

  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: 'https://th.bing.com/th/id/OIP.sI785-ID81k_cRy1e__uawHaJs?pid=ImgDet&w=207&h=270&c=7',
      cover: 'https://img.freepik.com/free-photo/group-people-working-out-business-plan-office_1303-15779.jpg',
      bio: 'write your bio...',
      isEmailVerified: false,
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
