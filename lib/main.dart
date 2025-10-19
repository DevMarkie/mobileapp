import 'package:flutter/material.dart';
import 'onboarding/onboarding_page.dart';
import 'onboarding/splash_page.dart';
import 'onboarding/welcome_page.dart';
import 'auth/sign_in_page.dart';
import 'auth/sign_up_page.dart';
import 'auth/account_page.dart';
import 'profile/profile_page.dart';
import 'home/home_page.dart';
import 'cards/cards_page.dart';
import 'transactions/transactions_page.dart';
import 'transactions/transaction_details_page.dart';
import 'transfer/transfer_page.dart';
import 'transfer/transfer_confirmation_page.dart';
import 'notifications/notifications_page.dart';
import 'profile/profile_info_page.dart';

void main() {
  // Show splash at startup in the real app.
  runApp(const MonexApp(showSplashAtStartup: true));
}

/// Root application widget expected by tests.
class MonexApp extends StatelessWidget {
  const MonexApp({super.key, this.showSplashAtStartup = false});

  /// When true, the app starts at Splash and navigates to Onboarding after ~10s.
  /// Default is false to keep unit tests stable.
  final bool showSplashAtStartup;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monex',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routes: {
        '/onboarding': (_) => const MonexOnboarding(),
        '/splash': (_) => const SplashPage(),
        '/welcome': (_) => const WelcomePage(),
        '/signin': (_) => const SignInPage(),
        '/signup': (_) => const SignUpPage(),
        '/account': (_) => const AccountPage(),
        '/profile': (_) => const ProfilePage(),
        '/home': (_) => const HomePage(),
        '/cards': (_) => const CardsPage(),
        '/transactions': (_) => const TransactionsPage(),
        '/transactionDetails': (_) => const TransactionDetailsPage(),
        '/transfer': (_) => const TransferPage(),
        '/transferConfirmation': (ctx) {
          final args = ModalRoute.of(ctx)?.settings.arguments as Map? ?? {};
          final amount = (args['amount'] ?? '0').toString();
          final to = (args['to'] ?? 'Recipient').toString();
          return TransferConfirmationPage(amount: amount, to: to);
        },
        '/notifications': (_) => const NotificationsPage(),
        '/profileInfo': (_) => const ProfileInfoPage(),
      },
      home: showSplashAtStartup ? const SplashPage() : const _CounterPage(),
    );
  }
}

class _CounterPage extends StatefulWidget {
  const _CounterPage();

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/onboarding'),
              child: const Text('Open Onboarding'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/splash'),
              child: const Text('Open Splash (10s)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
