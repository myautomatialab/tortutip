import 'package:tortutip/features/categories/data/data_sources/category_remote_data_source.dart';
import 'package:tortutip/features/categories/data/models/category_model.dart';

class MockCategoryRemoteDataSource implements CategoryRemoteDataSource {
  static final List<CategoryModel> _categories = [
    const CategoryModel(
      id: 'mock_cat_food',
      name: 'Healthy Food',
      description: 'Discover the power of conscious eating and nutrition.',
      iconUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
    ),
    const CategoryModel(
      id: 'mock_cat_fitness',
      name: 'Fitness',
      description: 'Build strength and resilience through movement.',
      iconUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80',
    ),
    const CategoryModel(
      id: 'mock_cat_meditation',
      name: 'Meditation',
      description: 'Find inner peace through mindfulness and breath.',
      iconUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&q=80',
    ),
    const CategoryModel(
      id: 'mock_cat_mental',
      name: 'Mental Health',
      description: 'Nurture your mind and emotional well-being.',
      iconUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80',
    ),
  ];

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }
}
