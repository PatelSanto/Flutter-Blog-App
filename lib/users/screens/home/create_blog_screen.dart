import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
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
        _authorController.text.isEmpty ||
        _selectedImage == null) {
      // Show an error if fields are empty or image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    try {
      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('blog_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save blog details to Firestore
      await FirebaseFirestore.instance.collection('blogs').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'author': _authorController.text,
        'readingTime': int.parse(_readingTimeController.text),
        'imageUrl': downloadUrl,
        'views': 0,
        'comments': 0,
        'createdAt': Timestamp.now(),
      });

      // Show success message and navigate back
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
