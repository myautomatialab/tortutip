import 'dart:math';

import 'package:tortutip/features/articles/data/data_sources/article_remote_data_source.dart';
import 'package:tortutip/features/articles/data/models/article_model.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';

class MockArticleRemoteDataSource implements ArticleRemoteDataSource {
  static final List<ArticleModel> _articles = [
    ArticleModel(
      id: 'mock_article_001',
      authorId: 'mock_user_001',
      categoryId: 'mock_cat_mindfulness',
      title: 'La ciencia detrás de la meditación diaria',
      body:
          'La meditación ha sido practicada durante miles de años en diversas culturas alrededor del mundo. Sin embargo, en las últimas décadas, la ciencia moderna ha comenzado a explorar y validar los profundos beneficios que esta práctica ancestral ofrece al cerebro y al cuerpo humano. Los estudios de neuroimagen han demostrado que la meditación regular produce cambios estructurales medibles en el cerebro, especialmente en regiones asociadas con la atención, la conciencia propia y la regulación emocional. La corteza prefrontal, responsable de la toma de decisiones y el pensamiento consciente, muestra mayor densidad de materia gris en meditadores experimentados. Al mismo tiempo, la amígdala, el centro del miedo y la respuesta al estrés, tiende a reducir su actividad con la práctica sostenida. La neuroplasticidad, es decir, la capacidad del cerebro para reorganizarse y formar nuevas conexiones neuronales, es la clave detrás de estos cambios. Cada vez que meditamos, estamos literalmente esculpiendo nuevos patrones en nuestro cerebro. Los beneficios no se limitan al cerebro: la meditación reduce los niveles de cortisol, la hormona del estrés, mejora la calidad del sueño, fortalece el sistema inmunológico y puede reducir la presión arterial. Para obtener estos beneficios, los investigadores sugieren comenzar con tan solo 10 minutos diarios de práctica consistente. La clave no es la duración, sino la regularidad.',
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
          'La energía que sentimos a lo largo del día no depende únicamente de cuánto dormimos, sino también de cómo alimentamos nuestro cuerpo. Los hábitos alimenticios que adoptamos pueden marcar una diferencia significativa en nuestros niveles de energía, concentración y bienestar general. El primer hábito fundamental es comenzar el día con un desayuno rico en proteínas y grasas saludables, evitando los azúcares refinados que generan picos y caídas de glucosa. Huevos, aguacate, frutos secos y semillas son aliados perfectos para una mañana productiva. El segundo hábito es mantener una hidratación constante: muchas personas confunden la sed con el hambre, y la deshidratación leve ya es suficiente para reducir la concentración en un 20%. El tercer hábito involucra comer en intervalos regulares para mantener estables los niveles de glucosa en sangre, evitando los ayunos prolongados involuntarios que disparan el cortisol. El cuarto hábito es incorporar alimentos fermentados como el yogur, el kéfir o el chucrut, que nutren la microbiota intestinal — hoy reconocida como el segundo cerebro por su influencia directa en el estado de ánimo y la energía. El quinto hábito es reducir el consumo de alimentos ultraprocesados que, aunque proporcionan energía rápida, generan inflamación crónica de bajo grado que nos deja fatigados con el tiempo.',
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
          'Durante décadas, hemos tratado el ejercicio como una obligación, una tarea pendiente en nuestra lista de cosas por hacer. Sin embargo, existe una perspectiva radicalmente diferente que está transformando la relación de millones de personas con el movimiento: la práctica del movimiento consciente. A diferencia del ejercicio tradicional, que a menudo se realiza de manera mecánica mientras la mente está en otro lugar, el movimiento consciente implica prestar atención plena a las sensaciones del cuerpo durante la actividad física. El yoga, el tai chi, la danza somática y el qigong son ejemplos de disciplinas que integran este enfoque. Los beneficios de mover el cuerpo con conciencia van más allá de lo físico. Cuando prestamos atención a cómo se siente cada movimiento, activamos el sistema nervioso parasimpático, reducimos el estrés y desarrollamos una relación más amigable con nuestro cuerpo. Estudios recientes han demostrado que el movimiento consciente mejora la propiocepción, es decir, la conciencia espacial del cuerpo, lo que reduce lesiones y mejora el desempeño atlético. Además, genera una mayor conexión mente-cuerpo que se traduce en mejor regulación emocional y una imagen corporal más positiva. La práctica no requiere equipamiento especial ni clases costosas: caminar descalzo sobre el pasto, estirarse al despertar prestando atención a cada músculo, o simplemente bailar en casa con plena presencia son formas accesibles de comenzar.',
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
          'Durante años hemos escuchado que ocho horas de sueño es la cantidad ideal para un adulto saludable. Pero la ciencia del sueño ha avanzado enormemente y hoy sabemos que la cantidad es solo una parte de la ecuación: la calidad del sueño es igual, o incluso más importante, que las horas totales. El sueño se organiza en ciclos de aproximadamente 90 minutos, cada uno compuesto por diferentes fases: sueño ligero, sueño profundo y sueño REM. Es durante el sueño profundo cuando el cuerpo realiza sus procesos de reparación física, y durante el REM cuando consolida la memoria y procesa las emociones. Si estos ciclos se interrumpen constantemente, aunque hayamos dormido ocho horas en total, no obtendremos todos los beneficios restauradores del sueño. Los factores que afectan la calidad del sueño son múltiples: la exposición a luz azul de pantallas antes de dormir suprime la producción de melatonina; las temperaturas elevadas en el dormitorio dificultan la bajada de temperatura corporal necesaria para conciliar el sueño; el alcohol, aunque puede facilitar quedarse dormido, fragmenta los ciclos durante la segunda mitad de la noche. Para mejorar la calidad del sueño, los expertos recomiendan mantener un horario consistente de sueño y despertar, incluido los fines de semana; crear un ambiente oscuro, fresco y silencioso; evitar cafeína después de las 2pm; y desarrollar una rutina de relajación de 30 minutos antes de acostarse.',
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
          'La respiración es la única función autónoma del cuerpo que también podemos controlar conscientemente, y este simple hecho la convierte en una herramienta extraordinaria para influir sobre nuestro sistema nervioso. Cuando respiramos de manera lenta, profunda y rítmica, activamos el nervio vago, que a su vez estimula el sistema parasimpático y genera una respuesta de calma en todo el organismo. A diferencia de otras prácticas de bienestar que requieren tiempo, equipamiento o un lugar especial, la respiración consciente está disponible en cualquier momento y lugar: en el asiento del metro, antes de una reunión importante, en medio de un conflicto emocional. La técnica más estudiada científicamente es la respiración 4-7-8: inhalar por 4 segundos, sostener por 7 y exhalar lentamente por 8. Solo tres ciclos de esta técnica son suficientes para reducir la frecuencia cardíaca y los niveles de cortisol de manera measurable. Otra técnica popular es la respiración en caja (box breathing), usada por los Navy SEALs para mantener la calma bajo presión extrema: inhalar 4 segundos, sostener 4, exhalar 4, sostener 4. La práctica de solo tres minutos diarios de respiración consciente, mantenida durante cuatro semanas, produce cambios medibles en la variabilidad de la frecuencia cardíaca, un indicador clave de la resiliencia al estrés. El mejor momento para practicar es al despertar, antes de revisar el teléfono, para establecer el tono del día.',
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
  Future<List<ArticleModel>> getFeedArticles(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return _articles;
    return _articles.where((a) => categoryIds.contains(a.categoryId)).toList();
  }

  @override
  Future<List<ArticleModel>> getFeedArticlesPaged(
    List<String> categoryIds,
    int page,
    int pageSize,
  ) async {
    final allFiltered = categoryIds.isEmpty
        ? _articles
        : _articles.where((a) => categoryIds.contains(a.categoryId)).toList();
    final start = page * pageSize;
    if (start >= allFiltered.length) return [];
    return allFiltered.sublist(start, min(start + pageSize, allFiltered.length));
  }

  @override
  Future<ArticleModel> getArticleDetail(String articleId) async {
    return _articles.firstWhere(
      (a) => a.id == articleId,
      orElse: () => throw Exception('Article not found: $articleId'),
    );
  }

  @override
  Future<List<ArticleModel>> getUserArticles(String userId) async {
    return _articles.where((a) => a.authorId == userId).toList();
  }

  @override
  Future<List<String>> getSavedArticleIds(String userId) async {
    return ['mock_article_003'];
  }

  @override
  Future<void> saveArticle(String userId, String articleId) async {
    return Future.value();
  }

  @override
  Future<void> unsaveArticle(String userId, String articleId) async {
    return Future.value();
  }

  @override
  Future<List<ArticleModel>> getRelatedArticles(
      String categoryId, String excludeArticleId) async {
    return _articles
        .where((a) => a.categoryId == categoryId && a.id != excludeArticleId)
        .take(5)
        .toList();
  }

  @override
  Future<ArticleModel> publishArticle(PublishArticleParams params) async {
    final first = _articles.first;
    return ArticleModel(
      id: 'mock_published_${DateTime.now().millisecondsSinceEpoch}',
      authorId: first.authorId,
      categoryId: first.categoryId,
      title: first.title,
      body: first.body,
      coverVerticalUrl: first.coverVerticalUrl,
      coverHorizontalUrl: first.coverHorizontalUrl,
      status: first.status,
      readTimeMinutes: first.readTimeMinutes,
      saveCount: first.saveCount,
      publishedAt: first.publishedAt,
      createdAt: first.createdAt,
    );
  }
}
