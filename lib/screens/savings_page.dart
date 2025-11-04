import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../utils/currency_utils.dart';
import '../widgets/gradient_button.dart';
import 'notifications_page.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final List<_GoalData> _goals = [
    _GoalData(
      title: 'New Bike',
      savedAmount: 3200000,
      targetAmount: 9500000,
      deadline: DateTime(2024, 7, 30),
      contributionType: 'Monthly',
    ),
    _GoalData(
      title: 'iPhone 15 Pro',
      savedAmount: 7000000,
      targetAmount: 25990000,
      deadline: DateTime(2024, 12, 20),
      contributionType: 'Weekly',
    ),
  ];

  static const double _currentSavings = 8000000;
  static const double _monthlyGoal = 15000000;
  static final DateTime _monthlyGoalDate = DateTime(2024, 7);

  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double monthlyProgress = (_currentSavings / _monthlyGoal).clamp(0, 1);

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
          'Savings',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CurrentSavingsCard(amount: _currentSavings),
            const SizedBox(height: 24),
            _MonthlyGoalCard(
              progress: monthlyProgress,
              currentAmount: _currentSavings,
              goalAmount: _monthlyGoal,
              goalMonth: _monthlyGoalDate,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Your Goals',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Goals menu coming soon')),
                    );
                  },
                  icon: const Icon(Icons.more_horiz, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < _goals.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == _goals.length - 1 ? 0 : 16,
                ),
                child: _GoalTile(goal: _goals[i]),
              ),
          ],
        ),
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
              final result = await Navigator.of(context).push<_GoalData>(
                MaterialPageRoute(builder: (_) => const AddGoalScreen()),
              );
              if (!mounted) return;
              if (result != null) {
                setState(() => _goals.insert(0, result));
                messenger.showSnackBar(
                  SnackBar(content: Text('Goal "${result.title}" added!')),
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
              _SavingsNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: _selectedNavIndex == 0,
                onTap: () {
                  if (_selectedNavIndex == 0) return;
                  Navigator.of(context).pop();
                },
              ),
              _SavingsNavItem(
                icon: Icons.savings_rounded,
                label: 'Savings',
                isActive: _selectedNavIndex == 1,
                onTap: () => setState(() => _selectedNavIndex = 1),
              ),
              const SizedBox(width: 48),
              _SavingsNavItem(
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
              _SavingsNavItem(
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

class _CurrentSavingsCard extends StatelessWidget {
  const _CurrentSavingsCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102F80ED),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Savings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 160,
            width: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                formatCurrencyVND(amount),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyGoalCard extends StatelessWidget {
  const _MonthlyGoalCard({
    required this.progress,
    required this.currentAmount,
    required this.goalAmount,
    required this.goalMonth,
  });

  final double progress;
  final double currentAmount;
  final double goalAmount;
  final DateTime goalMonth;

  @override
  Widget build(BuildContext context) {
    final String monthLabel = DateFormat('MMMM yyyy').format(goalMonth);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102F80ED),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEFF2F7),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Goal for this Month',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatCurrencyVND(currentAmount)} / ${formatCurrencyVND(goalAmount)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE6ECFA),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final _GoalData goal;

  @override
  Widget build(BuildContext context) {
    final double progress = (goal.savedAmount / goal.targetAmount).clamp(0, 1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x102F80ED),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFEFF2F7),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Manage ${goal.title} coming soon'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.more_horiz, size: 20),
                      color: Colors.grey[500],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${formatCurrencyVND(goal.savedAmount)} saved',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Target ${formatCurrencyVND(goal.targetAmount)} • ${goal.contributionType} plan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE6ECFA),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(goal.deadline),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 30));
  String _contributionType = 'Monthly';

  static const List<String> _contributionOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickContributionType() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
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
                'Contribution Type',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              for (final option in _contributionOptions)
                ListTile(
                  title: Text(option),
                  trailing: option == _contributionType
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
      setState(() => _contributionType = result);
    }
  }

  Future<void> _pickDeadline() async {
    final DateTime now = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (newDate != null) {
      setState(() => _selectedDeadline = newDate);
    }
  }

  void _handleSubmit() {
    final String title = _titleController.text.trim();
    final String amount = _amountController.text.trim();
    if (title.isEmpty || amount.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }
    final String cleanedAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    final double? parsedAmount = double.tryParse(cleanedAmount);
    if (parsedAmount == null || parsedAmount <= 0) {
      _showMessage('Enter a valid amount.');
      return;
    }

    Navigator.of(context).pop(
      _GoalData(
        title: title,
        savedAmount: 0,
        targetAmount: parsedAmount,
        deadline: _selectedDeadline,
        contributionType: _contributionType,
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
    final NumberFormat formatter = NumberFormat('MM/dd/yyyy');
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
          'Add Goal',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LabeledTextField(
              controller: _titleController,
              label: 'Goal Title',
              hintText: 'New house',
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
            Text(
              'Contribution Type',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickContributionType,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _contributionType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(Icons.expand_more, color: AppColors.primaryBlue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Deadline',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDeadline,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatter.format(_selectedDeadline),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: GradientButton(label: 'ADD GOAL', onTap: _handleSubmit),
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

class _GoalData {
  const _GoalData({
    required this.title,
    required this.savedAmount,
    required this.targetAmount,
    required this.deadline,
    required this.contributionType,
  });

  final String title;
  final double savedAmount;
  final double targetAmount;
  final DateTime deadline;
  final String contributionType;
}

class _SavingsNavItem extends StatelessWidget {
  const _SavingsNavItem({
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
