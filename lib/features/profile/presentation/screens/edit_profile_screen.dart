import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tortutip/config/theme/app_colors.dart';
import 'package:tortutip/config/theme/app_spacing.dart';
import 'package:tortutip/config/theme/app_typography.dart';
import 'package:tortutip/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:tortutip/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/widgets/tortutip_button.dart';

class EditProfileScreen extends StatefulWidget {
  final UserEntity user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  String? _currentAvatarUrl;
  bool _nameError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _currentAvatarUrl =
        widget.user.avatarUrl.isNotEmpty ? widget.user.avatarUrl : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _onTapAvatar() async {
    final picker = ImagePicker();
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Cámara'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final file = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (file != null && mounted) {
                  context.read<EditProfileCubit>().uploadAvatar(
                        File(file.path),
                        widget.user.id,
                      );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (file != null && mounted) {
                  context.read<EditProfileCubit>().uploadAvatar(
                        File(file.path),
                        widget.user.id,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      setState(() => _nameError = true);
      return;
    }
    setState(() => _nameError = false);
    context.read<EditProfileCubit>().saveProfile(
          currentUser: widget.user,
          name: name,
          bio: _bioController.text.trim(),
          avatarUrl: _currentAvatarUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileImageUploaded) {
          setState(() => _currentAvatarUrl = state.avatarUrl);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        padding: EdgeInsets.only(
          left: AppSpacing.screenHorizontal,
          right: AppSpacing.screenHorizontal,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Editar Perfil', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.xl),
            _AvatarPicker(
              avatarUrl: _currentAvatarUrl,
              name: widget.user.name,
              onTap: _onTapAvatar,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _nameController,
              style: AppTypography.body,
              onChanged: (_) {
                if (_nameError) setState(() => _nameError = false);
              },
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Tu nombre',
                hintStyle: AppTypography.body
                    .copyWith(color: AppColors.textTertiary),
                errorText: _nameError
                    ? 'El nombre debe tener al menos 2 caracteres'
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _bioController,
              style: AppTypography.body,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Bio',
                hintText: 'Cuéntanos sobre ti',
                hintStyle: AppTypography.body
                    .copyWith(color: AppColors.textTertiary),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            BlocBuilder<EditProfileCubit, EditProfileState>(
              builder: (context, state) {
                final isLoading = state is EditProfileLoading ||
                    state is EditProfileImageUploading;
                return Column(
                  children: [
                    TortuPrimaryButton(
                      label: 'Guardar Cambios',
                      onTap: isLoading ? null : _onSave,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TortuSecondaryButton(
                      label: 'Cancelar',
                      onTap: isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final VoidCallback onTap;

  const _AvatarPicker({
    required this.avatarUrl,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.surface,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    initials,
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.white,
                size: AppSpacing.iconSizeMd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
