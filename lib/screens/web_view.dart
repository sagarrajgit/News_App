import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatelessWidget {
  const ArticleWebView({super.key, required this.articleUrl});

  final String articleUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        title: const Text(
          'News App',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          Opacity(
              opacity: 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Icon(Icons.save)))
        ],
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WebView(
                initialUrl: articleUrl,
                javascriptMode: JavascriptMode.unrestricted,
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color.fromRGBO(239, 83, 80, 1),
              ));
            }
          }),
    );
  }
}
