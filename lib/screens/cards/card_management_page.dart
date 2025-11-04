import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/gradient_button.dart';

class CardManagementPage extends StatefulWidget {
  const CardManagementPage({super.key});

  @override
  State<CardManagementPage> createState() => _CardManagementPageState();
}

class _CardManagementPageState extends State<CardManagementPage> {
  final List<_CardModel> _cards = [
    _CardModel(
      id: 'card-1',
      holderName: 'Nguyễn Văn A',
      number: '4726750019283645',
      expiry: '12/26',
      issuer: 'Sacombank',
      colorIndex: 0,
      isPrimary: true,
      balance: 10000000,
      type: CardType.debit,
    ),
  ];

  late int _nextColorIndex;
  bool _hideSensitive = false;

  static const List<List<Color>> _palettes = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFF2563EB), Color(0xFF0EA5E9)],
    [Color(0xFFFB7185), Color(0xFFF59E0B)],
    [Color(0xFF10B981), Color(0xFF14B8A6)],
    [Color(0xFF9333EA), Color(0xFFEC4899)],
  ];

  @override
  void initState() {
    super.initState();
    _nextColorIndex = _cards.length;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final decimalFormat = NumberFormat.decimalPattern(locale.toString());
    final bool isVietnamese = locale.languageCode == 'vi';
    String formatAmount(double value) {
      final formatted = decimalFormat.format(value);
      return isVietnamese ? '$formatted đ' : '$formatted ₫';
    }

    final totalBalance = _cards.fold<double>(
      0,
      (previousValue, card) => previousValue + card.balance,
    );
    final creditCards = _cards
        .where((card) => card.type == CardType.credit)
        .toList();
    final creditLimit = creditCards.fold<double>(
      0,
      (previousValue, card) => previousValue + card.balance,
    );
    final creditCount = creditCards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.cardsTitle),
        actions: [
          IconButton(
            tooltip: _hideSensitive
                ? localizations.cardsSensitiveShow
                : localizations.cardsSensitiveHide,
            icon: Icon(
              _hideSensitive
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () {
              setState(() {
                _hideSensitive = !_hideSensitive;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.cardsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      title: localizations.cardsSummaryBalanceTitle,
                      value: _hideSensitive
                          ? '****'
                          : formatAmount(totalBalance),
                      subtitle: localizations.cardsSummaryBalanceCount(
                        _cards.length,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryTile(
                      title: localizations.cardsSummaryCreditTitle,
                      value: _hideSensitive
                          ? '****'
                          : formatAmount(creditLimit),
                      subtitle: localizations.cardsSummaryCreditCount(
                        creditCount,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (_cards.isEmpty)
                _buildEmptyState(context, localizations)
              else
                Column(
                  children: [
                    for (final entry in _cards.asMap().entries) ...[
                      _buildCardTile(
                        context,
                        index: entry.key,
                        card: entry.value,
                        localizations: localizations,
                        formatAmount: formatAmount,
                        hideSensitive: _hideSensitive,
                      ),
                      if (entry.key != _cards.length - 1)
                        const SizedBox(height: 24),
                    ],
                  ],
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: GradientButton(
                  label: localizations.cardsAddButton,
                  onTap: () => _showCardForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.cardsEmptyState,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTile(
    BuildContext context, {
    required int index,
    required _CardModel card,
    required AppLocalizations localizations,
    required String Function(double) formatAmount,
    required bool hideSensitive,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final palette = _palettes[card.colorIndex % _palettes.length];
    final cardGradient = LinearGradient(
      colors: palette,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final typeLabel = _localizedType(card.type, localizations);
    final balanceLabel = hideSensitive ? '****' : formatAmount(card.balance);
    final numberLabel = hideSensitive
        ? '**** **** **** ****'
        : _formatNumber(card.number);

    return Container(
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.last.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 18),
            spreadRadius: -12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.issuer,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () => _showCardForm(existing: card, index: index),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            typeLabel,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            balanceLabel,
            style: textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localizations.cardsBalanceLabel,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  numberLabel,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (card.isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    localizations.cardsPrimaryBadge,
                    style: textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            card.holderName,
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  card.issuer,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
              Text(
                card.expiry,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: card.isPrimary
                    ? null
                    : () => _setPrimary(index, localizations),
                icon: Icon(card.isPrimary ? Icons.star : Icons.star_border),
                label: Text(
                  card.isPrimary
                      ? localizations.cardsPrimaryBadge
                      : localizations.cardsMakePrimary,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.white,
                    tooltip: localizations.cardsDelete,
                    onPressed: () => _confirmRemoveCard(index),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showCardForm({_CardModel? existing, int? index}) async {
    final localizations = AppLocalizations.of(context);
    final draft = await showModalBottomSheet<_CardDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => _CardFormSheet(
        localizations: localizations,
        initial: existing,
        defaultPrimary: _cards.isEmpty,
        formatNumber: _formatNumber,
        sanitizeNumber: _sanitizeNumber,
      ),
    );

    if (draft == null) return;

    if (existing != null && index != null) {
      final bool wasPrimary = existing.isPrimary;
      setState(() {
        _cards[index] = existing.copyWith(
          holderName: draft.holderName,
          number: draft.number,
          expiry: draft.expiry,
          issuer: draft.issuer,
          balance: draft.balance,
          type: draft.type,
        );
      });

      if (draft.isPrimary) {
        _setPrimary(index, localizations, showSnackbar: false);
      } else if (wasPrimary) {
        final hasOtherPrimary = _cards.asMap().entries.any(
          (entry) => entry.key != index && entry.value.isPrimary,
        );
        if (hasOtherPrimary) {
          setState(() {
            _cards[index] = _cards[index].copyWith(isPrimary: false);
          });
        } else {
          _setPrimary(index, localizations, showSnackbar: false);
        }
      }

      _showSnack(localizations.cardsUpdatedMessage);
      return;
    }

    final colorIndex = _nextColorIndex % _palettes.length;
    _nextColorIndex++;
    final bool shouldBePrimary = draft.isPrimary || _cards.isEmpty;

    setState(() {
      if (shouldBePrimary) {
        for (var i = 0; i < _cards.length; i++) {
          _cards[i] = _cards[i].copyWith(isPrimary: false);
        }
      }
      _cards.add(
        _CardModel(
          id: 'card-${DateTime.now().millisecondsSinceEpoch}',
          holderName: draft.holderName,
          number: draft.number,
          expiry: draft.expiry,
          issuer: draft.issuer,
          colorIndex: colorIndex,
          balance: draft.balance,
          type: draft.type,
          isPrimary: shouldBePrimary,
        ),
      );
    });

    _showSnack(localizations.cardsAddedMessage);
  }

  Future<void> _confirmRemoveCard(int index) async {
    final localizations = AppLocalizations.of(context);
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(localizations.cardsDeleteConfirmTitle),
              content: Text(localizations.cardsDeleteConfirmMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(localizations.commonCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(localizations.cardsDelete),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    setState(() {
      _cards.removeAt(index);
      if (_cards.isNotEmpty && !_cards.any((card) => card.isPrimary)) {
        _cards[0] = _cards[0].copyWith(isPrimary: true);
      }
    });

    _showSnack(localizations.cardsRemovedMessage);
  }

  void _setPrimary(
    int index,
    AppLocalizations localizations, {
    bool showSnackbar = true,
  }) {
    setState(() {
      for (var i = 0; i < _cards.length; i++) {
        final card = _cards[i];
        _cards[i] = card.copyWith(isPrimary: i == index);
      }
    });

    if (showSnackbar) {
      _showSnack(localizations.cardsUpdatedMessage);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _localizedType(CardType type, AppLocalizations localizations) {
    return switch (type) {
      CardType.debit => localizations.cardsTypeDebit,
      CardType.credit => localizations.cardsTypeCredit,
    };
  }

  String _formatNumber(String input) {
    final digits = _sanitizeNumber(input);
    if (digits.isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String _sanitizeNumber(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    return digitsOnly;
  }
}

enum CardType { debit, credit }

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardModel {
  const _CardModel({
    required this.id,
    required this.holderName,
    required this.number,
    required this.expiry,
    required this.issuer,
    required this.colorIndex,
    required this.balance,
    required this.type,
    this.isPrimary = false,
  });

  final String id;
  final String holderName;
  final String number;
  final String expiry;
  final String issuer;
  final int colorIndex;
  final double balance;
  final CardType type;
  final bool isPrimary;

  _CardModel copyWith({
    String? holderName,
    String? number,
    String? expiry,
    String? issuer,
    int? colorIndex,
    double? balance,
    CardType? type,
    bool? isPrimary,
  }) {
    return _CardModel(
      id: id,
      holderName: holderName ?? this.holderName,
      number: number ?? this.number,
      expiry: expiry ?? this.expiry,
      issuer: issuer ?? this.issuer,
      colorIndex: colorIndex ?? this.colorIndex,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}

class _CardDraft {
  const _CardDraft({
    required this.holderName,
    required this.number,
    required this.expiry,
    required this.issuer,
    required this.balance,
    required this.type,
    required this.isPrimary,
  });

  final String holderName;
  final String number;
  final String expiry;
  final String issuer;
  final double balance;
  final CardType type;
  final bool isPrimary;
}

const List<String> _bankIssuerOptions = [
  'Vietcombank',
  'VietinBank',
  'BIDV',
  'Agribank',
  'Techcombank',
  'MB Bank',
  'ACB',
  'VPBank',
  'Sacombank',
  'HDBank',
  'SHB',
  'TPBank',
  'VIB',
  'MSB',
  'OCB',
  'Eximbank',
  'SeABank',
];

const String _otherIssuerValue = '__other__';

class _CardFormSheet extends StatefulWidget {
  const _CardFormSheet({
    required this.localizations,
    required this.defaultPrimary,
    required this.formatNumber,
    required this.sanitizeNumber,
    this.initial,
  });

  final AppLocalizations localizations;
  final bool defaultPrimary;
  final _CardModel? initial;
  final String Function(String) formatNumber;
  final String Function(String) sanitizeNumber;

  @override
  State<_CardFormSheet> createState() => _CardFormSheetState();
}

class _CardFormSheetState extends State<_CardFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;
  late final TextEditingController _expiryController;
  late final TextEditingController _issuerController;
  late final TextEditingController _balanceController;
  late CardType _selectedType;
  String? _selectedIssuer;
  late bool _makePrimary;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.holderName);
    _numberController = TextEditingController(
      text: widget.initial != null
          ? widget.formatNumber(widget.initial!.number)
          : '',
    );
    _expiryController = TextEditingController(text: widget.initial?.expiry);
    _issuerController = TextEditingController();
    _balanceController = TextEditingController(
      text: widget.initial != null
          ? widget.initial!.balance.toStringAsFixed(0)
          : '',
    );
    _selectedType = widget.initial?.type ?? CardType.debit;
    final initialIssuer = widget.initial?.issuer.trim();
    if (initialIssuer != null && initialIssuer.isNotEmpty) {
      if (_bankIssuerOptions.contains(initialIssuer)) {
        _selectedIssuer = initialIssuer;
      } else {
        _selectedIssuer = _otherIssuerValue;
        _issuerController.text = initialIssuer;
      }
    } else {
      _selectedIssuer = null;
    }
    _makePrimary = widget.initial?.isPrimary ?? widget.defaultPrimary;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _issuerController.dispose();
    _balanceController.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initial == null
                  ? localizations.cardsAddButton
                  : localizations.cardsEdit,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: localizations.cardsFormNameLabel,
                hintText: localizations.cardsFormNameHint,
              ),
              style: theme.textTheme.bodyLarge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return localizations.cardsFormValidationRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.cardsFormNumberLabel,
                hintText: localizations.cardsFormNumberHint,
              ),
              style: theme.textTheme.bodyLarge,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              ],
              validator: (value) {
                final sanitized = widget.sanitizeNumber(value ?? '');
                if (sanitized.isEmpty) {
                  return localizations.cardsFormValidationRequired;
                }
                if (sanitized.length < 12) {
                  return localizations.cardsFormNumberInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expiryController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: localizations.cardsFormExpiryLabel,
                hintText: localizations.cardsFormExpiryHint,
              ),
              style: theme.textTheme.bodyLarge,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              ],
              validator: (value) {
                final raw = value?.trim() ?? '';
                if (raw.isEmpty) {
                  return localizations.cardsFormValidationRequired;
                }
                final isValid = RegExp(
                  r'^(0[1-9]|1[0-2])\/\d{2}$',
                ).hasMatch(raw);
                if (!isValid) {
                  return localizations.cardsFormExpiryInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedIssuer,
              decoration: InputDecoration(
                labelText: localizations.cardsFormIssuerLabel,
              ),
              hint: Text(localizations.cardsFormIssuerHint),
              items: [
                ..._bankIssuerOptions.map(
                  (bank) =>
                      DropdownMenuItem<String>(value: bank, child: Text(bank)),
                ),
                DropdownMenuItem<String>(
                  value: _otherIssuerValue,
                  child: Text(localizations.cardsFormIssuerOtherOption),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIssuer = value;
                  if (value != _otherIssuerValue) {
                    _issuerController.clear();
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.cardsFormValidationRequired;
                }
                if (value == _otherIssuerValue &&
                    _issuerController.text.trim().isEmpty) {
                  return localizations.cardsFormValidationRequired;
                }
                return null;
              },
            ),
            if (_selectedIssuer == _otherIssuerValue) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _issuerController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: localizations.cardsFormIssuerOtherLabel,
                  hintText: localizations.cardsFormIssuerHint,
                ),
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (_selectedIssuer != _otherIssuerValue) {
                    return null;
                  }
                  if (value == null || value.trim().isEmpty) {
                    return localizations.cardsFormValidationRequired;
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<CardType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: localizations.cardsFormTypeLabel,
              ),
              items: CardType.values
                  .map(
                    (type) => DropdownMenuItem<CardType>(
                      value: type,
                      child: Text(_labelForType(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.cardsFormBalanceLabel,
                hintText: localizations.cardsFormBalanceHint,
              ),
              style: theme.textTheme.bodyLarge,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final digitsOnly = value?.replaceAll(RegExp(r'[^0-9]'), '');
                if (digitsOnly == null || digitsOnly.isEmpty) {
                  return localizations.cardsFormBalanceInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(localizations.cardsFormPrimaryToggle),
              value: _makePrimary,
              onChanged: (value) {
                setState(() => _makePrimary = value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(localizations.commonCancel),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _submit,
                  child: Text(localizations.cardsFormSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final sanitizedNumber = widget.sanitizeNumber(_numberController.text);
    final expiry = _expiryController.text.trim();
    final balanceDigits = _balanceController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final balance = double.parse(balanceDigits);
    final selectedIssuer = _selectedIssuer;
    if (selectedIssuer == null) {
      return;
    }
    final issuer = selectedIssuer == _otherIssuerValue
        ? _issuerController.text.trim()
        : selectedIssuer;
    Navigator.of(context).pop(
      _CardDraft(
        holderName: _nameController.text.trim(),
        number: sanitizedNumber,
        expiry: expiry,
        issuer: issuer,
        balance: balance,
        type: _selectedType,
        isPrimary: _makePrimary,
      ),
    );
  }

  String _labelForType(CardType type) {
    final localizations = widget.localizations;
    return switch (type) {
      CardType.debit => localizations.cardsTypeDebit,
      CardType.credit => localizations.cardsTypeCredit,
    };
  }
}
