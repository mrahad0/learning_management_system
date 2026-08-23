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
  final _notchController = NotchBottomBarController(index: 1);
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
    _notchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const CreateCourseScreen(isTab: true),
          _buildMyCoursesTab(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchController,
        color: Colors.white,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: AppColors.primaryColor,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: true,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        elevation: 1,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.add_circle_outline, color: Colors.blueGrey),
            activeItem: Icon(Icons.add_circle, color: Colors.white),
            itemLabel: 'Add Course',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: Colors.blueGrey),
            activeItem: Icon(Icons.home, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person_outline, color: Colors.blueGrey),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        kIconSize: 24.0,
      ),
    );
  }

  Widget _buildMyCoursesTab() {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.white,
        elevation: 0,
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
            padding: const EdgeInsets.all(16),
            itemCount: controller.myCourses.length,
            itemBuilder: (context, index) {
              final course = controller.myCourses[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.manageCourse.replaceAll(':id', course.id.toString()));
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 100,
                            height: 80,
                            color: Colors.grey[200],
                            child: course.thumbnail != null
                                ? Image.network(course.thumbnail!, fit: BoxFit.cover)
                                : const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(course.title ?? 'Untitled', 
                                style: AppStyles.h4(color: AppColors.titleColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(course.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (course.status ?? 'Pending').toUpperCase(),
                                  style: AppStyles.h6(color: _getStatusColor(course.status)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
