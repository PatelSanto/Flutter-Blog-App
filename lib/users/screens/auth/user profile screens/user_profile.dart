import 'package:blog_app/header.dart';
import 'package:blog_app/users/widgets/show_blogs.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({
    super.key,
    this.userId = "",
  });
  final String userId;

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    final userData = ref.watch(userDataNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 46, 75, 150),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.lightBlue[200],
                child: ClipOval(
                  child: Image.network(
                    "${userData.pfpURL}",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return const CircularProgressIndicator.adaptive();
                      } else {
                        return child;
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        color: Colors.black12,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            Text(
              "${userData.name}",
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 46, 75, 150),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: s.height * 0.03,
            ),
            (widget.userId == "")
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile_edit_page');
                    },
                    child: Container(
                      height: s.height * 0.05,
                      width: s.width * 0.4,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 75, 150),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            (widget.userId == "")
                ? SizedBox(
                    height: s.height * 0.03,
                  )
                : const SizedBox(),
            const Divider(),
            (widget.userId == "")
                ? ListTile(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/myblogs",
                        (Route<dynamic> route) => false,
                      );
                    },
                    title: const Text(
                      'My Blogs',
                      style: TextStyle(
                        color: Color.fromARGB(255, 46, 75, 150),
                      ),
                    ),
                    leading: const Icon(
                      Icons.my_library_books_outlined,
                      color: Color.fromARGB(255, 46, 75, 150),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Color.fromARGB(255, 46, 75, 150),
                    ),
                  )
                : showUserBlogs(context, widget.userId),
            (widget.userId == "")
                ? Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/favoriteBlogs",
                          );
                        },
                        title: const Text(
                          'Favorite Blogs',
                          style: TextStyle(
                            color: Color.fromARGB(255, 46, 75, 150),
                          ),
                        ),
                        leading: const Icon(
                          Icons.favorite_border,
                          color: Color.fromARGB(255, 46, 75, 150),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Color.fromARGB(255, 46, 75, 150),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                        title: const Text(
                          'Settings',
                          style: TextStyle(
                            color: Color.fromARGB(255, 46, 75, 150),
                          ),
                        ),
                        leading: const Icon(
                          Icons.settings_outlined,
                          color: Color.fromARGB(255, 46, 75, 150),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Color.fromARGB(255, 46, 75, 150),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
