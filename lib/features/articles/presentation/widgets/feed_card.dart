import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tortutip/config/routes/app_routes.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/features/articles/presentation/widgets/feed_card_detail.dart';

class FeedCard extends StatefulWidget {
  final ArticleEntity article;
  final bool isSaved;
  final VoidCallback onSwipe;
  final void Function(String articleId) onBookmark;

  const FeedCard({
    super.key,
    required this.article,
    required this.isSaved,
    required this.onSwipe,
    required this.onBookmark,
  });

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> with TickerProviderStateMixin {
  static const double _dragAngleDivisor = 1000;
  static const double _swipeThreshold = 100;
  static const double _swipeVelocityThreshold = 800;
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _imageHeightFactor;
  late AnimationController _swipeController;
  double _dragOffset = 0.0;
  double _dragAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _imageHeightFactor = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeInOut),
    );
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragAngle = _dragOffset / _dragAngleDivisor;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final isSwipeRight = _dragOffset > 0;
    final isSwipeCompleted = _dragOffset.abs() > _swipeThreshold || velocity.abs() > _swipeVelocityThreshold;

    if (isSwipeCompleted) {
      if (isSwipeRight) {
        setState(() {
          _dragOffset = 0.0;
          _dragAngle = 0.0;
        });
        context.push(AppRoutes.articleDetailPath(widget.article.id));
      } else {
        widget.onSwipe();
        setState(() {
          _dragOffset = 0.0;
          _dragAngle = 0.0;
        });
      }
    } else {
      _animateSpringBack();
    }
  }

  void _animateSpringBack() {
    final startOffset = _dragOffset;
    final startAngle = _dragAngle;
    _swipeController.reset();
    _swipeController.addListener(() {
      setState(() {
        _dragOffset = startOffset * (1 - _swipeController.value);
        _dragAngle = startAngle * (1 - _swipeController.value);
      });
    });
    _swipeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateZ(_dragAngle)
        ..translateByDouble(_dragOffset, 0.0, 0.0, 1.0),
      alignment: Alignment.center,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: _toggleExpand,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBackground(),
              if (_isExpanded) _buildExpandedOverlay(),
              _buildCategoryChip(),
              _buildBookmarkButton(),
              if (!_isExpanded) _buildTitleOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _imageHeightFactor,
      builder: (context, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            heightFactor: _imageHeightFactor.value,
            widthFactor: 1.0,
            child: child,
          ),
        );
      },
      child: widget.article.coverVerticalUrl.isNotEmpty
          ? Image.network(
              widget.article.coverVerticalUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildPlaceholderImage(),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: AppSpacing.iconLg,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildExpandedOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: FeedCardDetail(article: widget.article),
    );
  }

  static const Map<String, String> _categoryNames = {
    'mock_cat_mindfulness': 'Mindfulness',
    'mock_cat_nutrition': 'Nutrition',
    'mock_cat_movement': 'Movement',
    'mock_cat_sleep': 'Sleep',
    'mock_cat_food': 'Healthy Food',
    'mock_cat_fitness': 'Fitness',
    'mock_cat_meditation': 'Meditation',
    'mock_cat_mental': 'Mental Health',
  };

  String _resolveCategoryName(String categoryId) {
    return _categoryNames[categoryId] ?? categoryId;
  }

  Widget _buildCategoryChip() {
    return Positioned(
      top: AppSpacing.lg,
      left: AppSpacing.lg,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.dark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          _resolveCategoryName(widget.article.categoryId),
          style: AppTypography.caption.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildBookmarkButton() {
    return Positioned(
      top: AppSpacing.md,
      right: AppSpacing.lg,
      child: GestureDetector(
        onTap: () => widget.onBookmark(widget.article.id),
        child: Container(
          width: AppSpacing.avatarSizeSm + AppSpacing.sm,
          height: AppSpacing.avatarSizeSm + AppSpacing.sm,
          decoration: BoxDecoration(
            color: AppColors.dark.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: widget.isSaved ? AppColors.primary : AppColors.white,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.transparent,
              AppColors.dark.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Text(
          widget.article.title,
          style: AppTypography.h3.copyWith(color: AppColors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
