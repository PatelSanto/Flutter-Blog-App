import 'dart:io';
import 'package:flutter/material.dart';
import 'package:blog_app/models/blog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBlogScreen extends ConsumerStatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  CreateBlogScreenState createState() => CreateBlogScreenState();
}

class CreateBlogScreenState extends ConsumerState<CreateBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _readingTimeController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _selectedImage;
  final List<String> _selectedCategories = [];
  final List<String> categories = allCategories;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadBlog() async {
    setState(() {
      isLoading = true;
    });
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _readingTimeController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _selectedCategories.isEmpty ||
        _selectedImage == null) {
      setState(() {
        isLoading = false;
      });
      snackbarToast(
          context: context,
          title: "Please fill all fields and select an image",
          icon: Icons.error);
      return;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('blog_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      final userData = ref.watch(userDataNotifierProvider);

      // Create Blog object
      Blog newBlog = Blog(
        id: '',
        title: _titleController.text,
        content: _contentController.text,
        author: _authorController.text,
        authorUid: userData.uid.toString(),
        imageUrl: downloadUrl,
        views: 0,
        comments: 0,
        readingTime: int.parse(_readingTimeController.text),
        categories: _selectedCategories,
      );

      // Save blog details to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('blogs')
          .add(newBlog.toMap());
      await docRef.update({'id': docRef.id});

      ref.read(userDataNotifierProvider.notifier).updateUserData(
        noOfBlogs: userData.noOfBlogs + 1,
        blogIds: {...userData.blogIds, docRef.id},
      );

      setState(() {
        isLoading = false;
      });
      snackbarToast(
          context: context,
          title: "Blog created successfully!",
          icon: Icons.done_all_rounded);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      snackbarToast(
          context: context,
          title: 'Failed to upload blog: $e',
          icon: Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 46, 75, 150),
        foregroundColor: Colors.white,
        title: const Text('Create New Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  suffix: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _authorController.text = userData.name.toString();
                      });
                    },
                    child: const Text("Me"),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _readingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Reading Time (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              const Text('Select Categories'),
              buildMultiSelect(),
              const SizedBox(height: 10),
              _selectedImage == null
                  ? const Text('No image selected.')
                  : Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 46, 75, 150),
                  ),
                ),
                child: const Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(300, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 46, 75, 150),
                    ),
                  ),
                  onPressed: _uploadBlog,
                  child: (isLoading)
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                          'Create Blog',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMultiSelect() {
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        final isSelected = _selectedCategories.contains(category);
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories
                    .removeWhere((String name) => name == category);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
