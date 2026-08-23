import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import '../../../controller/student_controller/student_controller.dart';
import 'explore_tab.dart';
import 'my_courses_tab.dart';
import '../profile/profile_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  final List<Widget> _screens = [
    const ExploreTab(),    
    const MyCoursesTab(),  
    const ProfileScreen(), 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getMyProgress();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: AppColors.cardColor,
        showLabel: true,
        notchColor: AppColors.studentColor,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: AppColors.subtitleColor),
            activeItem: Icon(Icons.home_filled, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.play_lesson, color: AppColors.subtitleColor),
            activeItem: Icon(Icons.play_lesson, color: Colors.white),
            itemLabel: 'Courses',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: AppColors.subtitleColor),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24,
        kBottomRadius: 28.0,
      ),
    );
  }
}
