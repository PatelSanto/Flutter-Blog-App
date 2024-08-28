import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.notes_sharp, color: Colors.black, size: 50),
        ),
        actions: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 35,
          ),
        ],
        backgroundColor: Color(0xFFFAFAFA),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(left: 25, top: 20),
      child: Text(
        'Blogs',
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
