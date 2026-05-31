import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateArticleScreen extends StatelessWidget {
  const CreateArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Crear artículo'),
      ),
      body: const Center(child: Text('Crear artículo')),
    );
  }
}
