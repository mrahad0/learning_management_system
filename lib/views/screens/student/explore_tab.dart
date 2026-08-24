import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/data/model/course_model.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getApprovedCourses();
      Get.find<StudentController>().getMyProgress(); // Fetch progress if not already fetched
    });
  }

  // Helper for generating colors based on index to simulate the mockup's theme
  Map<String, Color> _getCourseColorTheme(int index) {
    final themes = [
      {
        'bg': const Color(0xFFD6EBE2), // Mint (Mobile Dev)
        'text': const Color(0xFF17684C),
        'iconBg': Colors.white,
        'actionBg': const Color(0xFF1F2937),
        'actionIcon': Colors.white,
      },
      {
        'bg': const Color(0xFFF2D8AC), // Peach (Web Dev)
        'text': const Color(0xFF9E4B22),
        'iconBg': Colors.white,
        'actionBg': const Color(0xFF1F2937),
        'actionIcon': Colors.white,
      },
      {
        'bg': const Color(0xFFE2D7F4), // Purple (Design)
        'text': const Color(0xFF4C2B82),
        'iconBg': Colors.white,
        'actionBg': Colors.white,
        'actionIcon': Colors.black,
      }
    ];
    return themes[index % themes.length];
  }

  String _getInitials(String? title) {
    if (title == null || title.isEmpty) return '??';
    List<String> words = title.split(' ');
    if (words.length == 1) return words[0].substring(0, 2).toUpperCase();
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  String _getCategory(int index) {
    final categories = ['MOBILE DEVELOPMENT', 'WEB DEVELOPMENT', 'DESIGN THINKING'];
    return categories[index % categories.length];
  }

  double _getCourseProgress(int courseId, StudentController controller) {
    if (controller.myProgress != null) {
      for (var progress in controller.myProgress!) {
        if (progress.courseId == courseId) {
          return (progress.progressPercent ?? 0.0) / 100.0;
        }
      }
    }
    return 0.0;
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search courses...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212F3D),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore courses',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF212F3D),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Keep your curiosity moving.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.grey),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _isSearching = false;
                    _searchQuery = '';
                    _searchController.clear();
                  } else {
                    _isSearching = true;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: GetBuilder<StudentController>(
                builder: (studentController) {
                  if (studentController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (studentController.approvedCourses == null || studentController.approvedCourses!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No courses available at the moment.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  final filteredCourses = studentController.approvedCourses!.where((course) {
                    return (course.title ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredCourses.isEmpty) {
                    return const Center(
                      child: Text(
                        'No matching courses found.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 120),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      final theme = _getCourseColorTheme(index);
                      final progress = _getCourseProgress(course.id ?? 0, studentController);
                      
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('${AppRoutes.studentDashboard}/course/${course.id}');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              // Inner Colored Area
                              Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme['bg'],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Initials Squircle
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: theme['iconBg'],
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getInitials(course.title),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: theme['text'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              index % 3 == 0 ? Icons.extension : index % 3 == 1 ? Icons.emoji_events : Icons.add,
                                              size: 12,
                                              color: const Color(0xFFC25E3E),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // Text Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _getCategory(index),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.2,
                                              color: theme['text'],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            course.title ?? '',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF212F3D),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Text(
                                                'Beginner',
                                                style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6),
                                                child: Icon(Icons.circle, size: 4, color: Colors.black26),
                                              ),
                                              Text(
                                                '${course.lessonsCount ?? 0} lessons',
                                                style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Action Button
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: theme['actionBg'],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        index == 2 ? Icons.add : Icons.arrow_forward,
                                        color: theme['actionIcon'],
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
