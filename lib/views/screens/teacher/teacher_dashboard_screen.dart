import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/teacher_controller/teacher_controller.dart';
import 'package:learning_management_system/helper/route_helper.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/views/screens/profile/profile_screen.dart';
import 'package:learning_management_system/views/screens/teacher/create_course_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TeacherController>().getMyCourses();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const CreateCourseScreen(isTab: true),
          _buildMyCoursesTab(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.add_circle_rounded, 'Add Course', const Color(0xFF4785FF)),
              _buildNavItem(1, Icons.home_rounded, 'Home', const Color(0xFF4785FF)),
              _buildNavItem(2, Icons.person_rounded, 'Profile', const Color(0xFF4785FF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : const Color(0xFF94A3B8),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMyCoursesTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('My Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B))),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: false,
      ),
      body: GetBuilder<TeacherController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myCourses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No courses yet.', style: AppStyles.h3(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('Tap + to create one!', style: AppStyles.h6(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: controller.myCourses.length,
            itemBuilder: (context, index) {
              final course = controller.myCourses[index];
              String displayStatus = (course.status ?? 'Pending').toUpperCase();
              if (displayStatus == 'PENDING') displayStatus = 'DRAFT';
              if (course.isPublished == true) displayStatus = 'PUBLISHED';

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.manageCourse.replaceAll(':id', course.id.toString()));
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4F8),
                                borderRadius: BorderRadius.circular(16),
                                image: course.thumbnail != null
                                    ? DecorationImage(image: NetworkImage(course.thumbnail!), fit: BoxFit.cover)
                                    : null,
                              ),
                              child: course.thumbnail == null
                                  ? const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 32))
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title ?? 'Untitled', 
                                    style: const TextStyle(fontSize: 18, color: Color(0xFF1B2A3B), fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusBgColor(displayStatus),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      displayStatus,
                                      style: TextStyle(
                                        color: _getStatusTextColor(displayStatus), 
                                        fontSize: 11, 
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Color(0xFFB0B7C3)),
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
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'APPROVED': return const Color(0xFFE8F5E9);
      case 'DRAFT': return const Color(0xFFFFF8E1);
      case 'REJECTED': 
      case 'NEEDS REVIEW': return const Color(0xFFFFEBEE);
      case 'PUBLISHED': return const Color(0xFFE3F2FD);
      default: return Colors.grey[200]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'APPROVED': return const Color(0xFF66BB6A);
      case 'DRAFT': return const Color(0xFFFFCA28);
      case 'REJECTED':
      case 'NEEDS REVIEW': return const Color(0xFFEF5350);
      case 'PUBLISHED': return const Color(0xFF42A5F5);
      default: return Colors.grey;
    }
  }
}
