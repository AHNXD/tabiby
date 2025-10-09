// import 'package:flutter/material.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({super.key});
//   static const String routeName = "/nav";

//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar>
//     with AutomaticKeepAliveClientMixin {
//   int _currentIndex = 2;

//   final List<Widget> _pages = [
//     // const CurriculumPage(),
//     const CoursesPage(courseTypeId: 4), // winter_sessions
//     const CoursesPage(courseTypeId: 2), // weekly_sessions
//     HomePage(),
//     const CoursesPage(courseTypeId: 3), // capacitors
//     const CoursesPage(courseTypeId: 1), // exam_sessions
//   ];

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed, // Keeps labels always visible
//         selectedItemColor: AppColors.textButtonColors,
//         unselectedItemColor: AppColors.backgroundColor,
//         backgroundColor: AppColors.primaryColors,
//         selectedIconTheme: IconThemeData(size: 30),
//         selectedLabelStyle:
//             const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//         unselectedLabelStyle:
//             const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
//         items: [
//           // BottomNavigationBarItem(
//           //   activeIcon: const Icon(Icons.library_books),
//           //   icon: const Icon(Icons.library_books_outlined),
//           //   label: "curriculum".tr(context),
//           // ),
//           BottomNavigationBarItem(
//             activeIcon: const Icon(Icons.school),
//             icon: const Icon(Icons.school_outlined),
//             label: "winter_sessions".tr(context),
//           ),
//           BottomNavigationBarItem(
//             activeIcon: const Icon(Icons.calendar_today),
//             icon: const Icon(Icons.calendar_today_outlined),
//             label: "weekly_sessions".tr(context),
//           ),
//           BottomNavigationBarItem(
//             activeIcon: const Icon(Icons.home),
//             icon: const Icon(Icons.home_outlined),
//             label: "home".tr(context),
//           ),
//           BottomNavigationBarItem(
//             activeIcon: const Icon(Icons.video_library),
//             icon: const Icon(Icons.video_library_outlined),
//             label: "capacitors".tr(context),
//           ),
//           BottomNavigationBarItem(
//             activeIcon: const Icon(Icons.note_alt),
//             icon: const Icon(Icons.note_alt_outlined),
//             label: "exam_sessions".tr(context),
//           ),
//         ],
//       ),
//     );
//   }
// }
