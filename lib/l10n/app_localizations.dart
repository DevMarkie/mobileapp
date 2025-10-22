import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_strings.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('vi')];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      AppStrings.appTitle: 'Monex',
      AppStrings.commonOk: 'OK',
      AppStrings.commonCancel: 'Cancel',
      AppStrings.commonClose: 'Close',
      AppStrings.commonRetry: 'Retry',

      AppStrings.counterTitle: 'Counter',
      AppStrings.counterOpenOnboarding: 'Open Onboarding',
      AppStrings.counterOpenSplash: 'Open Splash (10s)',

      AppStrings.drawerPayments: 'Payments',
      AppStrings.drawerNotifications: 'Notifications',
      AppStrings.drawerTransactions: 'Transactions',
      AppStrings.drawerMyCards: 'My Cards',
      AppStrings.drawerPromotions: 'Promotions',
      AppStrings.drawerSavings: 'Savings',
      AppStrings.drawerProfileInfo: 'Profile Info',
      AppStrings.drawerSettings: 'Settings',
      AppStrings.drawerSignOut: 'Sign out',

      AppStrings.authEmailLabel: 'Email address',
      AppStrings.authEmailHint: 'abc@gmail.com',
      AppStrings.authPasswordLabel: 'Password',
      AppStrings.authPasswordHint: '********',
      AppStrings.authForgotPassword: 'Forgot Password?',

      AppStrings.signInWelcome: 'WELCOME\nBACK',
      AppStrings.signInTitle: 'SIGN-IN',
      AppStrings.signInButton: 'Sign In',
      AppStrings.signInLoading: 'Signing in...',
      AppStrings.signInErrorInvalidEmail: 'The email address is incomplete.',
      AppStrings.signInErrorUnableProfile:
          'Unable to check profile, continue to profile: {error}',
      AppStrings.signInErrorFailed: 'Sign in failed: {error}',
      AppStrings.signInErrorFailedWithMessage: 'Sign in failed: {message}',

      AppStrings.signUpTitle: 'Create your Account',
      AppStrings.signUpSubtitle:
          'Create a Monex account to manage your finance',
      AppStrings.signUpButton: 'Sign Up',
      AppStrings.signUpHaveAccount: 'Have an account?',
      AppStrings.signUpSwitchToSignIn: 'Sign In',
      AppStrings.signUpError: 'Sign up failed: {error}',
      AppStrings.signUpPasswordConfirm: 'Confirm password',
      AppStrings.signUpPasswordConfirmHint: 'Re-enter your password',
      AppStrings.signUpPasswordError: 'Password must be 6+ chars and match.',
      AppStrings.signUpLoading: 'Creating account...',

      AppStrings.accountTitle: 'Set up your account',
      AppStrings.accountDescription:
          'Turn on notifications to not miss an update.',
      AppStrings.accountContinue: 'Continue',
      AppStrings.accountSkip: 'Skip for now',
      AppStrings.accountSignedIn: 'Signed in',
      AppStrings.accountAppBar: 'Account',

      AppStrings.profileHeaderTitle: 'Complete your profile',
      AppStrings.profileHeaderSubtitle: 'Just some info, no photo needed',
      AppStrings.profileUsernameLabel: 'Username',
      AppStrings.profileUsernameHint: 'Your username',
      AppStrings.profileFirstNameLabel: 'First Name',
      AppStrings.profileFirstNameHint: 'Your name',
      AppStrings.profileLastNameLabel: 'Last Name',
      AppStrings.profileLastNameHint: 'Your last name',
      AppStrings.profileDobLabel: 'Date of Birth',
      AppStrings.profileDobHint: 'Your Birthday(dd-mm-yyyy)',
      AppStrings.profileCompleteButton: 'Complete',
      AppStrings.profileSaved: 'Profile saved',
      AppStrings.profileSaveLocalFallback: 'Saved locally (offline): {error}',
      AppStrings.profileSaveFailed: 'Save failed: {error}',

      AppStrings.profileInfoTitle: 'Profile',
      AppStrings.profileInfoSubtitle: 'Manage your personal information',
      AppStrings.profileInfoEmail: 'Email',
      AppStrings.profileInfoPhone: 'Phone',
      AppStrings.profileInfoBirthday: 'Birthday',
      AppStrings.profileInfoAddress: 'Address',
      AppStrings.profileInfoStatusOnline: 'online',
      AppStrings.profileInfoPlaceholderUser: 'User',
      AppStrings.profileInfoEditProfile: 'Edit profile',

      AppStrings.onboardingSlide1Title: 'Save your money\nconveniently.',
      AppStrings.onboardingSlide1Subtitle:
          'Get 5% cashback on every\ntransactions and spend it easily.',
      AppStrings.onboardingSlide2Title:
          'Secure your money for\nfree and get rewards.',
      AppStrings.onboardingSlide2Subtitle:
          'Get the most secure payment\never app and enjoy it.',
      AppStrings.onboardingSlide3Title:
          'Enjoy Commission free\nand start trading.',
      AppStrings.onboardingSlide3Subtitle:
          'Online investing has never been\neasier then it is right now.',
      AppStrings.onboardingNext: 'Next',
      AppStrings.onboardingGetStarted: 'Get Started',

      AppStrings.splashLoading: 'Loading...',
      AppStrings.splashTagline: 'MONEY',

      AppStrings.welcomeTitle: 'Welcome to Monex',
      AppStrings.welcomeSubtitle:
          'Manage your finance and investments in one place.',
      AppStrings.welcomeSignIn: 'Sign In',
      AppStrings.welcomeSignUp: 'Sign Up',
      AppStrings.welcomeHeader: 'WELCOME\nBACK',

      AppStrings.notificationsTitle: 'Notifications',
      AppStrings.notificationsEmpty: 'You have no notifications yet.',
      AppStrings.notificationsIntro: 'You can check your\nnotifications here.',
      AppStrings.notificationsSearch: 'Search',
      AppStrings.notificationsActionSentYou: 'sent you',

      AppStrings.cardsTitle: 'My Cards',
      AppStrings.cardsBalance: 'Balance',
      AppStrings.cardsCardNumber: 'Card Number',
      AppStrings.cardsExpDate: 'Exp. Date',
      AppStrings.cardsActive: 'Active',
      AppStrings.cardsFreeze: 'Freeze',
      AppStrings.cardsAddNew: 'Add new card',
      AppStrings.cardsPageTitle: 'Cards',
      AppStrings.cardsIntro: 'You can check\nYour cards here',
      AppStrings.cardsLabelCompany: 'Company',
      AppStrings.cardsLabelHome: 'Home',
      AppStrings.cardsTxnShopping: 'Shopping',
      AppStrings.cardsTxnMedicine: 'Medicine',
      AppStrings.cardsTxnSport: 'Sport',

      AppStrings.homeGreeting: 'Hello, {name}',
      AppStrings.homeGreetingMorning: 'Good Morning',
      AppStrings.homeGreetingAfternoon: 'Good Afternoon',
      AppStrings.homeGreetingEvening: 'Good Evening',
      AppStrings.homeGreetingFallback: 'there',
      AppStrings.homeBalance: 'Available Balance',
      AppStrings.homeTotalBalance: 'Your total balance',
      AppStrings.homeSend: 'Send',
      AppStrings.homeRequest: 'Request',
      AppStrings.homeBills: 'Bills',
      AppStrings.homePromoHeader: 'Latest Promotions',
      AppStrings.homeViewAll: 'View all',
      AppStrings.homeRecentTransactions: 'Recent Transactions',
      AppStrings.homeCheckAccounts: 'Check your bank\naccounts',
      AppStrings.homeMyCardsTabSelected: 'My Cards tab selected',

      AppStrings.transactionsTitle: 'Transactions',
      AppStrings.transactionsSearchHint: 'Search transactions',
      AppStrings.transactionsFilterAll: 'All',
      AppStrings.transactionsFilterIncome: 'Income',
      AppStrings.transactionsFilterExpense: 'Expense',
      AppStrings.transactionsEmpty: 'No transactions available.',
      AppStrings.transactionsTotalExpenses: 'Your total expenses',
      AppStrings.transactionsTxnTravel: 'Travel',

      AppStrings.transactionDetailsTitle: 'Transaction Details',
      AppStrings.transactionDetailsAmount: 'Amount',
      AppStrings.transactionDetailsDate: 'Date',
      AppStrings.transactionDetailsTo: 'To',
      AppStrings.transactionDetailsNotes: 'Notes',
      AppStrings.transactionDetailsCreditRepayment: 'Credit card\nrepayment',

      AppStrings.transferTitle: 'Transfer',
      AppStrings.transferAmountLabel: 'Amount',
      AppStrings.transferAmountHint: 'Enter amount',
      AppStrings.transferRecipientLabel: 'Recipient',
      AppStrings.transferRecipientHint: 'Who are you sending to?',
      AppStrings.transferNoteLabel: 'Note (optional)',
      AppStrings.transferNoteHint: 'Add a short note',
      AppStrings.transferContinue: 'Continue',
      AppStrings.transferConfirmTitle: 'Confirm Transfer',
      AppStrings.transferConfirmAmountLabel: 'Amount',
      AppStrings.transferConfirmRecipientLabel: 'Recipient',
      AppStrings.transferConfirmNoteLabel: 'Note',
      AppStrings.transferConfirmButton: 'Confirm',
      AppStrings.transferDoneTitle: 'Transfer submitted!',
      AppStrings.transferDoneDescription:
          'Your transfer is on the way. You can track it in recent activities.',
      AppStrings.transferDoneButton: 'Back to Home',
      AppStrings.transferDefaultRecipient: 'Recipient',
      AppStrings.transferConfirmationTitle: 'Transaction',
      AppStrings.transferConfirmationMessagePrefix:
          'You have successfully sent ',
      AppStrings.transferConfirmationMessageTo: 'to ',
      AppStrings.transferConfirmationExecuteAgain: 'Execute Again',
      AppStrings.transferConfirmationViewDetails: 'Confirmation',

      AppStrings.errorGeneric: 'Something went wrong: {error}',

      AppStrings.settingsTitle: 'Settings',
      AppStrings.settingsLanguageSection: 'Language',
      AppStrings.settingsLanguageEnglish: 'English',
      AppStrings.settingsLanguageVietnamese: 'Vietnamese',
      AppStrings.settingsLanguageApplied: 'Language updated',
    },
    'vi': {
      AppStrings.appTitle: 'Monex',
      AppStrings.commonOk: 'Đồng ý',
      AppStrings.commonCancel: 'Hủy',
      AppStrings.commonClose: 'Đóng',
      AppStrings.commonRetry: 'Thử lại',

      AppStrings.counterTitle: 'Bộ đếm',
      AppStrings.counterOpenOnboarding: 'Mở phần giới thiệu',
      AppStrings.counterOpenSplash: 'Mở màn hình Splash (10s)',

      AppStrings.drawerPayments: 'Thanh toán',
      AppStrings.drawerNotifications: 'Thông báo',
      AppStrings.drawerTransactions: 'Giao dịch',
      AppStrings.drawerMyCards: 'Thẻ của tôi',
      AppStrings.drawerPromotions: 'Khuyến mãi',
      AppStrings.drawerSavings: 'Tiết kiệm',
      AppStrings.drawerProfileInfo: 'Thông tin hồ sơ',
      AppStrings.drawerSettings: 'Cài đặt',
      AppStrings.drawerSignOut: 'Đăng xuất',

      AppStrings.authEmailLabel: 'Địa chỉ email',
      AppStrings.authEmailHint: '.....@gmail.com',
      AppStrings.authPasswordLabel: 'Mật khẩu',
      AppStrings.authPasswordHint: '********',
      AppStrings.authForgotPassword: 'Quên mật khẩu?',

      AppStrings.signInWelcome: 'CHÀO MỪNG\nTRỞ LẠI',
      AppStrings.signInTitle: 'ĐĂNG NHẬP',
      AppStrings.signInButton: 'Đăng nhập',
      AppStrings.signInLoading: 'Đang đăng nhập...',
      AppStrings.signInErrorInvalidEmail: 'Địa chỉ email chưa hợp lệ.',
      AppStrings.signInErrorUnableProfile:
          'Không thể kiểm tra hồ sơ, tiếp tục tới hồ sơ: {error}',
      AppStrings.signInErrorFailed: 'Đăng nhập thất bại: {error}',
      AppStrings.signInErrorFailedWithMessage: 'Đăng nhập thất bại: {message}',

      AppStrings.signUpTitle: 'Tạo tài khoản của bạn',
      AppStrings.signUpSubtitle: 'Tạo tài khoản Monex để quản lý tài chính',
      AppStrings.signUpButton: 'Đăng ký',
      AppStrings.signUpHaveAccount: 'Đã có tài khoản?',
      AppStrings.signUpSwitchToSignIn: 'Đăng nhập',
      AppStrings.signUpError: 'Đăng ký thất bại: {error}',
      AppStrings.signUpPasswordConfirm: 'Xác nhận mật khẩu',
      AppStrings.signUpPasswordConfirmHint: 'Nhập lại mật khẩu',
      AppStrings.signUpPasswordError:
          'Mật khẩu phải có từ 6 ký tự và trùng nhau.',
      AppStrings.signUpLoading: 'Đang tạo tài khoản...',

      AppStrings.accountTitle: 'Thiết lập tài khoản của bạn',
      AppStrings.accountDescription: 'Bật thông báo để không bỏ lỡ cập nhật.',
      AppStrings.accountContinue: 'Tiếp tục',
      AppStrings.accountSkip: 'Để sau',
      AppStrings.accountSignedIn: 'Đã đăng nhập',
      AppStrings.accountAppBar: 'Tài khoản',

      AppStrings.profileHeaderTitle: 'Hoàn tất hồ sơ của bạn',
      AppStrings.profileHeaderSubtitle: 'Chỉ cần vài thông tin, không cần ảnh',
      AppStrings.profileUsernameLabel: 'Tên người dùng',
      AppStrings.profileUsernameHint: 'Tên người dùng của bạn',
      AppStrings.profileFirstNameLabel: 'Tên',
      AppStrings.profileFirstNameHint: 'Tên của bạn',
      AppStrings.profileLastNameLabel: 'Họ',
      AppStrings.profileLastNameHint: 'Họ của bạn',
      AppStrings.profileDobLabel: 'Ngày sinh',
      AppStrings.profileDobHint: 'Sinh nhật của bạn (dd-mm-yyyy)',
      AppStrings.profileCompleteButton: 'Hoàn tất',
      AppStrings.profileSaved: 'Đã lưu hồ sơ',
      AppStrings.profileSaveLocalFallback:
          'Đã lưu cục bộ (ngoại tuyến): {error}',
      AppStrings.profileSaveFailed: 'Lưu thất bại: {error}',

      AppStrings.profileInfoTitle: 'Hồ sơ',
      AppStrings.profileInfoSubtitle: 'Quản lý thông tin cá nhân của bạn',
      AppStrings.profileInfoEmail: 'Email',
      AppStrings.profileInfoPhone: 'Số điện thoại',
      AppStrings.profileInfoBirthday: 'Ngày sinh',
      AppStrings.profileInfoAddress: 'Địa chỉ',
      AppStrings.profileInfoStatusOnline: 'đang trực tuyến',
      AppStrings.profileInfoPlaceholderUser: 'Người dùng',
      AppStrings.profileInfoEditProfile: 'Chỉnh sửa hồ sơ',

      AppStrings.onboardingSlide1Title: 'Tiết kiệm tiền thuận tiện.',
      AppStrings.onboardingSlide1Subtitle:
          'Hoàn tiền 5% cho mỗi giao dịch và chi tiêu dễ dàng.',
      AppStrings.onboardingSlide2Title:
          'Bảo vệ tiền của bạn miễn phí và nhận thưởng.',
      AppStrings.onboardingSlide2Subtitle:
          'Ứng dụng thanh toán an toàn nhất, hãy trải nghiệm.',
      AppStrings.onboardingSlide3Title:
          'Giao dịch không phí hoa hồng và bắt đầu đầu tư.',
      AppStrings.onboardingSlide3Subtitle:
          'Đầu tư trực tuyến chưa bao giờ dễ dàng như bây giờ.',
      AppStrings.onboardingNext: 'Tiếp theo',
      AppStrings.onboardingGetStarted: 'Bắt đầu',

      AppStrings.splashLoading: 'Đang tải...',
      AppStrings.splashTagline: 'TIỀN TỆ',

      AppStrings.welcomeTitle: 'Chào mừng đến Monex',
      AppStrings.welcomeSubtitle:
          'Quản lý tài chính và đầu tư của bạn tại một nơi.',
      AppStrings.welcomeSignIn: 'Đăng nhập',
      AppStrings.welcomeSignUp: 'Đăng ký',
      AppStrings.welcomeHeader: 'CHÀO MỪNG\nTRỞ LẠI',

      AppStrings.notificationsTitle: 'Thông báo',
      AppStrings.notificationsEmpty: 'Bạn chưa có thông báo nào.',
      AppStrings.notificationsIntro: 'Bạn có thể xem\nthông báo tại đây.',
      AppStrings.notificationsSearch: 'Tìm kiếm',
      AppStrings.notificationsActionSentYou: 'đã gửi cho bạn',

      AppStrings.cardsTitle: 'Thẻ của tôi',
      AppStrings.cardsBalance: 'Số dư',
      AppStrings.cardsCardNumber: 'Số thẻ',
      AppStrings.cardsExpDate: 'Ngày hết hạn',
      AppStrings.cardsActive: 'Đang hoạt động',
      AppStrings.cardsFreeze: 'Đóng băng',
      AppStrings.cardsAddNew: 'Thêm thẻ mới',
      AppStrings.cardsPageTitle: 'Thẻ',
      AppStrings.cardsIntro: 'Bạn có thể xem\nthẻ của bạn tại đây',
      AppStrings.cardsLabelCompany: 'Công ty',
      AppStrings.cardsLabelHome: 'Nhà',
      AppStrings.cardsTxnShopping: 'Mua sắm',
      AppStrings.cardsTxnMedicine: 'Thuốc',
      AppStrings.cardsTxnSport: 'Thể thao',

      AppStrings.homeGreeting: 'Xin chào, {name}',
      AppStrings.homeGreetingMorning: 'Chào buổi sáng',
      AppStrings.homeGreetingAfternoon: 'Chào buổi chiều',
      AppStrings.homeGreetingEvening: 'Chào buổi tối',
      AppStrings.homeGreetingFallback: 'bạn',
      AppStrings.homeBalance: 'Số dư khả dụng',
      AppStrings.homeTotalBalance: 'Tổng số dư của bạn',
      AppStrings.homeSend: 'Gửi',
      AppStrings.homeRequest: 'Yêu cầu',
      AppStrings.homeBills: 'Hóa đơn',
      AppStrings.homePromoHeader: 'Khuyến mãi mới nhất',
      AppStrings.homeViewAll: 'Xem tất cả',
      AppStrings.homeRecentTransactions: 'Giao dịch gần đây',
      AppStrings.homeCheckAccounts: 'Kiểm tra\ntài khoản ngân hàng',
      AppStrings.homeMyCardsTabSelected: 'Đã chọn tab Thẻ của tôi',

      AppStrings.transactionsTitle: 'Giao dịch',
      AppStrings.transactionsSearchHint: 'Tìm kiếm giao dịch',
      AppStrings.transactionsFilterAll: 'Tất cả',
      AppStrings.transactionsFilterIncome: 'Thu vào',
      AppStrings.transactionsFilterExpense: 'Chi ra',
      AppStrings.transactionsEmpty: 'Không có giao dịch nào.',
      AppStrings.transactionsTotalExpenses: 'Tổng chi tiêu của bạn',
      AppStrings.transactionsTxnTravel: 'Du lịch',

      AppStrings.transactionDetailsTitle: 'Chi tiết giao dịch',
      AppStrings.transactionDetailsAmount: 'Số tiền',
      AppStrings.transactionDetailsDate: 'Ngày',
      AppStrings.transactionDetailsTo: 'Đến',
      AppStrings.transactionDetailsNotes: 'Ghi chú',
      AppStrings.transactionDetailsCreditRepayment: 'Thanh toán\nthẻ tín dụng',

      AppStrings.transferTitle: 'Chuyển tiền',
      AppStrings.transferAmountLabel: 'Số tiền',
      AppStrings.transferAmountHint: 'Nhập số tiền',
      AppStrings.transferRecipientLabel: 'Người nhận',
      AppStrings.transferRecipientHint: 'Bạn muốn gửi cho ai?',
      AppStrings.transferNoteLabel: 'Ghi chú (tùy chọn)',
      AppStrings.transferNoteHint: 'Thêm ghi chú ngắn',
      AppStrings.transferContinue: 'Tiếp tục',
      AppStrings.transferConfirmTitle: 'Xác nhận chuyển tiền',
      AppStrings.transferConfirmAmountLabel: 'Số tiền',
      AppStrings.transferConfirmRecipientLabel: 'Người nhận',
      AppStrings.transferConfirmNoteLabel: 'Ghi chú',
      AppStrings.transferConfirmButton: 'Xác nhận',
      AppStrings.transferDoneTitle: 'Đã gửi yêu cầu!',
      AppStrings.transferDoneDescription:
          'Giao dịch đang được xử lý. Bạn có thể theo dõi ở hoạt động gần đây.',
      AppStrings.transferDoneButton: 'Về trang chủ',
      AppStrings.transferDefaultRecipient: 'Người nhận',
      AppStrings.transferConfirmationTitle: 'Giao dịch',
      AppStrings.transferConfirmationMessagePrefix: 'Bạn đã chuyển thành công ',
      AppStrings.transferConfirmationMessageTo: 'cho ',
      AppStrings.transferConfirmationExecuteAgain: 'Thực hiện lại',
      AppStrings.transferConfirmationViewDetails: 'Xác nhận',

      AppStrings.errorGeneric: 'Đã xảy ra lỗi: {error}',

      AppStrings.settingsTitle: 'Cài đặt',
      AppStrings.settingsLanguageSection: 'Ngôn ngữ',
      AppStrings.settingsLanguageEnglish: 'Tiếng Anh',
      AppStrings.settingsLanguageVietnamese: 'Tiếng Việt',
      AppStrings.settingsLanguageApplied: 'Đã cập nhật ngôn ngữ',
    },
  };

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localization != null, 'No AppLocalizations found in context');
    return localization!;
  }

  String translate(String key, {Map<String, String> params = const {}}) {
    final languageCode = locale.languageCode;
    final values = _localizedValues[languageCode] ?? _localizedValues['en']!;
    final fallback = _localizedValues['en']!;
    final template = values[key] ?? fallback[key] ?? key;
    return params.entries.fold<String>(
      template,
      (value, entry) => value.replaceAll('{${entry.key}}', entry.value),
    );
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension AppLocalizationsBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String loc(String key, {Map<String, String> params = const {}}) =>
      l10n.translate(key, params: params);
}
