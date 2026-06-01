import 'dart:math';

import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/explore/data/data_sources/explore_remote_data_source.dart';

class MockExploreRemoteDataSource implements ExploreRemoteDataSource {
  static final List<ArticleEntity> _articles = [
    ArticleModel(
      id: 'mock_article_001',
      authorId: 'mock_user_001',
      categoryId: 'mock_cat_mindfulness',
      title: 'La ciencia detrás de la meditación diaria',
      body:
          'La meditación ha sido practicada durante miles de años en diversas culturas alrededor del mundo. Sin embargo, en las últimas décadas, la ciencia moderna ha comenzado a explorar y validar los profundos beneficios que esta práctica ancestral ofrece al cerebro y al cuerpo humano.',
      coverVerticalUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&q=80',
      coverHorizontalUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=1200&q=80',
      status: 'published',
      readTimeMinutes: 4,
      saveCount: 128,
      publishedAt: DateTime(2024, 1, 10),
      createdAt: DateTime(2024, 1, 10),
    ),
    ArticleModel(
      id: 'mock_article_002',
      authorId: 'mock_user_002',
      categoryId: 'mock_cat_nutrition',
      title: '5 hábitos alimenticios que transformarán tu energía',
      body:
          'La energía que sentimos a lo largo del día no depende únicamente de cuánto dormimos, sino también de cómo alimentamos nuestro cuerpo.',
      coverVerticalUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
      coverHorizontalUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=1200&q=80',
      status: 'published',
      readTimeMinutes: 3,
      saveCount: 84,
      publishedAt: DateTime(2024, 1, 11),
      createdAt: DateTime(2024, 1, 11),
    ),
    ArticleModel(
      id: 'mock_article_003',
      authorId: 'mock_user_001',
      categoryId: 'mock_cat_movement',
      title: 'Movimiento consciente: más allá del ejercicio',
      body:
          'Durante décadas, hemos tratado el ejercicio como una obligación, una tarea pendiente en nuestra lista de cosas por hacer.',
      coverVerticalUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80',
      coverHorizontalUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=1200&q=80',
      status: 'published',
      readTimeMinutes: 5,
      saveCount: 210,
      publishedAt: DateTime(2024, 1, 12),
      createdAt: DateTime(2024, 1, 12),
    ),
    ArticleModel(
      id: 'mock_article_004',
      authorId: 'mock_user_003',
      categoryId: 'mock_cat_sleep',
      title: 'Por qué dormir 8 horas no es suficiente',
      body:
          'Durante años hemos escuchado que ocho horas de sueño es la cantidad ideal para un adulto saludable.',
      coverVerticalUrl:
          'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=600&q=80',
      coverHorizontalUrl:
          'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=1200&q=80',
      status: 'published',
      readTimeMinutes: 6,
      saveCount: 305,
      publishedAt: DateTime(2024, 1, 13),
      createdAt: DateTime(2024, 1, 13),
    ),
    ArticleModel(
      id: 'mock_article_005',
      authorId: 'mock_user_002',
      categoryId: 'mock_cat_mindfulness',
      title: 'Respiración consciente en 3 minutos al día',
      body:
          'La respiración es la única función autónoma del cuerpo que también podemos controlar conscientemente.',
      coverVerticalUrl:
          'https://images.unsplash.com/photo-1474418397713-7ede21d49118?w=600&q=80',
      coverHorizontalUrl:
          'https://images.unsplash.com/photo-1474418397713-7ede21d49118?w=1200&q=80',
      status: 'published',
      readTimeMinutes: 2,
      saveCount: 67,
      publishedAt: DateTime(2024, 1, 14),
      createdAt: DateTime(2024, 1, 14),
    ),
  ];

  @override
  Future<List<ArticleEntity>> getArticlesByCategory(
    String categoryId,
    int page,
    int pageSize,
  ) async {
    final allForCategory =
        _articles.where((a) => a.categoryId == categoryId).toList();

    final start = page * pageSize;
    if (start >= allForCategory.length) return [];
    return allForCategory.sublist(
      start,
      min(start + pageSize, allForCategory.length),
    );
  }
}
