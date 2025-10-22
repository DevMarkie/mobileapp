import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/app_strings.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: NotificationsBody()),
    );
  }
}

class NotificationsBody extends StatefulWidget {
  const NotificationsBody({super.key});

  @override
  State<NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<_NotifItem> _allItems = [
    _NotifItem('Savannah Nguyen', 50),
    _NotifItem('Arlene McCoy', 55),
    _NotifItem('Dianne Russell', 30),
    _NotifItem('Cameron Williamson', 59),
    _NotifItem('Ralph Edwards', 90),
    _NotifItem('Bessie Cooper', 85, color: Color(0xFFFE4D45)),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final nextQuery = _searchController.text;
    if (nextQuery == _query) return;
    setState(() => _query = nextQuery);
  }

  List<_NotifItem> _filteredItems() {
    final trimmed = _query.trim().toLowerCase();
    if (trimmed.isEmpty) return _allItems;
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    return _allItems.where((item) {
      final nameMatch = item.name.toLowerCase().contains(trimmed);
      final amountMatch = digitsOnly.isNotEmpty
          ? item.amount.toString().contains(digitsOnly)
          : false;
      final messageMatch = item
          .message(context)
          .toLowerCase()
          .contains(trimmed);
      return nameMatch || amountMatch || messageMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0B2AA3)),
              ),
              const SizedBox(width: 4),
              Text(
                context.loc(AppStrings.notificationsTitle),
                style: const TextStyle(
                  color: Color(0xFF0B2AA3),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SearchField(controller: _searchController),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            context.loc(AppStrings.notificationsIntro),
            style: const TextStyle(
              color: Color(0xFF0B2AA3),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filteredItems.isEmpty
              ? _EmptyNotificationsMessage(query: _query)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (_, i) => _NotifTile(item: filteredItems[i]),
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemCount: filteredItems.length,
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: context.loc(AppStrings.notificationsSearch),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }
}

class _EmptyNotificationsMessage extends StatelessWidget {
  const _EmptyNotificationsMessage({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final message = context.loc(AppStrings.notificationsEmpty);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (query.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '"${query.trim()}"',
                style: const TextStyle(
                  color: Color(0xFF0B2AA3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotifItem {
  final String name;
  final int amount;
  final Color? color;
  const _NotifItem(this.name, this.amount, {this.color});

  String message(BuildContext context) {
    final amountText =
        ' ${context.loc(AppStrings.notificationsActionSentYou)} '
        '\$${amount.toString()}';
    return '$name$amountText';
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item});
  final _NotifItem item;

  @override
  Widget build(BuildContext context) {
    final initials = item.name.isNotEmpty
        ? item.name
              .trim()
              .split(RegExp(r"\s+"))
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : '?';
    final avatarColor = item.color ?? const Color(0xFF6789FF);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Color(0xFF0B2AA3)),
            children: [
              TextSpan(text: item.name),
              const TextSpan(text: ' '),
              TextSpan(
                text: context.loc(AppStrings.notificationsActionSentYou),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: ' \$${item.amount}',
                style: const TextStyle(
                  color: Color(0xFF4960F9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF0B2AA3)),
        onTap: () {},
      ),
    );
  }
}
