import 'package:flutter/material.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/presentation/widgets/feed_card.dart';

class FeedCardStack extends StatelessWidget {
  final List<ArticleEntity> articles;
  final int currentIndex;
  final Set<String> savedArticleIds;
  final VoidCallback onSwipe;
  final void Function(String articleId) onBookmark;

  const FeedCardStack({
    super.key,
    required this.articles,
    required this.currentIndex,
    required this.savedArticleIds,
    required this.onSwipe,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardWidth = screenWidth - AppSpacing.lg * 2;
    final cardHeight = screenHeight * 0.78;

    final hasNext = currentIndex + 1 < articles.length;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasNext)
            Transform.translate(
              offset: const Offset(0, 16),
              child: Transform.scale(
                scale: 0.95,
                child: FeedCard(
                  article: articles[currentIndex + 1],
                  isSaved: savedArticleIds.contains(articles[currentIndex + 1].id),
                  onSwipe: onSwipe,
                  onBookmark: onBookmark,
                ),
              ),
            ),
          FeedCard(
            article: articles[currentIndex],
            isSaved: savedArticleIds.contains(articles[currentIndex].id),
            onSwipe: onSwipe,
            onBookmark: onBookmark,
          ),
        ],
      ),
    );
  }
}
