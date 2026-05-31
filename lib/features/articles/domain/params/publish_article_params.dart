class PublishArticleParams {
  final String authorId;
  final String categoryId;
  final String title;
  final String body;
  final String coverVerticalUrl;
  final String coverHorizontalUrl;

  const PublishArticleParams({
    required this.authorId,
    required this.categoryId,
    required this.title,
    required this.body,
    required this.coverVerticalUrl,
    required this.coverHorizontalUrl,
  });
}
