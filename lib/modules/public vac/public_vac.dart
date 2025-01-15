// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class PublicVacation extends StatelessWidget {
//   const PublicVacation({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text('الأجازات الرسمية'),
//         ),
//         body: WebView(
//             initialUrl: 'https://www.presidency.eg/ar/%D9%85%D8%B5%D8%B1/%D8%A7%D9%84%D8%B9%D8%B7%D9%84%D8%A7%D8%AA-%D8%A7%D9%84%D8%B1%D8%B3%D9%85%D9%8A%D8%A9/',
//             javascriptMode: JavascriptMode.unrestricted));
//   }
// }
//
//
import 'package:flutter/material.dart';

class PublicVacation extends StatelessWidget {
  const PublicVacation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
        title: const Text('الأجازات الرسمية',style: TextStyle(color: Colors.white),),
      ),
      body:  InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.1,
        maxScale: 5,
          child: const Center(child: Image(image: AssetImage('assets/images/FormalHolidayAll.png'),)),),
    );
  }
}
