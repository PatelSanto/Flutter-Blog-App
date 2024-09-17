import 'package:blog_app/models/user.dart';
import 'package:blog_app/users/screens/home/category_blogs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/screens/home/drawer_screen.dart';
import 'package:blog_app/users/widgets/appbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({super.key});

  final List<Color> allColor = const [
    Color(0xFFa3e3d9),
    Color(0xFFf8a78b),
    Color(0xFF9ebef1),
    Color(0xFFf69fd6),
    Color(0xFF8987fd),
    Color(0xFFf78c8c),
    Color(0xFF8ad7f8),
    Color(0xFFc2a4ef),
    Color(0xFF8bd5ca),
    Color(0xFF9a7fbc),
    Color(0xFFa0d69a),
    Color(0xFFf9bb94),
  ];

  final List<IconData> allIcon = [
    CupertinoIcons.heart_fill,
    CupertinoIcons.news,
    CupertinoIcons.book,
    Icons.add,
    Icons.sports,
    Icons.star,
    Icons.store,
    Icons.man,
    Icons.woman,
    Icons.child_care,
    CupertinoIcons.music_note_2,
    Icons.snowshoeing,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataNotifierProvider);
    return Scaffold(
      drawer: const DrawerScreen(selectedIndex: 2),
      appBar: appBarWidget(context, userData, "All Categories"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _customGridView(allColor, allIcon),
              const Text('data'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customGridView(List<Color> color, List<IconData> icon) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
        ),
        itemCount: allColor.length - 1,
        itemBuilder: (_, index) {
          return customContainer(color, index, icon);
        });
  }

  Widget customContainer(
      List<Color> color, int index, List<IconData> iconData) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color[index],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData[index],
            color: color[index + 1],
          ),
          const Text(
            'Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
