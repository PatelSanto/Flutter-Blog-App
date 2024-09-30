import 'package:blog_app/header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final CollectionReference _blogs =
      FirebaseFirestore.instance.collection('blogs');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AuthService _authServices;
  Set<String> selectedCategory = {'All Blogs'}; // Default category filter
  final List<String> _categories = allCategories;
  String selectedSortOption = 'Newest'; // Default sort option

  @override
  void initState() {
    _authServices = GetIt.instance.get<AuthService>();
    ref
        .read(userDataNotifierProvider.notifier)
        .fetchUserData(_authServices.user?.uid);
    print("selectedCategory: $selectedCategory");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);
    print("profile pic url: ${userData.pfpURL}");

    return Scaffold(
      appBar: appBarWidget(context, userData, "Blogs"),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.only(left: 35, right: 35, top: 20, bottom: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 46, 75, 150),
                ),
                hintText: 'Search Blogs',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 46, 75, 150),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.tune_sharp,
                    color: Color.fromARGB(255, 46, 75, 150),
                  ),
                  onPressed: () {
                    _showFilterModal();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _blogs.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final blogs = snapshot.data?.docs ?? [];

                final filteredBlogs = blogs
                    .where((blog) {
                      final title =
                          blog['title']?.toString().toLowerCase().trim() ?? '';
                      final categories = blog['categories'] ?? ['All Blogs'];
                      bool hasCommonItem = categories.any(
                          (category) => selectedCategory.contains(category));
                      bool condition =
                          title.contains(_searchQuery.toLowerCase()) &&
                              (hasCommonItem);
                      return condition;
                    })
                    .map((doc) => Blog.fromDocument(doc))
                    .toList();

                // sorting based on the selected filter
                if (selectedSortOption == 'Most Viewed') {
                  filteredBlogs.sort((a, b) => b.views.compareTo(a.views));
                } else if (selectedSortOption == 'Newest') {
                  filteredBlogs
                      .sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
                } else if (selectedSortOption == 'Oldest') {
                  filteredBlogs
                      .sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
                }

                if (filteredBlogs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = filteredBlogs[index];

                      return blogTile(
                        leadingImage: blog.imageUrl,
                        title: blog.title,
                        author: blog.author,
                        timeStamp: blog.timeStamp,
                        views: blog.views,
                        comments: blog.comments,
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlogDetailScreen(blog: blog),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return noBlogFoundWidget();
                }
              },
            ),
          ),
        ],
      ),
      drawer: const DrawerScreen(selectedIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.backgroundColor2,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateBlogScreen(
                      content: "Edit Content",
                    )),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // filter modal
  void _showFilterModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Category',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            print("selectedCategory: $selectedCategory");
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Sort option section
                        ListTile(
                          title: const Text(
                            'Sort by',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: DropdownButton<String>(
                            value: selectedSortOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSortOption = newValue!;
                              });
                            },
                            items: <String>['Newest', 'Oldest', 'Most Viewed']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _categories.map((category) {
                            return FilterChip(
                              label: Text(category),
                              selected: selectedCategory.contains(category),
                              onSelected: (bool isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedCategory.add(category);
                                  } else {
                                    selectedCategory.remove(category);
                                  }
                                });
                                print("selectedChips: $selectedCategory");
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
