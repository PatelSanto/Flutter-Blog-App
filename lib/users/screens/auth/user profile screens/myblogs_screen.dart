import 'package:blog_app/header.dart';

class MyBlogsScreen extends ConsumerStatefulWidget {
  const MyBlogsScreen({super.key});

  @override
  ConsumerState<MyBlogsScreen> createState() => _MyBlogsScreenState();
}

class _MyBlogsScreenState extends ConsumerState<MyBlogsScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      drawer: const DrawerScreen(selectedIndex: 1),
      appBar: appBarWidget(context, userData, "My Blogs"),
      body: _body(),
      floatingActionButton: _createBlogButton(),
    );
  }

  Widget _body() {
    final userData = ref.watch(userDataNotifierProvider);
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: getUserBlogs(userData.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading blogs."));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return noBlogFoundWidget();
              }

              final blogs = snapshot.data;
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (BuildContext context, int index) {
                  final blog = blogs[index];
                  return Dismissible(
                    key: ValueKey(blogs[index]),
                    confirmDismiss: (direction) {
                      return deleteBlog(context, blog.id).then((value) {
                        ref
                            .read(userDataNotifierProvider.notifier)
                            .updateUserData(
                              noOfBlogs: userData.noOfBlogs - 1,
                              blogIds: userData.blogIds.remove(blog.id)
                                  ? userData.blogIds
                                  : userData.blogIds,
                            );
                        return null;
                      });
                    },
                    background: slideRightBackground(),
                    direction: DismissDirection.endToStart,
                    child: blogTile(
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
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Text(
          "Swipe left to Delete Blog",
          style: TextStyle(color: Colors.black87),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget slideRightBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // color: Colors.red[400],
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.redAccent,
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
      child: const Row(
        children: [
          SizedBox(width: 20),
          Text(
            "Delete this Blog ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _createBlogButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateBlogScreen(content: "Edit Content",)),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
