import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/presentation/bloc/article_detail/article_detail_cubit.dart';
import 'package:tortutip/features/tortu_feed/presentation/widgets/tortu_feed_completed_view.dart';
import 'package:tortutip/features/tortu_feed/presentation/widgets/tortu_feed_slider.dart';

enum _TortuFeedState { collapsed, expanded, completed }

class TortuFeedWidget extends StatefulWidget {
  final bool isSaved;
  final bool isDoneToday;
  final String userId;
  final String articleId;
  final String categoryId;

  const TortuFeedWidget({
    super.key,
    required this.isSaved,
    required this.isDoneToday,
    required this.userId,
    required this.articleId,
    required this.categoryId,
  });

  @override
  State<TortuFeedWidget> createState() => _TortuFeedWidgetState();
}

class _TortuFeedWidgetState extends State<TortuFeedWidget>
    with TickerProviderStateMixin {
  _TortuFeedState _state = _TortuFeedState.collapsed;
  bool _isDoneToday = false;

  late AnimationController _expandController;
  late Animation<double> _expandAnim;
  late AnimationController _appearController;
  late Animation<double> _appearAnim;

  @override
  void initState() {
    super.initState();
    _isDoneToday = widget.isDoneToday;

    _appearController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _appearAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appearController, curve: Curves.elasticOut),
    );
    _appearController.forward();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnim = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(TortuFeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDoneToday != oldWidget.isDoneToday) {
      setState(() => _isDoneToday = widget.isDoneToday);
    }
  }

  @override
  void dispose() {
    _appearController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _onTapCollapsed() {
    if (_isDoneToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vuelve mañana para seguir alimentando a Tortu 🐢'),
        ),
      );
      return;
    }
    setState(() => _state = _TortuFeedState.expanded);
    _expandController.forward();
  }

  Future<void> _onComplete() async {
    setState(() => _state = _TortuFeedState.completed);
    final cubit = context.read<ArticleDetailCubit>();
    await cubit.feedTortu(widget.userId, widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSaved) return const SizedBox.shrink();

    return Positioned(
      bottom: AppSpacing.xxl,
      right: AppSpacing.lg,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_state) {
      case _TortuFeedState.collapsed:
        return _buildCollapsed();
      case _TortuFeedState.expanded:
        return _buildExpanded(context);
      case _TortuFeedState.completed:
        return _buildCompleted();
    }
  }

  Widget _buildCollapsed() {
    final isDone = _isDoneToday;
    return ScaleTransition(
      scale: _appearAnim,
      child: GestureDetector(
        onTap: _onTapCollapsed,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isDone ? AppColors.surface : AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.eco,
            color: isDone ? AppColors.textSecondary : AppColors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FadeTransition(
      opacity: _expandAnim,
      child: SizeTransition(
        sizeFactor: _expandAnim,
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🐢', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Darle de comer a Tortu',
                    style: AppTypography.bodyLg
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TortuFeedSlider(onComplete: _onComplete),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleted() {
    return TortuFeedCompletedView(
      onDone: () {
        setState(() {
          _state = _TortuFeedState.collapsed;
          _isDoneToday = true;
        });
      },
    );
  }
}
