import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/articles/domain/params/publish_article_params.dart';
import 'package:tortutip/features/articles/domain/params/upload_article_image_params.dart';
import 'package:tortutip/features/articles/domain/use_cases/publish_article_use_case.dart';
import 'package:tortutip/features/articles/domain/use_cases/upload_article_image_use_case.dart';
import 'package:tortutip/features/categories/domain/use_cases/get_all_categories_use_case.dart';
import 'package:tortutip/core/usecase/usecase.dart';

import 'create_article_state.dart';

class CreateArticleCubit extends Cubit<CreateArticleState> {
  final PublishArticleUseCase _publishArticle;
  final UploadArticleImageUseCase _uploadArticleImage;
  final GetAllCategoriesUseCase _getAllCategories;

  // Accumulated form state
  String? _coverVerticalUrl;
  String? _coverHorizontalUrl;
  String _title = '';
  String _categoryId = '';
  String _bodyJson = '';

  CreateArticleCubit(
    this._publishArticle,
    this._uploadArticleImage,
    this._getAllCategories,
  ) : super(const CreateArticleInitial());

  CreateArticleFormUpdated get _currentFormState => CreateArticleFormUpdated(
        coverVerticalUrl: _coverVerticalUrl,
        coverHorizontalUrl: _coverHorizontalUrl,
        title: _title,
        categoryId: _categoryId,
        bodyJson: _bodyJson,
      );

  Future<void> uploadCoverImage(File imageFile, bool isVertical) async {
    final userId = 'current_user';
    emit(CreateArticleImageUploading(isVertical: isVertical));
    final params = UploadArticleImageParams(
      userId: userId,
      imageFile: imageFile,
      isVertical: isVertical,
    );
    final result = await _uploadArticleImage(params);
    if (result.isSuccess) {
      if (isVertical) {
        _coverVerticalUrl = result.data;
      } else {
        _coverHorizontalUrl = result.data;
      }
      emit(_currentFormState);
    } else {
      emit(CreateArticleError(_mapErrorToMessage(result.error!)));
    }
  }

  void updateTitle(String title) {
    _title = title;
    emit(_currentFormState);
  }

  void selectCategory(String categoryId) {
    _categoryId = categoryId;
    emit(_currentFormState);
  }

  void updateBody(String bodyJson) {
    _bodyJson = bodyJson;
    emit(_currentFormState);
  }

  Future<void> publish(PublishArticleParams params) async {
    emit(const CreateArticleLoading());
    final result = await _publishArticle(params);
    if (result.isSuccess) {
      emit(CreateArticleSuccess(result.data!));
    } else {
      emit(CreateArticleError(_mapErrorToMessage(result.error!)));
    }
  }

  Future<void> publishFromForm(String authorId) async {
    emit(const CreateArticlePublishing());
    final readTime = _calculateReadTime(_bodyJson);
    final params = PublishArticleParams(
      authorId: authorId,
      categoryId: _categoryId,
      title: _title,
      body: _bodyJson,
      coverVerticalUrl: _coverVerticalUrl ?? '',
      coverHorizontalUrl: _coverHorizontalUrl ?? '',
      readTimeMinutes: readTime,
    );
    final result = await _publishArticle(params);
    if (result.isSuccess) {
      emit(CreateArticlePublished(result.data!));
    } else {
      emit(CreateArticleError(_mapErrorToMessage(result.error!)));
    }
  }

  int _calculateReadTime(String bodyJson) {
    final wordCount = bodyJson.trim().split(RegExp(r'\s+')).length;
    return (wordCount / 200).ceil().clamp(1, 999);
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para publicar artículos',
        'unavailable' => 'Sin conexión. Inténtalo de nuevo',
        _ => 'No se pudo publicar el artículo. Inténtalo de nuevo',
      };
    }
    return 'No se pudo publicar el artículo. Inténtalo de nuevo';
  }

  // Expose getAllCategories for the screen
  Future<void> loadCategories() async {
    // Screen uses CategoryCubit for categories — this is unused but kept for completeness
    await _getAllCategories(const NoParams());
  }
}
