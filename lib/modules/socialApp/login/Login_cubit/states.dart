abstract class SocialLoginStates {}

class SocialLoginIntialState extends SocialLoginStates{}

class SocialLoginLoadingState extends SocialLoginStates{}

class SocialLoginSuccessState extends SocialLoginStates{
  final String uId;

  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginStates{
}

class SocialChangePasswordVisibilityState extends SocialLoginStates{}

class SocialChangePasswordSuccessState extends SocialLoginStates{}

class SocialChangePasswordErrorState extends SocialLoginStates{
  final String error;

  SocialChangePasswordErrorState(this.error);
}

/*
class SocialLoginGoogleUserLoadingState extends SocialLoginStates{}

class SocialLoginGoogleUserSuccessState extends SocialLoginStates{
  final String uId;

  SocialLoginGoogleUserSuccessState(this.uId);
}

class SocialCreateGoogleUserSuccessState extends SocialLoginStates{}

class SocialCreateGoogleUserErrorState extends SocialLoginStates{}

*/

