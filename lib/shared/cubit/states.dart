abstract class SocialStates{}

class SocialInitialStates extends SocialStates{}

class SocialGetUserLoadingStates extends SocialStates{}

class SocialGetUserSuccessStates extends SocialStates{}

class SocialGetUserErrorStates extends SocialStates{
  final String error;

  SocialGetUserErrorStates(this.error);

}

class SocialGetAllUsersLoadingStates extends SocialStates{}

class SocialGetAllUsersSuccessStates extends SocialStates{}

class SocialGetAllUsersErrorStates extends SocialStates{
  final String error;

  SocialGetAllUsersErrorStates(this.error);

}
class SocialremoveUserSuccessStates extends SocialStates{}

class ChangeBottomNavBarStates extends SocialStates{}

class SocialProfileImagePickedSuccessStates extends SocialStates{}

class SocialProfileImagePickedErrorStates extends SocialStates{}

class SocialCoverImagePickedSuccessStates extends SocialStates{}

class SocialCoverImagePickedErrorStates extends SocialStates{}

class SocialUploadProfileImageSuccessStates extends SocialStates{}

class SocialUploadProfileImageErrorStates extends SocialStates{}

class SocialUploadCoverImageSuccessStates extends SocialStates{}

class SocialUploadCoverImageErrorStates extends SocialStates{}

class SocialUploadUserdataLoadingStates extends SocialStates{}

class SocialUpdateUserdataLoadingStates extends SocialStates{}

class SocialUpdatePostdataSuccessStates extends SocialStates{}

class SocialUpdateUserdataErrorStates extends SocialStates{}

class SocialCreatePostLoadingStates extends SocialStates{}

class SocialCreatePostSuccessStates extends SocialStates{}

class SocialCreatePostErrorStates extends SocialStates{}

class SocialPostImagePickedSuccessStates extends SocialStates{}

class SocialPostImagePickedErrorStates extends SocialStates{}

class SocialUploadPostImageSuccessStates extends SocialStates{}

class SocialUploadPostImageErrorStates extends SocialStates{}

class SocialRemovePostImageStates extends SocialStates{}

class SocialRemovePostStates extends SocialStates{}


class SocialGetPostsLoadingStates extends SocialStates{}

class SocialGetPostsSuccessStates extends SocialStates{}

class SocialGetPostsErrorStates extends SocialStates{
  final String error;

  SocialGetPostsErrorStates(this.error);

}

class SocialGetMyPostsSuccessStates extends SocialStates{}

class SocialGetfriendPostsSuccessStates extends SocialStates{}

class SocialAddNewPostStates extends SocialStates{}

class SocialLikePostsSuccessStates extends SocialStates{}

class SocialLikePostsErrorStates extends SocialStates{
  final String error;

  SocialLikePostsErrorStates(this.error);

}

class SocialCommentPostsSuccessStates extends SocialStates{}

class SocialCommentPostsErrorStates extends SocialStates{
  final String error;

  SocialCommentPostsErrorStates(this.error);

}
class SocialCommentImagePickedSuccessStates extends SocialStates{}

class SocialCommentImagePickedErrorStates extends SocialStates{}

class SocialUploadCommentImageSuccessStates extends SocialStates{}

class SocialUploadCommentImageErrorStates extends SocialStates{}

class SocialRemoveCommentImageStates extends SocialStates{}

class SocialSendMessageSuccessStates extends SocialStates{}

class SocialSendMessageErrorStates extends SocialStates{}

class SocialGetAllMessageSuccessStates extends SocialStates{}

class SocialMessageImagePickedSuccessStates extends SocialStates{}

class SocialMessageImagePickedErrorStates extends SocialStates{}

class SocialUploadMessageImageSuccessStates extends SocialStates{}

class SocialUploadMessageImageErrorStates extends SocialStates{}

class SocialRemoveMessageImageStates extends SocialStates{}

class SocialDisLikePostSuccessState extends SocialStates{}

class SocialDisLikePostErrorState extends SocialStates{}

class SocialGetFriendProfileLoadingState extends SocialStates{}

class SocialGetFriendProfileSuccessState extends SocialStates{}

class SocialFriendRequestSuccessState extends SocialStates{}

class SocialFriendRequestErrorState extends SocialStates{}

class SocialgetFriendRequestLoadingState extends SocialStates{}

class SocialgetFriendRequestSuccessState extends SocialStates{}

class SocialCheckFriendRequestSuccessState extends SocialStates{}

class SocialdeleteFriendRequestSuccessState extends SocialStates{}

class SocialdeleteFriendRequestErrortate extends SocialStates{}

class SocialAddFriendSuccessState extends SocialStates{}

class SocialAddFriendErrorState extends SocialStates{}

class SocialgetFriendLoadingState extends SocialStates{}

class SocialgetFriendSuccessState extends SocialStates{}

class SocialUnFriendSuccessState extends SocialStates{}

class SocialUnFriendErrorState extends SocialStates{}

class SocialCheckFriendSuccessState extends SocialStates{}

class SocialDeleteFriendSuccessState extends SocialStates{}

class SocialDeleteFriendErrorState extends SocialStates{}

class SocialChangeCurrentModeState extends SocialStates{}

class SocialSendNotificationSuccessState extends SocialStates{}

class SocialSendNotificationInAppSuccessState extends SocialStates{}

class SocialGetNotificationInAppSuccessState extends SocialStates{}











