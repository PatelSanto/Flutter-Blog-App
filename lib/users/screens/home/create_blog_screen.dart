import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_blog_app/models/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_blog_app/models/blog.dart';

class CreateBlogScreen extends ConsumerStatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends ConsumerState<CreateBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _readingTimeController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _readingTimeController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
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
      );

      // Save blog details to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('blogs')
          .add(newBlog.toMap());
      await docRef.update({'id': docRef.id});

      ref.read(userDataNotifierProvider.notifier).updateUserData(
            noOfBlogs: userData.noOfBlogs + 1,
            blogIds: [...userData.blogIds, docRef.id],
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload blog: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 6,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _readingTimeController,
                decoration:
                    const InputDecoration(labelText: 'Reading Time (minutes)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _selectedImage == null
                  ? const Text('No image selected.')
                  : Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadBlog,
                child: const Text('Create Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
