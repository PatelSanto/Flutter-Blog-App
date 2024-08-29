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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          _profilerow(),
          const SizedBox(height: 15),
          _search()
        ],
      ),
    );
  }

// Top Row for Profile and Menu Bar
  Widget _profilerow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notes_sharp,
              color: Colors.black,
              size: 50,
            )),
        GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 38,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
              radius: 35,
            ),
          ),
        ),
      ],
    );
  }
}

// For Search Bar
Widget _search() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.only(left: 20, top: 10),
        alignment: AlignmentDirectional.topStart,
        child: const Text(
          'Blogs',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      const SizedBox(height: 30),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius: 5,
                          offset: Offset(5, 5))
                    ]),
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Search Blogs',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),
          ),
          //  SizedBox(width: 1),
          Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(5, 5))
                  ]),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.sort_sharp),
              )),
        ],
      ),
    ],
  );
}
