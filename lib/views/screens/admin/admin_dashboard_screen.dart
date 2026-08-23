import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:learning_management_system/controller/admin_controller/admin_controller.dart';
import '../profile/profile_screen.dart';
import 'dashboard_stats_tab.dart';
import 'approvals_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  final List<Widget> _screens = [
    const DashboardStatsTab(),
    const ApprovalsTab(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdminController>().getDashboardStats();
      Get.find<AdminController>().getPendingApprovals();
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
        notchColor: AppColors.adminColor,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.dashboard_outlined, color: AppColors.subtitleColor),
            activeItem: Icon(Icons.dashboard, color: Colors.white),
            itemLabel: 'Stats',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.fact_check_outlined, color: AppColors.subtitleColor),
            activeItem: Icon(Icons.fact_check, color: Colors.white),
            itemLabel: 'Approvals',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person_outline, color: AppColors.subtitleColor),
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
