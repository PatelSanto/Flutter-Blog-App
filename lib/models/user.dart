

class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;
  String? email;
  int totalViews;
  int totalComments;
  int totalLikes;
  int noOfBlogs;
  List<String> blogIds;

  UserProfile({
    required this.uid,
    required this.name,
    this.pfpURL = "",
    required this.email,
    this.totalViews = 0,
    this.totalComments = 0,
    this.totalLikes = 0,
    this.noOfBlogs = 0,
    this.blogIds = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      name: json['name'] as String,
      pfpURL: json['pfpURL'] as String? ?? "",
      email: json['email'] as String,
      totalViews: json['totalViews'] as int? ?? 0,
      totalComments: json['totalComments'] as int? ?? 0,
      totalLikes: json['totalLikes'] as int? ?? 0,
      noOfBlogs: json['noOfBlogs'] as int? ?? 0,
      blogIds: (json['blogIds'] as List<dynamic>?)
              ?.map((id) => id as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'pfpURL': pfpURL,
      'email': email,
      'totalViews': totalViews,
      'totalComments': totalComments,
      'totalLikes': totalLikes,
      'noOfBlogs': noOfBlogs,
      'blogIds': blogIds,
    };
  }
}

