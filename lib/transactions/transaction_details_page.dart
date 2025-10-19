import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient header
            Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4960F9), Color(0xFF1433FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 6),
                        Text(
                          'Your total expenses',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$2500',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Track your expenses pill grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildListDelegate(const [
                      _Pill(
                        label: 'Travel',
                        amount: 900,
                        color: Color(0xFFFF9F7A),
                      ),
                      _Pill(
                        label: 'Shopping',
                        amount: 525,
                        color: Color(0xFFFFC085),
                      ),
                      _Pill(
                        label: 'Medicine',
                        amount: 280,
                        color: Color(0xFF6EE7F2),
                      ),
                      _Pill(
                        label: 'Sport',
                        amount: 70,
                        color: Color(0xFFB0E0FF),
                      ),
                      _Pill(
                        label: 'Credit card\nrepayment',
                        amount: 0,
                        color: Color(0xFF6A8BFF),
                        showArrow: true,
                      ),
                    ]),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.4,
                        ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Search bar and list similar to first page
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C4DF6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: Colors.white70),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate(const [
                    SizedBox(height: 12),
                    _TxnTile(
                      color: Color(0xFFFFC085),
                      title: 'Shopping',
                      subtitle: '17 Aug 2020, 9:12 AM',
                      amount: -300,
                    ),
                    _TxnTile(
                      color: Color(0xFF6EE7F2),
                      title: 'Medicine',
                      subtitle: '5 May 2020, 4:12 PM',
                      amount: -120,
                    ),
                    _TxnTile(
                      color: Color(0xFFFF9F7A),
                      title: 'Sport',
                      subtitle: '22 May 2020, 4:22 AM',
                      amount: -70,
                    ),
                    SizedBox(height: 40),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.amount,
    required this.color,
    this.showArrow = false,
  });
  final String label;
  final double amount;
  final Color color;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (amount > 0)
                  Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
    if (showArrow) {
      return InkWell(
        onTap: () => Navigator.of(context).pushNamed('/transfer'),
        child: content,
      );
    }
    return content;
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final Color color;
  final String title;
  final String subtitle;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount >= 0
                ? '+\$${amount.toStringAsFixed(0)}'
                : '-\$${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: amount >= 0 ? Colors.green : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }
}
