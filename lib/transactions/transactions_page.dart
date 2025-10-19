import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

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

                // Total expenses text
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

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Search bar on a mid-blue rounded container (like screenshot)
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

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Transactions list
                SliverList(
                  delegate: SliverChildListDelegate([
                    const _TxnTile(
                      color: Color(0xFFFFC085),
                      title: 'Shopping',
                      subtitle: '17 Aug 2020, 9:12 AM',
                      amount: -300,
                    ),
                    const _TxnTile(
                      color: Color(0xFF6EE7F2),
                      title: 'Medicine',
                      subtitle: '5 May 2020, 4:12 PM',
                      amount: -120,
                    ),
                    const _TxnTile(
                      color: Color(0xFFFF9F7A),
                      title: 'Sport',
                      subtitle: '22 May 2020, 4:22 AM',
                      amount: -70,
                    ),
                    const _TxnTile(
                      color: Color(0xFFFFC085),
                      title: 'Travel',
                      subtitle: '19 June 2020, 3:00 AM',
                      amount: -800,
                    ),
                    const _TxnTile(
                      color: Color(0xFF6EE7F2),
                      title: 'Medicine',
                      subtitle: '14 Aug 2020, 8:00 AM',
                      amount: -160,
                    ),
                    const SizedBox(height: 40),
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
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/transactionDetails'),
      child: Padding(
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
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
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
      ),
    );
  }
}
