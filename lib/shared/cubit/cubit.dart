import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/MessageModel.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/models/notificationModel.dart';
import 'package:social_app/modules/socialApp/Setting/SettingScreen.dart';
import 'package:social_app/modules/socialApp/chats/chatsScreen.dart';
import 'package:social_app/modules/socialApp/feeds/feedsScreen.dart';
import 'package:social_app/modules/socialApp/users/userssScreen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/network/style/icon_broken.dart';
import '../../modules/socialApp/profiles/profileScreen.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() :super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingStates());

   FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessStates());
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorStates(error.toString()));
    });
  }

  List <Widget> screens = [
    FeedsScreen(),
    UsersScreen(),
    ProfileScreen(),
    ChatsScreen(),
    SettingScreen(),

  ];

  List <String> titles = [
    'Home',
    'Users',
    'Profile',
    'Chats',
    'Setting',
  ];

  int currentIndex = 0;

  void changeBottomNav(int index) {
       getFriends();
       getFriendRequest(uId);
       getNotification();
      currentIndex = index;
      emit(ChangeBottomNavBarStates());

  }

  File? profileImage;
  var picker = ImagePicker();

  Future <void> getProfileImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorStates());
    }
  }

  File? coverImage;

  Future <void> getCoverImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorStates());
    }
  }

  void uploadProfileImage(
  {
    required String name,
    required String bio,
    BuildContext? context,
}) {
    emit(SocialUploadUserdataLoadingStates());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
            emit(SocialUploadProfileImageSuccessStates());
        print(value);
            updateUserData(
              name: name,
              bio:  bio,
              image: value,
              context: context,
            );
      })
          .catchError((error) {
            print(error.toString());
        emit(SocialUploadProfileImageErrorStates());
      });
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialUploadProfileImageErrorStates());
    });
  }


  void uploadCoverImage(
  {
    required String name,
    required String bio,
    BuildContext? context,
}) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        emit(SocialUploadCoverImageSuccessStates());
        print(value);
        updateUserData(
            name: name,
            bio:  bio,
            cover:  value,
          context: context,
        );
      })
          .catchError((error) {
        emit(SocialUploadCoverImageErrorStates());
      });
    })
        .catchError((error) {
      emit(SocialUploadCoverImageErrorStates());
    });
  }

  void updateUserData(
  {
    required String name,
    required String bio,
    String? image,
    String? cover,
    BuildContext? context,

}
)
  {
    emit(SocialUpdateUserdataLoadingStates());

      SocialUserModel model = SocialUserModel(
        name: name,
        email: userModel!.email,
        uId: uId,
        image: image!=null? image:userModel!.image,
        cover: cover!=null?cover:userModel!.cover,
        bio: bio,
        token: token
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap()!, SetOptions(merge: true),)
          .then((value){
        getUserData();
        updateValue(
          name: name,
          image: image!,
        );
        Navigator.pop(context!);
      })
          .catchError((error){
        print(error.toString());
        emit(SocialUpdateUserdataErrorStates());

      });
    }
    void updateValue({required String name,required String image}){
    FirebaseFirestore.instance
        .collection('posts').get().then((value) {
      for(var element in value.docs) {
        if(element.data()['uId']==uId)
        {
          PostModel model =PostModel(
              name: name,
              image: image,
              postImage: element.data()['postImage'],
              text: element.data()['text'],
              dateTime: element.data()['dateTime'],
              uId:uId,
              token: token,
          );
          FirebaseFirestore.instance
              .collection('posts').doc(element.id)
              .set(model.toMap()!);
        }
        emit(SocialUpdatePostdataSuccessStates());
    }

    });
    }
  void createNewPost(
      {
        required String text,
        required String datetime,
        String? postImage,
        required String? name,
        required String? image,

      }) {
    emit(SocialCreatePostLoadingStates());
    PostModel model = PostModel(
      name: name,
      uId: uId,
      image: image,
      postImage: postImage,
      text: text,
      dateTime: datetime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap()!)
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    })
        .catchError((error) {
      print(error.toString());
      emit(SocialCreatePostErrorStates());
    });
  }

  File? postImage;

  Future <void> getPostImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorStates());
    }
  }

  void uploadPostImage(
      {
        String? text,
        required String datetime,
        required String? name,
        required String? image,
      }) {
    emit(SocialCreatePostLoadingStates());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
            if(text!=null) {
          createNewPost(
              text: text,
              datetime: datetime,
              postImage: value,
              name: name,
              image: image,
          );
        }else
          emit(SocialUploadPostImageSuccessStates());
      })
          .catchError((error) {
        emit(SocialUploadPostImageErrorStates());
      });
    })
        .catchError((error) {
      emit(SocialUploadPostImageErrorStates());
    });
  }

  void removePostImage()
  {
    postImage=null;
    emit(SocialRemovePostImageStates());
  }

  List<PostModel> posts=[];
  List<String> postsId=[];
  Map<String,int> LikesNumber={};
  Map<String,int>commentsNumber={};
  Map<String,int>myCommentNumber={};
  Map<String,String>MyLikedPost={} ;
  List<String> mypostsId=[];
  List<PostModel> myPosts=[];

  Future <void> getPosts()
  async {
    emit(SocialGetPostsLoadingStates());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      postsId = [];
      commentsNumber = {};
      LikesNumber = {};
      posts = [];
      MyLikedPost = {};
      myCommentNumber={};
      mypostsId=[];
      myPosts = [];
      for (var element in event.docs) {
        await element.reference.collection('likes')
            .snapshots().listen((event) {
          event.docs.forEach((e) {
            if (e.id == uId)
              MyLikedPost.addAll({element.id: uId});
          });
          LikesNumber.addAll({element.id: event.docs.length});
          emit(SocialLikePostsSuccessStates());
        });
        await element.reference.collection('comment').snapshots().listen((
            event) {
          event.docs.forEach((e) {
            if (e.id == uId)
              myCommentNumber.addAll({element.id: event.docs.length});
          });
          commentsNumber.addAll({element.id: event.docs.length});
          emit(SocialCommentPostsSuccessStates());
        });
        postsId.add(element.id);
        await getComment(element.id);
        posts.add(PostModel.fromJson(element.data()));
        if (element.data()['uId'] == uId) {
          mypostsId.add(element.id);
          myPosts.add(PostModel.fromJson(element.data()));
          print(element.data());
          emit(SocialGetMyPostsSuccessStates());
        }

        emit(SocialGetPostsSuccessStates());
      };
    });
  }

  List<PostModel> friendPosts=[];
  Future <void> getfriendPosts({required String friendId})
  async {

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      friendPosts=[];
      for(var element in event.docs) {
        if(element.data()['uId']==friendId) {
          friendPosts.add(PostModel.fromJson(element.data()));
          emit(SocialGetfriendPostsSuccessStates());
        }

      };
    });

  }


  void LikePosts(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uId)
        .set({
      'uId' : uId,
      'like': true})
        .then((value) {
      emit(SocialLikePostsSuccessStates());
    })
        .catchError((error) {
      emit(SocialLikePostsErrorStates(error.toString()));
    });
  }

   Future <void> disLikePost(String postId)async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uId)
        .delete()
        .then((value)async {
      await getPosts();
      emit(SocialDisLikePostSuccessState());
    }).catchError((error) {
      emit(SocialDisLikePostErrorState());
      print(error.toString());
    });
  }

  void UploadCommentText({
      required String postId,
      required String text,
      required String dateTime,
      String? commentImage,

    })
    {
      CommentModel model = CommentModel(
        name: userModel!.name,
        uId: uId,
        image: userModel!.image,
        text: text,
        commentImage: commentImage,
        dateTime: dateTime
      );

      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .add(model.toMap()!)
          .then((value) {
            print(text);
            getComment(postId);
        emit(SocialCommentPostsSuccessStates());
      })
          .catchError((error){
        emit(SocialCommentPostsErrorStates(error.toString()));
      });
  }
  List<CommentModel> comments=[];

  Future <void>getComment(String postId)async
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .orderBy('dateTime',descending: true)
        .snapshots().listen((event) {
      comments=[];
      event.docs.forEach((element){
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(SocialCommentPostsSuccessStates());
    });
  }

  void uploadCommentImage(
      {
        required String text,
        required String postId,
        required String dateTime,
      }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(commentImage!.path)
        .pathSegments
        .last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
           UploadCommentText(
               postId: postId,
             text: text,
             commentImage: value,
             dateTime: dateTime

           );

      })
          .catchError((error) {
        emit(SocialUploadCommentImageErrorStates());
      });
    })
        .catchError((error) {
      emit(SocialUploadCommentImageErrorStates());
    });
  }

  File? commentImage;

  Future <void> getcommentImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(SocialCommentImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialCommentImagePickedErrorStates());
    }
  }

  void removeCommentImage()
  {
    commentImage=null;
    emit(SocialRemoveCommentImageStates());
  }

  void removePost({required String postId})
  {
    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .delete()
        .then((value) { emit(SocialRemovePostStates());});

  }

  List<SocialUserModel> users=[];

  void getAllUsers() {

      emit(SocialGetAllUsersLoadingStates());
      FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      users.clear();
      for (var element in value.docs) {
        if (element.id != uId)
          users.add(SocialUserModel.fromJson(element.data()));
      }
      emit(SocialGetAllUsersSuccessStates());

      });
  }
   void removeuser(model)
   {
     users.remove(model);
     emit(SocialremoveUserSuccessStates());
   }

  void sendFriendRequest(
  {
    required String friendId,
  })
  {
    SocialUserModel model=SocialUserModel(
        name: userModel!.name,
        uId: uId,
        image: userModel!.image,
        cover: userModel!.cover,
        bio: userModel!.bio,
       token: userModel!.token,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friendRequest')
        .doc(uId)
        .set(model.toMap()!)
        .then((value) {
      isrequest.addAll({friendId:true});
          emit(SocialFriendRequestSuccessState());
    })
        .catchError((error)
    {
      emit(SocialFriendRequestErrorState());
    });

  }

  List<SocialUserModel> friendRequest=[];
  Map<String?,bool> isrequest={};

  Stream? getFriendRequest(uId)
  {
    emit(SocialgetFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friendRequest')
        .snapshots()
         .listen((event) {
      friendRequest=[];
       getAllUsers();
        event.docs.forEach((element) {
          friendRequest.add(SocialUserModel.fromJson(element.data()));
          isrequest.addAll({element.id: true});
          emit(SocialgetFriendRequestSuccessState());
        });
    });



  }



  void acceptFriend(
      {
        required String friendId,
        required String name,
        required String image,
        required String cover,
        required String bio,
      }){
    SocialUserModel friendmodel=SocialUserModel(
        name: userModel!.name,
        uId: uId,
        image: userModel!.image,
        cover: userModel!.cover,
        //token: userModel!.token,
    );

    SocialUserModel myModel=SocialUserModel(
        name: name,
        uId: friendId,
        image: image,
        cover: cover,
        bio: bio,
       token: token,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .doc(friendId)
        .set(myModel.toMap()!)
        .then((value) {
          getFriendRequest(uId);
          isFriend.addAll({friendId:true});
      emit(SocialAddFriendSuccessState());
    })
        .catchError((error){
      emit(SocialAddFriendSuccessState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(uId)
        .set(friendmodel.toMap()!)
        .then((value) {
      isFriend.addAll({friendId:true});
      emit(SocialAddFriendSuccessState());
    })
        .catchError((error){
      emit(SocialAddFriendErrorState());
    });

  }
  List <SocialUserModel> friends=[];
  Map<String?,bool> isFriend= {};
  void getFriends()
  {
    emit(SocialgetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .snapshots()
         .listen((value) {
      friends=[];
      value.docs.forEach((element) {
        friends.add(SocialUserModel.fromJson(element.data()));
        isFriend.addAll({element.id:true});
      });
      getAllUsers();
      emit(SocialgetFriendSuccessState());
    });

  }
  void unFriend(
  {
  required String friendId
}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .doc(friendId)
        .delete()
        .then((value) {
          isFriend.addAll({friendId:false});
          getFriends();
          emit(SocialUnFriendSuccessState());
    })
        .catchError((error){
          emit(SocialUnFriendErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(uId)
        .delete()
        .then((value) {
      emit(SocialUnFriendSuccessState());
    })
        .catchError((error){
      emit(SocialUnFriendErrorState());
    });
  }


  Widget? deleteFriendRequest({required String friendId}) {
    getFriendRequest(friendId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friendRequest')
        .doc(uId)
        .delete()
        .then((value) {
      isrequest.addAll({friendId: false});
      isFriend.addAll({friendId: false});
      getFriendRequest(friendId);
      getFriends();
      getAllUsers();
      emit(SocialdeleteFriendRequestSuccessState());
    })
        .catchError((error) {
      emit(SocialdeleteFriendRequestErrortate());
    });
  }
    Widget? confirmFriendRequest({
      required String friendId,
      bool? valuefriend,
    }){
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('friendRequest')
          .doc(friendId)
          .delete()
          .then((value) {
        getFriendRequest(uId);
        getFriends();
        isFriend.addAll({friendId:valuefriend!});
        isrequest.addAll({friendId:false});
        emit(SocialdeleteFriendRequestSuccessState());
      })
          .catchError((error){
        emit(SocialdeleteFriendRequestErrortate());
      });


  }

  void sendMessage(
      {
        required String receiverId,
        required String dateTime,
        required String text,
        String? messageImage,
      }
      )
  {
    MessageModel model = MessageModel(
        senderId: uId,
        receiverId: receiverId,
        dateTime: dateTime,
        text: text,
        messageImage: messageImage
    );
    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap()!)
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    })
        .catchError((error){
      emit(SocialSendMessageErrorStates());
    });
    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toMap()!)
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    })
        .catchError((error){
      emit(SocialSendMessageErrorStates());
    });

  }

  List <MessageModel> messages=[];


  File? messageImage;

  Future <void> getmessageImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialMessageImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialMessageImagePickedErrorStates());
    }
  }

  void uploadMessageImage(
      {
        required String receiverId,
        required String dateTime,
        required String text,
      }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(messageImage!.path)
        .pathSegments
        .last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((value) {
        sendMessage(
            receiverId: receiverId,
            dateTime: dateTime,
            text: text,
            messageImage: value
        );

      })
          .catchError((error) {
        emit(SocialUploadMessageImageErrorStates());
      });
    })
        .catchError((error) {
      emit(SocialUploadMessageImageErrorStates());
    });
  }
  void removeMessageImage()
  {
    messageImage=null;
    emit(SocialRemoveMessageImageStates());
  }
  void getMessages({ required String receiverId,})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages=[];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
        print(element.data()['text']);

      });
      emit(SocialGetAllMessageSuccessStates());
    });

  }
  void sendNotification(
  {
    required String token,
    required String name,
    required String text,
  })
  {
    DioHelper.postData(
        data: {
          "to":token,
          "notification":{
            "title":name,
            "body":text,
            "mutable_content": true,
            "sound": "Tri-tone",
          },
          "android": {
            "Priority": "HIGH",
          },
          "data": {
            "type": "order",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }

        }
    );

    emit(SocialSendNotificationSuccessState());

  }

  void sendNotificationInApp(
      {
        required String name,
        required String text,
        required String dateTime,
        required String image,
        required String icon,
        required String friendId,
      })
  {
    NotificationModel model= NotificationModel(
      name: name,
      text: text,
      dateTime: dateTime,
      image: image,
      icon: icon,
      receiverId: friendId,
    );
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(friendId)
        .collection('notification')
        .add(model.toMap()!)
         .then((value) {
           emit(SocialSendNotificationInAppSuccessState());});
  }

List<NotificationModel> Notifications=[];
  void getNotification(){
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(uId)
        .collection('notification')
        .orderBy('dateTime',descending: true)
        .snapshots()
        .listen((event) {
          Notifications=[];
          event.docs.forEach((element) {
            Notifications.add(NotificationModel.fromJson(element.data()));
          });
          emit(SocialGetNotificationInAppSuccessState());
    });

  }



  bool isDark = true;
  void changeMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(SocialChangeCurrentModeState());
    }
    else
    {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(SocialChangeCurrentModeState());
      });
    }

  }


}