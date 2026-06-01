import 'package:tortutip/features/categories/data/data_sources/category_remote_data_source.dart';
import 'package:tortutip/features/categories/data/models/category_model.dart';

class MockCategoryRemoteDataSource implements CategoryRemoteDataSource {
  static const List<CategoryModel> _categories = [
    CategoryModel(
      id: 'mock_cat_mindfulness',
      name: 'Mindfulness',
      description: 'Find inner peace through mindfulness and breath.',
      iconUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&q=80',
    ),
    CategoryModel(
      id: 'mock_cat_nutrition',
      name: 'Nutrition',
      description: 'Discover the power of conscious eating and nutrition.',
      iconUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
    ),
    CategoryModel(
      id: 'mock_cat_movement',
      name: 'Movement',
      description: 'Build strength and resilience through mindful movement.',
      iconUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600&q=80',
    ),
    CategoryModel(
      id: 'mock_cat_sleep',
      name: 'Sleep',
      description: 'Improve your sleep quality and restoration.',
      iconUrl: 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=600&q=80',
    ),
  ];

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }
}
