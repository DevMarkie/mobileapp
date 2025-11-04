import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/utils/currency_utils.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final List<GoalData> _goals = [
    GoalData(
      id: 'goal-car',
      title: 'Mua xe',
      savedAmount: 3000000,
      targetAmount: 3000000,
      deadline: DateTime(2025, 2, 10),
      contributionType: 'Hang thang',
    ),
    GoalData(
      id: 'goal-trip',
      title: 'Du lich he',
      savedAmount: 1500000,
      targetAmount: 4500000,
      deadline: DateTime(2025, 6, 30),
      contributionType: 'Hang thang',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final double totalSaved = _goals.fold(
      0,
      (sum, goal) => sum + goal.savedAmount,
    );
    final double totalTarget = _goals.fold(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final int totalGoals = _goals.length;
    final int completedGoals = _goals
        .where((goal) => goal.savedAmount >= goal.targetAmount)
        .length;
    final double overallProgress = totalTarget == 0
        ? 0
        : (totalSaved / totalTarget).clamp(0, 1);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Tiet kiem',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quan ly muc tieu tiet kiem',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _SavingsSummaryCard(
              totalSaved: totalSaved,
              totalTarget: totalTarget,
              overallProgress: overallProgress,
              totalGoals: totalGoals,
              completedGoals: completedGoals,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sach muc tieu',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: onSurfaceVariant),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tinh nang sap ra mat')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_goals.isEmpty)
              const _EmptyGoalsView()
            else
              Column(
                children: [
                  for (var i = 0; i < _goals.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i == _goals.length - 1 ? 0 : 16,
                      ),
                      child: _GoalTile(
                        goal: _goals[i],
                        onEdit: () => _openGoalForm(initialGoal: _goals[i]),
                        onDelete: () => _confirmDeleteGoal(_goals[i]),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: GradientButton(
                label: 'Them muc tieu moi',
                onTap: _openGoalForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoalForm({GoalData? initialGoal}) async {
    final result = await Navigator.of(context).push<GoalData>(
      MaterialPageRoute(
        builder: (_) => AddGoalScreen(initialGoal: initialGoal),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      final index = _goals.indexWhere((goal) => goal.id == result.id);
      if (index >= 0) {
        _goals[index] = result;
        _showSnackBar('Muc tieu "${result.title}" da cap nhat!');
      } else {
        _goals.insert(0, result);
        _showSnackBar('Da them muc tieu "${result.title}"!');
      }
    });
  }

  Future<void> _confirmDeleteGoal(GoalData goal) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoa muc tieu'),
        content: Text('Ban co chac muon xoa "${goal.title}" khong?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Huy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xoa'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      setState(() => _goals.removeWhere((item) => item.id == goal.id));
      _showSnackBar('Da xoa muc tieu "${goal.title}".');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? const Color(0xFFE11D48)
            : AppColors.primaryBlue,
      ),
    );
  }
}

class _SavingsSummaryCard extends StatelessWidget {
  const _SavingsSummaryCard({
    required this.totalSaved,
    required this.totalTarget,
    required this.overallProgress,
    required this.totalGoals,
    required this.completedGoals,
  });

  final double totalSaved;
  final double totalTarget;
  final double overallProgress;
  final int totalGoals;
  final int completedGoals;

  @override
  Widget build(BuildContext context) {
    final int progressPercent = ((overallProgress * 100).clamp(0, 100)).round();
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF16A085)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3327AE60),
            offset: Offset(0, 18),
            blurRadius: 38,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tong tiet kiem',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            formatCurrencyVND(totalSaved),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Muc tieu: ${formatCurrencyVND(totalTarget)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tien do chung',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 12,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'So muc tieu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalGoals',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 32, color: Colors.white30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Hoan thanh',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedGoals',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGoalsView extends StatelessWidget {
  const _EmptyGoalsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.savings_outlined, color: onSurfaceVariant, size: 40),
          const SizedBox(height: 16),
          Text(
            'Chua co muc tieu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bam nut ben duoi de them muc tieu tiet kiem moi.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  final GoalData goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final surface = colorScheme.surface;
    final double progress = goal.targetAmount == 0
        ? 0
        : (goal.savedAmount / goal.targetAmount).clamp(0, 1);
    final int progressPercent = ((progress * 100).clamp(0, 100)).round();
    final bool isCompleted = progress >= 1;
    final Color statusColor = isCompleted
        ? const Color(0xFF16A085)
        : colorScheme.primary;
    final String deadlineLabel = DateFormat('dd/MM/yyyy').format(goal.deadline);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.primaryContainer.withOpacity(0.18),
                ),
                child: const Icon(
                  Icons.savings_rounded,
                  color: Color(0xFF1ABC9C),
                  size: 26,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                            ),
                          ),
                        ),
                        PopupMenuButton<_GoalMenuAction>(
                          onSelected: (action) {
                            switch (action) {
                              case _GoalMenuAction.edit:
                                onEdit();
                                break;
                              case _GoalMenuAction.delete:
                                onDelete();
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: _GoalMenuAction.edit,
                              child: Text('Chinh sua'),
                            ),
                            PopupMenuItem(
                              value: _GoalMenuAction.delete,
                              child: Text('Xoa muc tieu'),
                            ),
                          ],
                          icon: Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: onSurfaceVariant,
                          ),
                          color: surface,
                          elevation: 6,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${formatCurrencyVND(goal.savedAmount)} • Muc tieu ${formatCurrencyVND(goal.targetAmount)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Dong gop: ${goal.contributionType}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Han: $deadlineLabel',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: colorScheme.primary.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$progressPercent% hoan thanh',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Icon(
                isCompleted ? Icons.check_circle : Icons.timelapse,
                size: 18,
                color: statusColor,
              ),
              const SizedBox(width: 6),
              Text(
                isCompleted ? 'Hoan thanh' : 'Dang tiet kiem',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key, this.initialGoal});

  final GoalData? initialGoal;

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _savedController = TextEditingController();
  DateTime _selectedDeadline = _today().add(const Duration(days: 30));
  String _contributionType = 'Hang thang';

  static const List<String> _contributionOptions = [
    'Hang ngay',
    'Hang tuan',
    'Hang thang',
    'Hang nam',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _savedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final initialGoal = widget.initialGoal;
    if (initialGoal != null) {
      _titleController.text = initialGoal.title;
      _amountController.text = initialGoal.targetAmount.toStringAsFixed(0);
      _savedController.text = initialGoal.savedAmount.toStringAsFixed(0);
      _selectedDeadline = DateTime(
        initialGoal.deadline.year,
        initialGoal.deadline.month,
        initialGoal.deadline.day,
      );
      _contributionType = initialGoal.contributionType;
    }
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickContributionType() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                'Chon chu ky dong gop',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (final option in _contributionOptions)
                ListTile(
                  title: Text(option),
                  trailing: option == _contributionType
                      ? Icon(Icons.check_circle, color: colorScheme.primary)
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
    final DateTime floorToday = _today();
    final DateTime effectiveInitialDate = _selectedDeadline.isBefore(floorToday)
        ? floorToday
        : _selectedDeadline;
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: floorToday,
      lastDate: DateTime(floorToday.year + 5),
    );
    if (newDate != null) {
      setState(
        () => _selectedDeadline = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
        ),
      );
    }
  }

  void _handleSubmit() {
    final String title = _titleController.text.trim();
    final String amount = _amountController.text.trim();
    final String saved = _savedController.text.trim();
    if (title.isEmpty || amount.isEmpty) {
      _showMessage('Vui long nhap day du cac truong bat buoc.');
      return;
    }
    final String cleanedAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    final double? parsedAmount = double.tryParse(cleanedAmount);
    if (parsedAmount == null || parsedAmount <= 0) {
      _showMessage('Hay nhap so tien hop le.');
      return;
    }
    final double parsedSaved =
        double.tryParse(
          saved.isEmpty ? '0' : saved.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0;
    if (parsedSaved < 0 || parsedSaved > parsedAmount) {
      _showMessage(
        'So tien da tiet kiem phai nam trong khoang tu 0 den muc tieu.',
      );
      return;
    }

    final DateTime today = _today();
    final DateTime normalizedDeadline = _selectedDeadline.isBefore(today)
        ? today
        : _selectedDeadline;

    Navigator.of(context).pop(
      GoalData(
        id:
            widget.initialGoal?.id ??
            'goal-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        savedAmount: parsedSaved,
        targetAmount: parsedAmount,
        deadline: normalizedDeadline,
        contributionType: _contributionType,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE11D48),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final outline = colorScheme.outlineVariant;
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Them muc tieu',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LabeledTextField(
              controller: _titleController,
              label: 'Ten muc tieu',
              hintText: 'Vi du: Mua xe',
              icon: Icons.edit_outlined,
            ),
            const SizedBox(height: 20),
            _LabeledTextField(
              controller: _amountController,
              label: 'So tien muc tieu',
              hintText: '0',
              icon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            _LabeledTextField(
              controller: _savedController,
              label: 'So tien da tiet kiem',
              hintText: '0',
              icon: Icons.savings_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Chu ky dong gop',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
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
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _contributionType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    Icon(Icons.expand_more, color: colorScheme.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Han hoan thanh',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
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
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormatter.format(_selectedDeadline),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: GradientButton(
                label: widget.initialGoal == null
                    ? 'THEM MUC TIEU'
                    : 'CAP NHAT MUC TIEU',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final outline = colorScheme.outlineVariant;
    final surfaceVariant = colorScheme.surfaceContainerHighest;
    final bool isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: isDark
                ? surfaceVariant.withOpacity(0.35)
                : surfaceVariant.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class GoalData {
  const GoalData({
    required this.id,
    required this.title,
    required this.savedAmount,
    required this.targetAmount,
    required this.deadline,
    required this.contributionType,
  });

  final String id;
  final String title;
  final double savedAmount;
  final double targetAmount;
  final DateTime deadline;
  final String contributionType;
}

enum _GoalMenuAction { edit, delete }
