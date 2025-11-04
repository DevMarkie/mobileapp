import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/screens/notifications/notifications_page.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';
import 'package:flutter_application_1/utils/currency_utils.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<_ReminderData> _reminders = [
    _ReminderData(
      title: 'Netflix Plan',
      amount: 129000,
      frequency: 'Monthly',
      nextDate: DateTime(2024, 10, 28),
      icon: Icons.movie_outlined,
    ),
    _ReminderData(
      title: 'Car Wash',
      amount: 150000,
      frequency: 'Weekly',
      nextDate: DateTime(2024, 10, 30),
      icon: Icons.local_car_wash_outlined,
    ),
    _ReminderData(
      title: 'House Rent',
      amount: 4500000,
      frequency: 'Monthly',
      nextDate: DateTime(2024, 11, 1),
      icon: Icons.home_work_outlined,
    ),
    _ReminderData(
      title: 'Shopping',
      amount: 850000,
      frequency: 'Monthly',
      nextDate: DateTime(2024, 11, 5),
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Reminders',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return _ReminderTile(data: reminder);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: _reminders.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 68,
        width: 68,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(
                color: Color(0x552F6BFF),
                offset: Offset(0, 12),
                blurRadius: 24,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final result = await Navigator.of(context).push<_ReminderData>(
                MaterialPageRoute(builder: (_) => const AddReminderScreen()),
              );
              if (!mounted) return;
              if (result != null) {
                setState(() => _reminders.insert(0, result));
                messenger.showSnackBar(
                  SnackBar(content: Text('Reminder "${result.title}" added!')),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 8,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RemindersNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _selectedNavIndex == 0,
                onTap: () => Navigator.of(context).pop(),
              ),
              _RemindersNavItem(
                icon: Icons.notifications_rounded,
                label: 'Remind',
                isActive: _selectedNavIndex == 1,
                onTap: () => setState(() => _selectedNavIndex = 1),
              ),
              const SizedBox(width: 48),
              _RemindersNavItem(
                icon: Icons.notifications_none_rounded,
                label: 'Alerts',
                isActive: _selectedNavIndex == 2,
                onTap: () async {
                  if (_selectedNavIndex == 2) return;
                  setState(() => _selectedNavIndex = 2);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                  if (!mounted) return;
                  setState(() => _selectedNavIndex = 1);
                },
              ),
              _RemindersNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: _selectedNavIndex == 3,
                onTap: () => setState(() => _selectedNavIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.data});

  final _ReminderData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2F80ED),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFEFF2F7),
            ),
            child: Icon(data.icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Next on ${DateFormat('dd MMM yyyy').format(data.nextDate)} • ${data.frequency}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatCurrencyVND(data.amount),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedFrequency = 'Monthly';
  String _selectedCategory = 'Car Wash';

  static const List<String> _frequencyOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  static const List<String> _categoryOptions = [
    'Car Wash',
    'Internet Plan',
    'House Rent',
    'Shopping',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Select Category',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              for (final option in _categoryOptions)
                ListTile(
                  title: Text(option),
                  trailing: option == _selectedCategory
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryBlue,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _selectedCategory = result);
    }
  }

  Future<void> _pickFrequency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Frequency',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              for (final option in _frequencyOptions)
                ListTile(
                  title: Text(option),
                  trailing: option == _selectedFrequency
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryBlue,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _selectedFrequency = result);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (newDate != null) {
      setState(() => _selectedDate = newDate);
    }
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty || amountText.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }
    final cleanedAmount = amountText.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(cleanedAmount);
    if (amount == null || amount <= 0) {
      _showMessage('Enter a valid amount.');
      return;
    }

    Navigator.of(context).pop(
      _ReminderData(
        title: title,
        amount: amount,
        frequency: _selectedFrequency,
        nextDate: _selectedDate,
        icon: Icons.notifications_none_outlined,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay = DateFormat('MM/dd/yyyy').format(_selectedDate);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Set Reminder',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LabeledPickerField(
              label: 'Select Goal',
              value: _selectedCategory,
              icon: Icons.list_alt_outlined,
              onTap: _pickCategory,
            ),
            const SizedBox(height: 20),
            _LabeledTextField(
              controller: _titleController,
              label: 'Reminder Name',
              hintText: 'Car Wash',
              icon: Icons.edit_outlined,
            ),
            const SizedBox(height: 20),
            _LabeledTextField(
              controller: _amountController,
              label: 'Amount',
              hintText: '0.00',
              icon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            _LabeledPickerField(
              label: 'Frequency',
              value: _selectedFrequency,
              icon: Icons.repeat_rounded,
              onTap: _pickFrequency,
            ),
            const SizedBox(height: 20),
            _LabeledPickerField(
              label: 'Date',
              value: dateDisplay,
              icon: Icons.calendar_today_outlined,
              onTap: _pickDate,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: GradientButton(
                label: 'SET REMINDER',
                onTap: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              borderSide: BorderSide(color: AppColors.primaryBlue),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledPickerField extends StatelessWidget {
  const _LabeledPickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primaryBlue, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.expand_more, color: AppColors.primaryBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderData {
  const _ReminderData({
    required this.title,
    required this.amount,
    required this.frequency,
    required this.nextDate,
    required this.icon,
  });

  final String title;
  final double amount;
  final String frequency;
  final DateTime nextDate;
  final IconData icon;
}

class _RemindersNavItem extends StatelessWidget {
  const _RemindersNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.primaryBlue : Colors.grey[500]!;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
