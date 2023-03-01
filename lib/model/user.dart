
class UserModel {

  String uid;
  String? displayName;
  String? avatarUrl;
  bool? isSubscribed;

  UserModel(this.uid, this.displayName, this.isSubscribed,
      {this.avatarUrl = ''});

  UserModel.fromJson(Map<String, dynamic> json)
      :
        uid = json['uid'],
        displayName = json['displayName'],
        avatarUrl = json['avatarUrl'],
        isSubscribed = json['isSubscribed'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'isSubscribed': isSubscribed
    };
  }

}

