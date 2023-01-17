import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/MessageModel.dart';
import 'package:social_app/models/PostModel.dart';
import 'package:social_app/models/commentModel.dart';
import 'package:social_app/models/SocialUserModel.dart';
import 'package:social_app/modules/socialApp/Setting/SettingScreen.dart';
import 'package:social_app/modules/socialApp/chats/chatsScreen.dart';
import 'package:social_app/modules/socialApp/feeds/feedsScreen.dart';
import 'package:social_app/modules/socialApp/users/userssScreen.dart';
import 'package:social_app/shared/components/constant.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';
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

      currentIndex = index;
      getAllUsers();
      getFriendRequest(uId);
      getPosts();
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
    required String phone,
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
           // emit(SocialUploadProfileImageSuccessStates());
        print(value);
            updateUserData(
              name: name,
              phone:  phone,
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
    required String phone,
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
        //emit(SocialUploadCoverImageSuccessStates());
        print(value);
        updateUserData(
            name: name,
            phone:  phone,
            bio:  bio,
          cover: value,
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
    required String phone,
    required String bio,
    String? cover,
    String? image,
    BuildContext? context,

})
  {
    emit(SocialUpdateUserdataLoadingStates());

      SocialUserModel model = SocialUserModel(
        name: name,
        phone: phone,
        email: userModel!.email,
        uId: uId,
        image: image??userModel!.image,
        cover: cover??userModel!.cover,
        bio: bio,
        isEmailVerified: false,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap()!, SetOptions(merge: true),)
          .then((value){
        getUserData();
        Navigator.pop(context!);
      })
          .catchError((error){
        print(error.toString());
        emit(SocialUpdateUserdataErrorStates());

      });
    }
  void createNewPost(
      {
        String? text,
        required String datetime,
        String? postImage,

      }) {
    emit(SocialCreatePostLoadingStates());

    PostModel model = PostModel(
      name: userModel!.name,
      uId: uId,
      image: userModel!.image,
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
          createNewPost(text: text, datetime: datetime, postImage: value);
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
  Map<String,String>MyLikedPost={} ;
  List<PostModel> myPosts=[];

  Future <void> getPosts()
  async {
    emit(SocialGetPostsLoadingStates());
   FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
     postsId=[];
     commentsNumber={};
     LikesNumber={};
     posts=[];
     MyLikedPost={} ;
     myPosts=[];
     for(var element in event.docs) {
       await element.reference.collection('likes')
       .snapshots().listen((event) {
         event.docs.forEach((e) {
           if(e.id==uId)
             MyLikedPost.addAll({element.id:uId});
         });
         LikesNumber.addAll({element.id: event.docs.length});
         emit(SocialLikePostsSuccessStates());

       });
       await element.reference.collection('comment').snapshots().listen((event) {
         commentsNumber.addAll({element.id:event.docs.length});
         emit(SocialCommentPostsSuccessStates());
       });
       postsId.add(element.id);
       await getComment(element.id);
       posts.add(PostModel.fromJson(element.data()));
       if(element.data()['uId']==uId) {
          myPosts.add(PostModel.fromJson(element.data()));
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

  List<CommentModel> comments=[];

   Future <void>getComment(String postId)async
  {
    comments=[];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
         .orderBy('dateTime',descending: true)
         .snapshots().listen((event) {
      event.docs.forEach((element){
        comments.add(CommentModel.fromJson(element.data()));
    });
      emit(SocialCommentPostsSuccessStates());
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

      FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
        users = [];
        for (var element in value.docs) {
          if (element.data()['uId'] != uId)
            users.add(SocialUserModel.fromJson(element.data()));
          emit(SocialGetAllUsersSuccessStates());
        }
      });
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
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friendRequest')
        .doc(uId)
        .set(model.toMap()!)
        .then((value) {
          emit(SocialFriendRequestSuccessState());
    })
        .catchError((error)
    {
      emit(SocialFriendRequestErrorState());
    });

  }

  List<SocialUserModel> friendRequest=[];
  void getFriendRequest(uId)
  {
    emit(SocialgetFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friendRequest')
        .get()
        .then((value) {
      friendRequest=[];
      value.docs.forEach((element) {
        friendRequest.add(SocialUserModel.fromJson(element.data()));
        print(element.data()['uId']);

      });
      emit(SocialgetFriendRequestSuccessState());
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
    );

    SocialUserModel myModel=SocialUserModel(
        name: name,
        uId: friendId,
        image: image,
        cover: cover,
        bio: bio,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .doc(friendId)
        .set(myModel.toMap()!)
        .then((value) {
          getFriendRequest(uId);
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
      emit(SocialAddFriendSuccessState());
    })
        .catchError((error){
      emit(SocialAddFriendErrorState());
    });

  }
  List <SocialUserModel> friends=[];
  void getFriends()
  {
    emit(SocialgetFriendLoadingState());
    friends=[];
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        friends.add(SocialUserModel.fromJson(element.data()));
      });
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
          getFriends();
          getAllUsers();
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
          getFriends();
          getAllUsers();
      emit(SocialUnFriendSuccessState());
    })
        .catchError((error){
      emit(SocialUnFriendErrorState());
    });
  }


  Widget? deleteFriendRequest({required String friendId}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friendRequest')
        .doc(friendId)
        .delete()
        .then((value) {
      getFriends();
      getFriendRequest(friendId);
      emit(SocialdeleteFriendRequestSuccessState());
    })
        .catchError((error){
      emit(SocialdeleteFriendRequestErrortate());
    });


  }

  Map<String,bool> request= {};

  void isFriendRequestExist( {required String friendId})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friendRequest')
        .snapshots()
        .listen((event){
      request= {};
      event.docs.forEach((element) {
        if(element.id==friendId)
        {
          request.addAll({element.id:true});
        }
        emit(SocialCheckFriendRequestSuccessState());
      });
    });
  }

  Map<String,bool> isFriend= {};

  void checkFriendState( {required String friendId})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('friends')
        .snapshots()
        .listen((event) {
      isFriend= {};
          event.docs.forEach((element) {
              if(element.id==friendId)
                {
                  isFriend.addAll({element.id:true});
                }
              emit(SocialCheckFriendSuccessState());
          });
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
  bool isDark = false;
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