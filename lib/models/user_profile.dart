class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;
  String? email;

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
    required this.email,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    data['email'] = email;
    return data;
  }
}
