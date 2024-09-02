import 'dart:io';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: s.height * 0.08,
            ), // text
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 30,
                ),
                SizedBox(
                  width: s.width * 0.2,
                ),
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Color.fromARGB(255, 46, 75, 150),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: s.height * 0.06,
            ),
            // image
            Container(
              height: s.height * 0.15,
              alignment: const Alignment(0.3, 0.9),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                  ),
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  // image
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            const Text(
              "Full Name",
              style: TextStyle(
                color: Color.fromARGB(255, 46, 75, 150),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "User Name",
              style: TextStyle(
                color: Color.fromARGB(255, 46, 75, 150),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: s.height * 0.02,
            ),
            const Divider(),

            SizedBox(
              height: s.height * 0.02,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Full Name",
                label: const Text("Full Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.01,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Gender ",
                label: const Text("Gender"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.01,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Phone Number",
                label: const Text("Phone Number"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.01,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Email",
                label: const Text("Email"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: s.height * 0.01,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "User Name",
                label: const Text("User Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: s.height * 0.06,
              width: s.width * 0.8,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 75, 150),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
