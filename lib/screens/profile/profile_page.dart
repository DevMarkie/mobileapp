import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.profileTitle)),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                localizations.profileSignInRequired,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.profileTitle)),
      body: SafeArea(
        child: StreamBuilder<UserProfile?>(
          stream: UserService.profileStream(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    localizations.profileLoadError,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            final profile = snapshot.data;
            final resolvedData = _buildProfileData(
              user: user,
              profile: profile,
              localizations: localizations,
            );

            final actions = <_ProfileAction>[
              _ProfileAction(
                icon: Icons.edit_outlined,
                label: localizations.profileEditAction,
                onPressed: () =>
                    _openEditProfile(context, localizations, user, profile),
              ),
              _ProfileAction(
                icon: Icons.lock_outline,
                label: localizations.profileSecurityAction,
              ),
              _ProfileAction(
                icon: Icons.credit_card,
                label: localizations.profilePaymentAction,
              ),
              _ProfileAction(
                icon: Icons.notifications_active_outlined,
                label: localizations.profileNotificationsAction,
              ),
            ];

            final colorScheme = Theme.of(context).colorScheme;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(
                    data: resolvedData,
                    colorScheme: colorScheme,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(text: localizations.profilePersonalInfoSection),
                  const SizedBox(height: 12),
                  _InfoCard(
                    items: [
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: localizations.profileEmailLabel,
                        value: resolvedData.email,
                      ),
                      _InfoRow(
                        icon: Icons.phone_outlined,
                        label: localizations.profilePhoneLabel,
                        value: resolvedData.phone,
                      ),
                      _InfoRow(
                        icon: Icons.home_outlined,
                        label: localizations.profileAddressLabel,
                        value: resolvedData.address,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(text: localizations.profileActionsSection),
                  const SizedBox(height: 12),
                  _ActionsCard(
                    actions: actions,
                    onFallbackTap: (label) {
                      _showComingSoon(context, localizations, label);
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => _confirmSignOut(context, localizations),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(localizations.profileLogoutAction),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showComingSoon(
    BuildContext context,
    AppLocalizations localizations,
    String label,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${localizations.commonComingSoon} · $label')),
      );
  }

  Future<void> _openEditProfile(
    BuildContext context,
    AppLocalizations localizations,
    User user,
    UserProfile? profile,
  ) async {
    final initialName = profile?.name ?? user.displayName ?? '';
    final initialPhone = profile?.phone ?? user.phoneNumber ?? '';
    final initialAddress = profile?.address ?? '';

    final result = await showModalBottomSheet<_EditProfileResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _EditProfileSheet(
        localizations: localizations,
        initialName: initialName,
        initialPhone: initialPhone,
        initialAddress: initialAddress,
      ),
    );

    if (result == null) {
      return;
    }

    String sanitize(String value) => value.trim();
    String? sanitizeOptional(String value) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final name = sanitize(result.name);
    final phone = sanitizeOptional(result.phone);
    final address = sanitizeOptional(result.address);

    bool hasChanged(String? before, String? after) {
      return (before ?? '').trim() != (after ?? '').trim();
    }

    final updates = <String, dynamic>{};
    if (profile == null || hasChanged(profile.name, name)) {
      updates['name'] = name;
    }
    if (profile == null || hasChanged(profile.phone, phone)) {
      updates['phone'] = phone;
    }
    if (profile == null || hasChanged(profile.address, address)) {
      updates['address'] = address;
    }

    final displayNameChanged = hasChanged(user.displayName, name);

    if (updates.isEmpty && !displayNameChanged) {
      return;
    }

    try {
      if (updates.isNotEmpty) {
        await UserService.updateProfile(user.uid, updates);
      }
      if (displayNameChanged) {
        await user.updateDisplayName(name);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(localizations.profileEditSuccess)),
        );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(localizations.profileEditError)));
    }
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    final theme = Theme.of(context);
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(localizations.profileLogoutConfirmTitle),
            content: Text(localizations.profileLogoutConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(localizations.commonCancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(localizations.profileLogoutConfirmAccept),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await AuthService.signOut();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) =>
            LoginScreen(initialMessage: localizations.profileSignedOutMessage),
      ),
      (_) => false,
    );
  }

  _ProfileData _buildProfileData({
    required User user,
    required UserProfile? profile,
    required AppLocalizations localizations,
  }) {
    String? clean(String? value) {
      if (value == null) return null;
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final name =
        clean(profile?.name) ??
        clean(user.displayName) ??
        localizations.profileDefaultName;
    final email =
        clean(profile?.email) ??
        clean(user.email) ??
        localizations.profileMissingValue;
    final phone =
        clean(profile?.phone) ??
        clean(user.phoneNumber) ??
        localizations.profileMissingValue;
    final address =
        clean(profile?.address) ?? localizations.profileMissingValue;
    final membershipTier = _localizeMembershipTier(
      clean(profile?.membershipTier),
      localizations,
    );

    final sinceDate = profile?.createdAt ?? user.metadata.creationTime;
    final localeTag = localizations.locale.toLanguageTag();
    final memberSinceLabel = sinceDate != null
        ? DateFormat.yMMMMd(localeTag).format(sinceDate)
        : localizations.profileMissingValue;

    return _ProfileData(
      name: name,
      email: email,
      phone: phone,
      address: address,
      membershipTier: membershipTier,
      memberSince: sinceDate,
      memberSinceLabel: memberSinceLabel,
    );
  }

  String _localizeMembershipTier(
    String? value,
    AppLocalizations localizations,
  ) {
    if (value == null) {
      return localizations.profileMembershipDefault;
    }

    switch (value.toLowerCase()) {
      case 'basic':
        return localizations.profileMembershipDefault;
      default:
        return value;
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.data,
    required this.colorScheme,
    required this.localizations,
  });

  final _ProfileData data;
  final ColorScheme colorScheme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [colorScheme.primary, colorScheme.primaryContainer],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.32),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: colorScheme.onPrimary.withValues(
                    alpha: 0.12,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: _HeaderPill(
                              icon: Icons.workspace_premium_outlined,
                              label:
                                  '${localizations.profileMembershipLabel}: ${data.membershipTier}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 8),
                Text(
                  '${localizations.profileSinceLabel}: ${data.memberSinceLabel}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.items});

  final List<_InfoRow> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              items[i],
              if (i != items.length - 1)
                Divider(
                  height: 20,
                  thickness: 1,
                  color: colorScheme.outlineVariant,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({required this.actions, required this.onFallbackTap});

  final List<_ProfileAction> actions;
  final void Function(String label) onFallbackTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: actions
            .asMap()
            .entries
            .map(
              (entry) => Column(
                children: [
                  ListTile(
                    leading: Icon(entry.value.icon, color: colorScheme.primary),
                    title: Text(entry.value.label),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      final action = entry.value;
                      if (action.onPressed != null) {
                        action.onPressed!();
                      } else {
                        onFallbackTap(action.label);
                      }
                    },
                  ),
                  if (entry.key != actions.length - 1)
                    Divider(
                      height: 0,
                      thickness: 1,
                      indent: 18,
                      endIndent: 18,
                      color: colorScheme.outlineVariant,
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.localizations,
    required this.initialName,
    required this.initialPhone,
    required this.initialAddress,
  });

  final AppLocalizations localizations;
  final String initialName;
  final String initialPhone;
  final String initialAddress;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.profileEditTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.profileEditNameLabel,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations.profileEditValidationName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: localizations.profileEditPhoneLabel,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: localizations.profileEditAddressLabel,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localizations.commonCancel),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _handleSubmit,
                    child: Text(localizations.profileEditSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      _EditProfileResult(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      ),
    );
  }
}

class _EditProfileResult {
  const _EditProfileResult({
    required this.name,
    required this.phone,
    required this.address,
  });

  final String name;
  final String phone;
  final String address;
}

class _ProfileAction {
  const _ProfileAction({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
}

class _ProfileData {
  const _ProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.membershipTier,
    this.memberSince,
    required this.memberSinceLabel,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String membershipTier;
  final DateTime? memberSince;
  final String memberSinceLabel;
}
