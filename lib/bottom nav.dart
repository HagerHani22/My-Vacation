// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
// import 'package:flutter/material.dart';
//
// class VacationDays extends StatefulWidget {
//   const VacationDays({super.key});
//
//   @override
//   State<VacationDays> createState() => _VacationDaysState();
// }
//
// class _VacationDaysState extends State<VacationDays> {
//   int _page = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vacation Days'),
//       ),
//       body: Container(
//         color: Colors.white,
//         // child: Center(
//         //   child: Column(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: <Widget>[
//         //       Text(_page.toString(), textScaler: const TextScaler.linear(10.0)),
//         //       ElevatedButton(
//         //         child: const Text('Go To Page of index 1'),
//         //         onPressed: () {
//         //           final CurvedNavigationBarState? navBarState =
//         //               _bottomNavigationKey.currentState;
//         //           navBarState?.setPage(1);
//         //         },
//         //       )
//         //     ],
//         //   ),
//         // ),
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: 0,
//         items: const [
//           CurvedNavigationBarItem(
//             child: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           CurvedNavigationBarItem(
//             child: Icon(Icons.search),
//             label: 'Search',
//           ),
//           CurvedNavigationBarItem(
//             child: Icon(Icons.chat_bubble_outline),
//             label: 'Chat',
//           ),
//           // CurvedNavigationBarItem(
//           //   child: Icon(Icons.newspaper),
//           //   label: 'Feed',
//           // ),
//           // CurvedNavigationBarItem(
//           //   child: Icon(Icons.perm_identity),
//           //   label: 'Personal',
//           // ),
//         ],
//         color: Colors.white,
//         buttonBackgroundColor: Colors.white,
//         backgroundColor: Colors.blueAccent,
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 600),
//         onTap: (index) {
//           setState(() {
//             _page = index;
//           });
//         },
//         letIndexChange: (index) => true,
//       ),
//     );
//   }
// }
