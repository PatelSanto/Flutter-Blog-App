import 'package:blog_app/models/blog.dart';
import 'package:blog_app/users/screens/home/category%20screens/category_blogs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/user_provider.dart';
import 'package:blog_app/users/screens/home/drawer_screen.dart';
import 'package:blog_app/users/widgets/appbar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({super.key});
  final List categories = allCategories;

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

  final Map<String, IconData> allIcon = {
    "Food blogs": Icons.restaurant,
    "Travel blogs": Icons.airport_shuttle_rounded,
    "Health and fitness blogs": Icons.fitness_center_rounded,
    "Lifestyle blogs": Icons.nightlife_rounded,
    "Fashion and beauty blogs": CupertinoIcons.heart_circle,
    "Photography blogs": Icons.photo_camera_outlined,
    "Personal blogs": Icons.perm_contact_calendar_rounded,
    "DIY craft blogs": Icons.draw_outlined,
    "Parenting blogs": Icons.family_restroom_rounded,
    "Music blogs": Icons.music_note_outlined,
    "Business blogs": Icons.business_outlined,
    "Art and design blogs": Icons.design_services_outlined,
    "Book and writing blogs": Icons.menu_book_rounded,
    "Personal finance blogs": Icons.attach_money_outlined,
    "Interior design blogs": Icons.home_filled,
    "Sports blogs": Icons.sports_cricket,
    "News blogs": Icons.newspaper,
    "Movie blogs": Icons.movie_creation_outlined,
    "Religion blogs": Icons.temple_buddhist_outlined,
    "Political blogs": Icons.local_police_outlined,
    "Other blogs": Icons.dynamic_feed_rounded,
  };

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
              _customGridView(context, allColor, allIcon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customGridView(
      BuildContext context, List<Color> color, Map<String, IconData> iconData) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
        ),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          return customContainer(context, color, index, iconData);
        });
  }

  Widget customContainer(BuildContext context, List<Color> color, int index,
      Map<String, IconData> iconData) {
    return InkWell(
      onTap: () {
        print(categories[index]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryBlogsScreen(categoryName: categories[index]),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color[index % color.length],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              iconData[categories[index]],
              color: Colors.indigo,
              size: 40,
            ),
            Text(
              categories[index],
              maxLines: 3,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
