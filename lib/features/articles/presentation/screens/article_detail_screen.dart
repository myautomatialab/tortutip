import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(child: Text('Artículo: $articleId')),
    );
  }
}
