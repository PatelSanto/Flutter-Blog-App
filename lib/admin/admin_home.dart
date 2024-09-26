import 'package:blog_app/header.dart';
export 'manage_blogs.dart';
export 'manage_users.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 25),
        ),
        backgroundColor: Colors.purple[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
              _authService.logoutDilog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DashboardCard(
                title: 'Manage Blogs',
                icon: Icons.article,
                color: Colors.orangeAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageBlogsPage()),
                ),
              ),
              DashboardCard(
                title: 'Manage Users',
                icon: Icons.people,
                color: Colors.greenAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageUsersPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class AdminHome extends StatelessWidget {
//   const AdminHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Admin Dashboard',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 25),
//         ),
//         backgroundColor: Colors.purple[100],
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               // Implement logout functionality here
//               _authService.logoutDilog(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               DashboardCard(
//                 title: 'Manage Blogs',
//                 icon: Icons.article,
//                 color: Colors.orangeAccent,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ManageBlogsPage()),
//                 ),
//               ),
//               DashboardCard(
//                 title: 'Manage Users',
//                 icon: Icons.people,
//                 color: Colors.greenAccent,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ManageUsersPage()),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
