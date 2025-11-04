import 'package:cloud_functions/cloud_functions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final String _username = const String.fromEnvironment(
    'SMTP_USERNAME',
    defaultValue: '',
  );
  static final String _password = const String.fromEnvironment(
    'SMTP_PASSWORD',
    defaultValue: '',
  );
  static final String _host = const String.fromEnvironment(
    'SMTP_HOST',
    defaultValue: 'smtp.gmail.com',
  );
  static final int _port =
      int.tryParse(
        const String.fromEnvironment('SMTP_PORT', defaultValue: '587'),
      ) ??
      587;
  static final bool _useSsl =
      const String.fromEnvironment(
        'SMTP_SSL',
        defaultValue: 'false',
      ).toLowerCase() ==
      'true';
  static final String _fromEmail = const String.fromEnvironment(
    'SMTP_FROM_EMAIL',
    defaultValue: '',
  );
  static final String _fromName = const String.fromEnvironment(
    'SMTP_FROM_NAME',
    defaultValue: 'Monex Support',
  );
  static final String _firebaseFunctionName = const String.fromEnvironment(
    'FIREBASE_SEND_CODE_FUNCTION',
    defaultValue: 'sendResetCode',
  );
  static final String _firebaseFunctionRegion = const String.fromEnvironment(
    'FIREBASE_FUNCTION_REGION',
    defaultValue: '',
  );

  static bool get isConfigured =>
      _username.isNotEmpty && _password.isNotEmpty && _host.isNotEmpty;

  static String get _effectiveFromEmail =>
      _fromEmail.isNotEmpty ? _fromEmail : _username;

  static Future<void> sendVerificationCode(
    String recipientEmail,
    String code,
  ) async {
    if (isConfigured) {
      await _sendViaSmtp(recipientEmail, code);
      return;
    }

    await _sendViaFirebaseFunction(recipientEmail, code);
  }

  static Future<void> _sendViaSmtp(String recipientEmail, String code) async {
    final smtpServer = SmtpServer(
      _host,
      port: _port,
      ssl: _useSsl,
      username: _username,
      password: _password,
    );

    final message = Message()
      ..from = Address(_effectiveFromEmail, _fromName)
      ..recipients.add(recipientEmail)
      ..subject = 'Password Reset Code'
      ..text = 'Your verification code is $code. This code will expire soon.'
      ..html =
          '<p>Your verification code is <strong>$code</strong>.</p>'
          '<p>If you did not request this, please ignore this email.</p>';

    try {
      await send(message, smtpServer);
    } on MailerException catch (error) {
      final firstProblem = error.problems.isNotEmpty
          ? error.problems.first.code
          : error.message;
      throw Exception('Failed to send verification email: $firstProblem');
    }
  }

  static Future<void> _sendViaFirebaseFunction(
    String recipientEmail,
    String code,
  ) async {
    if (_firebaseFunctionName.isEmpty) {
      throw StateError(
        'No SMTP credentials or Firebase function configured. Set FIREBASE_SEND_CODE_FUNCTION or SMTP credentials.',
      );
    }

    try {
      final functions = _firebaseFunctionRegion.isNotEmpty
          ? FirebaseFunctions.instanceFor(region: _firebaseFunctionRegion)
          : FirebaseFunctions.instance;
      final callable = functions.httpsCallable(_firebaseFunctionName);
      await callable.call(<String, dynamic>{
        'email': recipientEmail,
        'code': code,
      });
    } on FirebaseFunctionsException catch (error) {
      final message = error.message ?? 'Unknown error';
      throw StateError('Firebase function ${error.code}: $message');
    } catch (error) {
      throw StateError('Failed to call Firebase function: $error');
    }
  }
}
