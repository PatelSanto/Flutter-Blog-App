import 'package:blog_app/header.dart';

Widget showUserBlogs(BuildContext context, String uid) {
  return Expanded(
    child: StreamBuilder(
      stream: getUserBlogs(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final blogs = snapshot.data ?? [];


        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];

              return blogTile(
                leadingImage: blog.imageUrl,
                title: blog.title,
                author: blog.author,
                timeStamp: blog.timeStamp,
                views: blog.views,
                comments: blog.comments,
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(blog: blog),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return noBlogFoundWidget();
        }
      },
    ),
  );
}
