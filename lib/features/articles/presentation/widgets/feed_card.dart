import 'package:flutter/material.dart';
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
      _dragAngle = _dragOffset / 1000;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx.abs();
    if (_dragOffset.abs() > 100 || velocity > 800) {
      widget.onSwipe();
      setState(() {
        _dragOffset = 0.0;
        _dragAngle = 0.0;
      });
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
          widget.article.categoryId,
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
          width: 40,
          height: 40,
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
