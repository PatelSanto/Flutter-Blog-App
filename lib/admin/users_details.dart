import 'package:blog_app/header.dart';

class UserDetailPage extends StatelessWidget {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'User Blogs',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 25),
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('blogs')
            .where('authorUid', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              'No blogs posted by this user.',
              style: TextStyle(fontSize: 20),
            ));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var doc = snapshot.data?.docs[index];
              var data = doc?.data() as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(data['title']),
                  subtitle: Text('Published on: ${data['timestamp']}'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        data['imageUrl'] ?? 'https://via.placeholder.com/150'),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implement navigation to blog detail page if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
