import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/articles/presentation/bloc/create_article/create_article_cubit.dart';
import 'package:tortutip/features/articles/presentation/bloc/create_article/create_article_state.dart';
import 'package:tortutip/features/articles/presentation/screens/preview_article_screen.dart';
import 'package:tortutip/features/articles/presentation/widgets/cover_upload_widget.dart';
import 'package:tortutip/features/articles/presentation/widgets/rich_text_toolbar.dart';
import 'package:tortutip/features/categories/domain/entities/category_entity.dart';
import 'package:tortutip/features/categories/presentation/bloc/category_cubit.dart';
import 'package:tortutip/features/categories/presentation/bloc/category_state.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';
import 'package:tortutip/shared/widgets/tortutip_chip.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  late final QuillController _quillController;
  late final TextEditingController _titleController;
  final _imagePicker = ImagePicker();

  bool _isUploadingVertical = false;
  bool _isUploadingHorizontal = false;
  String? _coverVerticalUrl;
  String? _coverHorizontalUrl;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _titleController = TextEditingController();

    _quillController.addListener(_onBodyChanged);

    context.read<CategoryCubit>().loadCategories();
  }

  void _onBodyChanged() {
    final json = jsonEncode(_quillController.document.toDelta().toJson());
    context.read<CreateArticleCubit>().updateBody(json);
  }

  @override
  void dispose() {
    _quillController.removeListener(_onBodyChanged);
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool _hasContent() {
    return _titleController.text.trim().isNotEmpty ||
        _coverVerticalUrl != null ||
        _coverHorizontalUrl != null ||
        _quillController.document.length > 1;
  }

  Future<void> _onClose() async {
    if (!_hasContent()) {
      context.pop();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Discard article?', style: AppTypography.h3),
        content: Text(
          'Your article will be lost if you leave now.',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Discard',
              style: AppTypography.label.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.pop();
    }
  }

  Future<void> _pickImage(bool isVertical) async {
    if (!mounted) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: AppSpacing.huge,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.textPrimary),
              title: Text('Camera', style: AppTypography.body),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.textPrimary),
              title: Text('Photo library', style: AppTypography.body),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return;

    final picked =
        await _imagePicker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;

    if (isVertical) {
      setState(() => _isUploadingVertical = true);
    } else {
      setState(() => _isUploadingHorizontal = true);
    }

    await context
        .read<CreateArticleCubit>()
        .uploadCoverImage(File(picked.path), isVertical);

    if (mounted) {
      setState(() {
        _isUploadingVertical = false;
        _isUploadingHorizontal = false;
      });
    }
  }

  void _onPreview() {
    final bodyJson =
        jsonEncode(_quillController.document.toDelta().toJson());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PreviewArticleScreen(
          title: _titleController.text,
          categoryId: '',
          bodyJson: bodyJson,
          coverVerticalUrl: _coverVerticalUrl,
          coverHorizontalUrl: _coverHorizontalUrl,
        ),
      ),
    );
  }

  void _onPublish() {
    context.read<CreateArticleCubit>().publishFromForm('current_user');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateArticleCubit, CreateArticleState>(
      listener: (ctx, state) {
        if (state is CreateArticlePublished) {
          context.pop();
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              content: Text(
                'Article published successfully!',
                style:
                    AppTypography.body.copyWith(color: AppColors.textOnDark),
              ),
            ),
          );
        } else if (state is CreateArticleError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                state.message,
                style:
                    AppTypography.body.copyWith(color: AppColors.textOnDark),
              ),
            ),
          );
        } else if (state is CreateArticleFormUpdated) {
          setState(() {
            _coverVerticalUrl = state.coverVerticalUrl;
            _coverHorizontalUrl = state.coverHorizontalUrl;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: _onClose,
          ),
          title: Text('Create Article', style: AppTypography.h4),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoverUploadWidget(
                      coverVerticalUrl: _coverVerticalUrl,
                      coverHorizontalUrl: _coverHorizontalUrl,
                      isUploadingVertical: _isUploadingVertical,
                      isUploadingHorizontal: _isUploadingHorizontal,
                      onTapVertical: () => _pickImage(true),
                      onTapHorizontal: () => _pickImage(false),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: AppTypography.h2,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Article title...',
                          hintStyle: AppTypography.h2.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (v) =>
                            context.read<CreateArticleCubit>().updateTitle(v),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _CategorySelector(),
                    const SizedBox(height: AppSpacing.sm),
                    RichTextToolbar(controller: _quillController),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                        vertical: AppSpacing.lg,
                      ),
                      child: QuillEditor.basic(
                        controller: _quillController,
                        config: const QuillEditorConfig(
                          placeholder: 'Write your article here...',
                          minHeight: 200,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomBar(onPreview: _onPreview, onPublish: _onPublish),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatefulWidget {
  @override
  State<_CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<_CategorySelector> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (ctx, state) {
        if (state is! CategoryLoaded) return const SizedBox.shrink();
        return SizedBox(
          height: AppSpacing.buttonHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            itemCount: state.categories.length,
            separatorBuilder: (ctx, i) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, i) {
              final cat = state.categories[i];
              return _SelectableCategoryChip(
                category: cat,
                isSelected: _selectedId == cat.id,
                onTap: () {
                  setState(() => _selectedId = cat.id);
                  context.read<CreateArticleCubit>().selectCategory(cat.id);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _SelectableCategoryChip extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableCategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderStrong,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: TortuCategoryChip.fromName(category.name),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onPreview;
  final VoidCallback onPublish;

  const _BottomBar({required this.onPreview, required this.onPublish});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateArticleCubit, CreateArticleState>(
      builder: (ctx, state) {
        final isPublishing = state is CreateArticlePublishing;
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TortuSecondaryButton(
                    label: 'Preview',
                    onTap: isPublishing ? null : onPreview,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TortuPrimaryButton(
                    label: 'Publish',
                    onTap: isPublishing ? null : onPublish,
                    isLoading: isPublishing,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
