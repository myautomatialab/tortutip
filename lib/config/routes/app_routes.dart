class AppRoutes {
  AppRoutes._();

  static const landing              = '/landing';
  static const login                = '/login';
  static const onboardingCategories = '/onboarding/categories';
  static const onboardingRole       = '/onboarding/role';
  static const onboardingDetails    = '/onboarding/details';
  static const feed                 = '/feed';
  static const explore              = '/explore';
  static const create               = '/create';
  static const editProfile          = '/explore/edit';
  static const profile              = '/profile';

  static String articleDetailPath(String id) => '/feed/$id';
  static String articlePath(String id) => '/article/$id';

  static String exploreCategoryPath(String categoryId) =>
      '/explore/category/$categoryId';
}
