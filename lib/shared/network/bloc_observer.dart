import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver{
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate-- ${bloc.runtimeType}');
  }

    void onChange(BlocBase bloc,Change change) {
      super.onChange(bloc,change);
      print('onCreate-- ${bloc.runtimeType},$change');
    }

  void onError(BlocBase bloc,Object error,StackTrace stackTrace) {
    super.onError(bloc,error,stackTrace);
    print('onError-- ${bloc.runtimeType},$error');
  }


  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose-- ${bloc.runtimeType}');
  }

}