import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('vi')];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      localizations != null,
      'AppLocalizations must be above the widget tree',
    );
    return localizations!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settingsTitle': 'Settings',
      'appearanceSection': 'Appearance',
      'languageSection': 'Language',
      'language': 'Language',
      'theme': 'Theme',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'light': 'Light',
      'dark': 'Dark',
      'darkModeSubtitle': 'Enable dark mode interface',
      'languageSubtitle': 'Choose your preferred language',
      'overview': 'Overview',
      'latestEntries': 'Latest Entries',
      'viewAll': 'View all',
      'homeNav': 'Home',
      'statsNav': 'Stats',
      'alertsNav': 'Alerts',
      'settingsNav': 'Settings',
      'statsTag': 'Stats',
      'savingsTag': 'Savings',
      'notificationsTag': 'Notifications',
      'budgetTag': 'Budget',
      'investTag': 'Invest',
      'cardTag': 'My Card',
      'cardsTitle': 'Card Management',
      'cardsSubtitle': 'Keep track of your bank and credit cards.',
      'cardsSummaryBalanceTitle': 'Total balance',
      'cardsSummaryBalanceCount': '{count} cards',
      'cardsSummaryCreditTitle': 'Credit limit',
      'cardsSummaryCreditCount': '{count} cards',
      'cardsEmptyState': 'No cards yet. Tap the button below to add one.',
      'cardsPrimaryBadge': 'Primary card',
      'cardsMakePrimary': 'Set as primary',
      'cardsAddButton': 'Add Card',
      'cardsBalanceLabel': 'Balance',
      'cardsTypeDebit': 'Debit card',
      'cardsTypeCredit': 'Credit card',
      'cardsEdit': 'Edit',
      'cardsDelete': 'Delete',
      'cardsSensitiveHide': 'Hide balances',
      'cardsSensitiveShow': 'Show balances',
      'cardsFormNameLabel': 'Cardholder name',
      'cardsFormNameHint': 'e.g. Alex Nguyen',
      'cardsFormNumberLabel': 'Card number',
      'cardsFormNumberHint': 'XXXX XXXX XXXX XXXX',
      'cardsFormExpiryLabel': 'Expiry date',
      'cardsFormExpiryHint': 'MM/YY',
      'cardsFormIssuerLabel': 'Issuer',
      'cardsFormIssuerHint': 'e.g. Visa, MasterCard',
      'cardsFormIssuerOtherOption': 'Other bank',
      'cardsFormIssuerOtherLabel': 'Enter bank name',
      'cardsFormTypeLabel': 'Card type',
      'cardsFormBalanceLabel': 'Current balance',
      'cardsFormBalanceHint': 'e.g. 10000000',
      'cardsFormPrimaryToggle': 'Mark as primary card',
      'cardsFormSave': 'Save card',
      'cardsFormValidationRequired': 'Please fill out this field.',
      'cardsFormNumberInvalid': 'Card number must be at least 12 digits.',
      'cardsFormExpiryInvalid': 'Expiry date is invalid.',
      'cardsFormBalanceInvalid': 'Please enter a valid amount.',
      'cardsDeleteConfirmTitle': 'Remove card',
      'cardsDeleteConfirmMessage': 'Are you sure you want to remove this card?',
      'cardsAddedMessage': 'Card added',
      'cardsUpdatedMessage': 'Card updated',
      'cardsRemovedMessage': 'Card removed',
      'commonCancel': 'Cancel',
      'commonComingSoon': 'Coming soon',
      'profileTitle': 'Profile',
      'profileOverviewSection': 'Account Overview',
      'profileMembershipLabel': 'Membership',
      'profileSinceLabel': 'Member since',
      'profileMembershipDefault': 'Basic',
      'profileDefaultName': 'Monex user',
      'profileMissingValue': 'Not provided',
      'profileSignInRequired': 'Please sign in to view your profile.',
      'profileLoadError':
          "We couldn't load your profile. Please try again later.",
      'profilePersonalInfoSection': 'Personal Information',
      'profileEmailLabel': 'Email',
      'profilePhoneLabel': 'Phone',
      'profileAddressLabel': 'Address',
      'profileActionsSection': 'Quick Actions',
      'profileEditAction': 'Edit profile',
      'profileSecurityAction': 'Security settings',
      'profilePaymentAction': 'Payment methods',
      'profileNotificationsAction': 'Notification preferences',
      'profileLogoutAction': 'Sign out',
      'profileLogoutConfirmTitle': 'Sign out',
      'profileLogoutConfirmMessage': 'Are you sure you want to sign out?',
      'profileLogoutConfirmAccept': 'Sign out',
      'profileSignedOutMessage': 'You have been signed out.',
      'profileEditTitle': 'Edit profile',
      'profileEditNameLabel': 'Full name',
      'profileEditPhoneLabel': 'Phone number',
      'profileEditAddressLabel': 'Address',
      'profileEditSave': 'Save changes',
      'profileEditSuccess': 'Profile updated',
      'profileEditError': 'Could not update profile. Please try again.',
      'profileEditValidationName': 'Please enter your name.',
      'notificationsIncomeTitle': 'Income recorded',
      'notificationsExpenseTitle': 'Expense tracked',
      'notificationsIncomeMessage': 'Income of {amount} saved for {category}.',
      'notificationsExpenseMessage':
          'Expense of {amount} saved for {category}.',
      'notificationsEmptyState': 'No notifications yet. Keep tracking!',
      'notificationsTimeJustNow': 'Just now',
      'notificationsTimeMinute': '1 min ago',
      'notificationsTimeMinutes': '{count} mins ago',
      'notificationsTimeHour': '1 hour ago',
      'notificationsTimeHours': '{count} hours ago',
      'notificationsTimeYesterday': 'Yesterday',
      'notificationsTimeDays': '{count} days ago',
      'summarySalaryTitle': 'Total Salary',
      'summarySalaryAmount': '10,000,000 ₫',
      'summaryExpenseTitle': 'Total Expense',
      'summaryExpenseAmount': '4,500,000 ₫',
      'summaryMonthlyTitle': 'Monthly',
      'summaryMonthlyAmount': '5,500,000 ₫',
      'onboardingTitle1': 'Note Down Expenses',
      'onboardingDesc1':
          'Daily note your expenses to help you manage money better every day.',
      'onboardingTitle2': 'Simple Money Management',
      'onboardingDesc2':
          'Get reminders when your spendings go over budget so you can respond fast.',
      'onboardingTitle3': 'Easy to Track and Analyze',
      'onboardingDesc3':
          'Understand where your money goes and stay in control of your financial goals.',
      'onboardingCta': "LET'S GO",
      'forgotPasswordTitle': 'Forgot Password',
      'forgotPasswordSubtitle':
          'Enter your email address and choose a new password.',
      'forgotPasswordEmailPlaceholder': 'Email address',
      'forgotPasswordSendCode': 'RESET PASSWORD',
      'forgotPasswordVerifyTitle': 'Forgot Password',
      'forgotPasswordVerifySubtitle': 'Enter a new password for {email}.',
      'forgotPasswordCodePlaceholder': 'Verification code',
      'forgotPasswordNewPasswordPlaceholder': 'New password',
      'forgotPasswordConfirmPasswordPlaceholder': 'Confirm new password',
      'forgotPasswordSetPassword': 'RESET PASSWORD',
      'forgotPasswordChangeEmail': 'Use a different email',
      'forgotPasswordCodeSent': 'Password reset prepared for {email}.',
      'forgotPasswordSendError':
          'We couldn\'t send the verification email. Please try again shortly.',
      'forgotPasswordCodeInvalid': 'The verification code is incorrect.',
      'forgotPasswordPasswordTooShort':
          'Password must be at least 6 characters.',
      'forgotPasswordPasswordMismatch': 'Passwords do not match.',
      'forgotPasswordSuccess': 'Password updated successfully.',
      'forgotPasswordEmailInvalid': 'Please enter a valid email address.',
      'homeDateLabel': 'Fri, 28 Feb 2024',
      'entryFoodTitle': 'Food',
      'entryFoodDate': '20 Feb 2024',
      'entryFoodAmount': '+ 120,000 ₫',
      'entryFoodMethod': 'Google Pay',
      'entryUberTitle': 'Uber',
      'entryUberDate': '13 Mar 2024',
      'entryUberAmount': '- 85,000 ₫',
      'entryUberMethod': 'Cash',
      'entryShoppingTitle': 'Shopping',
      'entryShoppingDate': '11 Mar 2024',
      'entryShoppingAmount': '- 2,800,000 ₫',
      'entryShoppingMethod': 'Paytm',
      'statsTitle': 'Statistics',
      'spendingOverview': 'Spending Overview',
      'monthlyTrend': 'Monthly Trend',
      'categoryBreakdown': 'Category Breakdown',
      'incomeLabel': 'Income',
      'expensesLabel': 'Expenses',
      'savingsLabel': 'Savings',
      'foodCategory': 'Food',
      'transportCategory': 'Transport',
      'entertainmentCategory': 'Entertainment',
      'shoppingCategory': 'Shopping',
      'transactionsTitle': 'Transactions',
      'transactionsSubtitle': 'All of your transactions',
      'transactionsEmptyState':
          'No transactions yet. Tap the plus button to add one.',
      'transactionsEditAction': 'Edit',
      'transactionsDeleteAction': 'Delete',
      'transactionsEditComingSoon':
          'Editing transactions will be available soon.',
      'transactionsDeleteConfirmTitle': 'Remove transaction',
      'transactionsDeleteConfirmMessage':
          'Are you sure you want to delete this transaction?',
      'transactionsDeleteConfirmAccept': 'Delete',
      'transactionsDeletedMessage': 'Transaction removed',
      'transactionsAddHeader': 'Add',
      'transactionsAddIncomeTitle': 'Add Income',
      'transactionsAddIncomeSubtitle': 'Record money in',
      'transactionsAddExpenseTitle': 'Add Expense',
      'transactionsAddExpenseSubtitle': 'Track spending',
      'transactionsFormAmountLabel': 'How much?',
      'transactionsFormCategoryLabel': 'Select category',
      'transactionsFormDateLabel': 'Transaction date',
      'transactionsFormNoteLabel': 'Note',
      'transactionsFormNoteHint': 'Add a note (optional)',
      'transactionsFormAmountError': 'Please enter an amount.',
      'transactionsFormAmountInvalid': 'Enter a valid amount.',
      'transactionsFormAddIncomeCta': 'ADD INCOME',
      'transactionsFormAddExpenseCta': 'ADD EXPENSE',
      'transactionsIncomeCategories': 'Salary|Side Hustle|Bonus|Other',
      'transactionsExpenseCategories': 'Food|Health|Bills|Travel|Other',
      'transactionsToastSaved': 'Transaction saved',
    },
    'vi': {
      'settingsTitle': 'Cài đặt',
      'appearanceSection': 'Giao diện',
      'languageSection': 'Ngôn ngữ',
      'language': 'Ngôn ngữ',
      'theme': 'Chủ đề',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'light': 'Sáng',
      'dark': 'Tối',
      'darkModeSubtitle': 'Bật giao diện nền tối',
      'languageSubtitle': 'Chọn ngôn ngữ bạn muốn sử dụng',
      'overview': 'Tổng quan',
      'latestEntries': 'Giao dịch gần đây',
      'viewAll': 'Xem tất cả',
      'homeNav': 'Trang chủ',
      'statsNav': 'Thống kê',
      'alertsNav': 'Thông báo',
      'settingsNav': 'Cài đặt',
      'statsTag': 'Thống kê',
      'savingsTag': 'Tiết kiệm',
      'notificationsTag': 'Thông báo',
      'budgetTag': 'Ngân sách',
      'investTag': 'Đầu tư',
      'cardTag': 'Thẻ của tôi',
      'cardsTitle': 'Quản lý thẻ',
      'cardsSubtitle': 'Quản lý thẻ ngân hàng và thẻ tín dụng.',
      'cardsSummaryBalanceTitle': 'Tổng số dư',
      'cardsSummaryBalanceCount': '{count} thẻ',
      'cardsSummaryCreditTitle': 'Hạn mức tín dụng',
      'cardsSummaryCreditCount': '{count} thẻ',
      'cardsEmptyState': 'Chưa có thẻ nào. Nhấn nút bên dưới để thêm.',
      'cardsPrimaryBadge': 'Thẻ chính',
      'cardsMakePrimary': 'Đặt làm thẻ chính',
      'cardsAddButton': 'Thêm thẻ',
      'cardsBalanceLabel': 'Số dư',
      'cardsTypeDebit': 'Thẻ ghi nợ',
      'cardsTypeCredit': 'Thẻ tín dụng',
      'cardsEdit': 'Chỉnh sửa',
      'cardsDelete': 'Xoá',
      'cardsSensitiveHide': 'Ẩn số dư',
      'cardsSensitiveShow': 'Hiện số dư',
      'cardsFormNameLabel': 'Tên chủ thẻ',
      'cardsFormNameHint': 'Ví dụ: Nguyễn Văn A',
      'cardsFormNumberLabel': 'Số thẻ',
      'cardsFormNumberHint': 'XXXX XXXX XXXX XXXX',
      'cardsFormExpiryLabel': 'Ngày hết hạn',
      'cardsFormExpiryHint': 'MM/YY',
      'cardsFormIssuerLabel': 'Ngân hàng phát hành',
      'cardsFormIssuerHint': 'Ví dụ: Vietcombank, Techcombank',
      'cardsFormIssuerOtherOption': 'Ngân hàng khác',
      'cardsFormIssuerOtherLabel': 'Nhập tên ngân hàng',
      'cardsFormTypeLabel': 'Loại thẻ',
      'cardsFormBalanceLabel': 'Số dư hiện tại',
      'cardsFormBalanceHint': 'Ví dụ: 10000000',
      'cardsFormPrimaryToggle': 'Đánh dấu là thẻ chính',
      'cardsFormSave': 'Lưu thẻ',
      'cardsFormValidationRequired': 'Vui lòng nhập thông tin.',
      'cardsFormNumberInvalid': 'Số thẻ phải có ít nhất 12 chữ số.',
      'cardsFormExpiryInvalid': 'Ngày hết hạn không hợp lệ.',
      'cardsFormBalanceInvalid': 'Vui lòng nhập số tiền hợp lệ.',
      'cardsDeleteConfirmTitle': 'Xoá thẻ',
      'cardsDeleteConfirmMessage': 'Bạn có chắc chắn muốn xoá thẻ này không?',
      'cardsAddedMessage': 'Đã thêm thẻ',
      'cardsUpdatedMessage': 'Đã cập nhật thẻ',
      'cardsRemovedMessage': 'Đã xoá thẻ',
      'commonCancel': 'Huỷ',
      'commonComingSoon': 'Sắp ra mắt',
      'profileTitle': 'Hồ sơ',
      'profileOverviewSection': 'Tổng quan tài khoản',
      'profileMembershipLabel': 'Hạng thành viên',
      'profileSinceLabel': 'Thành viên từ',
      'profileMembershipDefault': 'Thành viên cơ bản',
      'profileDefaultName': 'Người dùng Monex',
      'profileMissingValue': 'Chưa cập nhật',
      'profileSignInRequired': 'Vui lòng đăng nhập để xem hồ sơ của bạn.',
      'profileLoadError': 'Không thể tải hồ sơ của bạn. Vui lòng thử lại sau.',
      'profilePersonalInfoSection': 'Thông tin cá nhân',
      'profileEmailLabel': 'Email',
      'profilePhoneLabel': 'Số điện thoại',
      'profileAddressLabel': 'Địa chỉ',
      'profileActionsSection': 'Hành động nhanh',
      'profileEditAction': 'Chỉnh sửa hồ sơ',
      'profileSecurityAction': 'Cài đặt bảo mật',
      'profilePaymentAction': 'Phương thức thanh toán',
      'profileNotificationsAction': 'Tuỳ chọn thông báo',
      'profileLogoutAction': 'Đăng xuất',
      'profileLogoutConfirmTitle': 'Đăng xuất',
      'profileLogoutConfirmMessage': 'Bạn có chắc chắn muốn đăng xuất không?',
      'profileLogoutConfirmAccept': 'Đăng xuất',
      'profileSignedOutMessage': 'Bạn đã đăng xuất.',
      'profileEditTitle': 'Chỉnh sửa hồ sơ',
      'profileEditNameLabel': 'Họ và tên',
      'profileEditPhoneLabel': 'Số điện thoại',
      'profileEditAddressLabel': 'Địa chỉ',
      'profileEditSave': 'Lưu thay đổi',
      'profileEditSuccess': 'Đã cập nhật hồ sơ',
      'profileEditError': 'Không thể cập nhật hồ sơ. Vui lòng thử lại.',
      'profileEditValidationName': 'Vui lòng nhập tên.',
      'notificationsIncomeTitle': 'Đã ghi nhận thu nhập',
      'notificationsExpenseTitle': 'Đã ghi nhận chi tiêu',
      'notificationsIncomeMessage':
          'Khoản thu {amount} cho {category} đã được lưu.',
      'notificationsExpenseMessage':
          'Khoản chi {amount} cho {category} đã được lưu.',
      'notificationsEmptyState':
          'Chưa có thông báo nào. Hãy tiếp tục theo dõi!',
      'notificationsTimeJustNow': 'Vừa xong',
      'notificationsTimeMinute': '1 phút trước',
      'notificationsTimeMinutes': '{count} phút trước',
      'notificationsTimeHour': '1 giờ trước',
      'notificationsTimeHours': '{count} giờ trước',
      'notificationsTimeYesterday': 'Hôm qua',
      'notificationsTimeDays': '{count} ngày trước',
      'summarySalaryTitle': 'Tổng lương',
      'summarySalaryAmount': '10.000.000 ₫',
      'summaryExpenseTitle': 'Tổng chi tiêu',
      'summaryExpenseAmount': '4.500.000 ₫',
      'summaryMonthlyTitle': 'Hàng tháng',
      'summaryMonthlyAmount': '5.500.000 ₫',
      'onboardingTitle1': 'Ghi lại chi tiêu',
      'onboardingDesc1':
          'Ghi chú chi tiêu mỗi ngày để quản lý tiền bạc hiệu quả hơn.',
      'onboardingTitle2': 'Quản lý tiền đơn giản',
      'onboardingDesc2':
          'Nhận nhắc nhở khi chi tiêu vượt ngân sách để xử lý kịp thời.',
      'onboardingTitle3': 'Theo dõi và phân tích dễ dàng',
      'onboardingDesc3':
          'Hiểu dòng tiền của bạn và làm chủ các mục tiêu tài chính.',
      'onboardingCta': 'BẮT ĐẦU',
      'forgotPasswordTitle': 'Quên mật khẩu',
      'forgotPasswordSubtitle': 'Nhập email đăng ký và đặt mật khẩu mới.',
      'forgotPasswordEmailPlaceholder': 'Địa chỉ email',
      'forgotPasswordSendCode': 'ĐỔI MẬT KHẨU',
      'forgotPasswordVerifyTitle': 'Quên mật khẩu',
      'forgotPasswordVerifySubtitle': 'Nhập mật khẩu mới cho {email}.',
      'forgotPasswordCodePlaceholder': 'Mã xác minh',
      'forgotPasswordNewPasswordPlaceholder': 'Mật khẩu mới',
      'forgotPasswordConfirmPasswordPlaceholder': 'Xác nhận mật khẩu mới',
      'forgotPasswordSetPassword': 'ĐỔI MẬT KHẨU',
      'forgotPasswordChangeEmail': 'Nhập email khác',
      'forgotPasswordCodeSent': 'Đổi mật khẩu cho {email} đã sẵn sàng.',
      'forgotPasswordSendError':
          'Không thể gửi email xác minh. Vui lòng thử lại sau.',
      'forgotPasswordCodeInvalid': 'Mã xác minh không đúng.',
      'forgotPasswordPasswordTooShort': 'Mật khẩu phải có ít nhất 6 ký tự.',
      'forgotPasswordPasswordMismatch': 'Mật khẩu nhập lại không trùng khớp.',
      'forgotPasswordSuccess': 'Đổi mật khẩu thành công.',
      'forgotPasswordEmailInvalid': 'Vui lòng nhập email hợp lệ.',
      'homeDateLabel': 'Thứ sáu, 28 Thg 2 2024',
      'entryFoodTitle': 'Ăn uống',
      'entryFoodDate': '20 Thg 2 2024',
      'entryFoodAmount': '+ 120.000 ₫',
      'entryFoodMethod': 'Google Pay',
      'entryUberTitle': 'Uber',
      'entryUberDate': '13 Thg 3 2024',
      'entryUberAmount': '- 85.000 ₫',
      'entryUberMethod': 'Tiền mặt',
      'entryShoppingTitle': 'Mua sắm',
      'entryShoppingDate': '11 Thg 3 2024',
      'entryShoppingAmount': '- 2.800.000 ₫',
      'entryShoppingMethod': 'Paytm',
      'statsTitle': 'Thống kê',
      'spendingOverview': 'Tổng quan chi tiêu',
      'monthlyTrend': 'Xu hướng theo tháng',
      'categoryBreakdown': 'Phân loại danh mục',
      'incomeLabel': 'Thu nhập',
      'expensesLabel': 'Chi tiêu',
      'savingsLabel': 'Tiết kiệm',
      'foodCategory': 'Ăn uống',
      'transportCategory': 'Di chuyển',
      'entertainmentCategory': 'Giải trí',
      'shoppingCategory': 'Mua sắm',
      'transactionsTitle': 'Giao dịch',
      'transactionsSubtitle': 'Tất cả giao dịch của bạn',
      'transactionsEmptyState': 'Chưa có giao dịch nào. Nhấn nút + để thêm.',
      'transactionsEditAction': 'Sửa',
      'transactionsDeleteAction': 'Xoá',
      'transactionsEditComingSoon': 'Tính năng chỉnh sửa sẽ sớm ra mắt.',
      'transactionsDeleteConfirmTitle': 'Xoá giao dịch',
      'transactionsDeleteConfirmMessage':
          'Bạn có chắc muốn xoá giao dịch này không?',
      'transactionsDeleteConfirmAccept': 'Xoá',
      'transactionsDeletedMessage': 'Đã xoá giao dịch',
      'transactionsAddHeader': 'Thêm',
      'transactionsAddIncomeTitle': 'Thêm thu nhập',
      'transactionsAddIncomeSubtitle': 'Ghi lại tiền vào',
      'transactionsAddExpenseTitle': 'Thêm chi tiêu',
      'transactionsAddExpenseSubtitle': 'Theo dõi tiền ra',
      'transactionsFormAmountLabel': 'Số tiền?',
      'transactionsFormCategoryLabel': 'Chọn danh mục',
      'transactionsFormDateLabel': 'Ngày giao dịch',
      'transactionsFormNoteLabel': 'Ghi chú',
      'transactionsFormNoteHint': 'Thêm ghi chú (không bắt buộc)',
      'transactionsFormAmountError': 'Vui lòng nhập số tiền.',
      'transactionsFormAmountInvalid': 'Nhập số tiền hợp lệ.',
      'transactionsFormAddIncomeCta': 'THÊM THU NHẬP',
      'transactionsFormAddExpenseCta': 'THÊM CHI TIÊU',
      'transactionsIncomeCategories': 'Lương|Việc làm thêm|Thưởng|Khác',
      'transactionsExpenseCategories':
          'Ăn uống|Sức khỏe|Hóa đơn|Di chuyển|Khác',
      'transactionsToastSaved': 'Đã lưu giao dịch',
    },
  };

  String _valueFor(String key) {
    final langMap =
        _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return langMap[key] ?? _localizedValues['en']![key] ?? key;
  }

  List<String> _splitList(String key) {
    return _valueFor(key)
        .split('|')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  String get settingsTitle => _valueFor('settingsTitle');
  String get appearanceSection => _valueFor('appearanceSection');
  String get languageSection => _valueFor('languageSection');
  String get language => _valueFor('language');
  String get languageSubtitle => _valueFor('languageSubtitle');
  String get theme => _valueFor('theme');
  String get darkModeSubtitle => _valueFor('darkModeSubtitle');
  String get english => _valueFor('english');
  String get vietnamese => _valueFor('vietnamese');
  String get light => _valueFor('light');
  String get dark => _valueFor('dark');
  String get overview => _valueFor('overview');
  String get latestEntries => _valueFor('latestEntries');
  String get viewAll => _valueFor('viewAll');
  String get homeNav => _valueFor('homeNav');
  String get statsNav => _valueFor('statsNav');
  String get alertsNav => _valueFor('alertsNav');
  String get settingsNav => _valueFor('settingsNav');
  String get statsTag => _valueFor('statsTag');
  String get savingsTag => _valueFor('savingsTag');
  String get notificationsTag => _valueFor('notificationsTag');
  String get budgetTag => _valueFor('budgetTag');
  String get investTag => _valueFor('investTag');
  String get cardTag => _valueFor('cardTag');
  String get cardsTitle => _valueFor('cardsTitle');
  String get cardsSubtitle => _valueFor('cardsSubtitle');
  String get cardsSummaryBalanceTitle => _valueFor('cardsSummaryBalanceTitle');
  String cardsSummaryBalanceCount(int count) =>
      _valueFor('cardsSummaryBalanceCount').replaceAll('{count}', '$count');
  String get cardsSummaryCreditTitle => _valueFor('cardsSummaryCreditTitle');
  String cardsSummaryCreditCount(int count) =>
      _valueFor('cardsSummaryCreditCount').replaceAll('{count}', '$count');
  String get cardsEmptyState => _valueFor('cardsEmptyState');
  String get cardsPrimaryBadge => _valueFor('cardsPrimaryBadge');
  String get cardsMakePrimary => _valueFor('cardsMakePrimary');
  String get cardsAddButton => _valueFor('cardsAddButton');
  String get cardsBalanceLabel => _valueFor('cardsBalanceLabel');
  String get cardsTypeDebit => _valueFor('cardsTypeDebit');
  String get cardsTypeCredit => _valueFor('cardsTypeCredit');
  String get cardsEdit => _valueFor('cardsEdit');
  String get cardsDelete => _valueFor('cardsDelete');
  String get cardsSensitiveHide => _valueFor('cardsSensitiveHide');
  String get cardsSensitiveShow => _valueFor('cardsSensitiveShow');
  String get cardsFormNameLabel => _valueFor('cardsFormNameLabel');
  String get cardsFormNameHint => _valueFor('cardsFormNameHint');
  String get cardsFormNumberLabel => _valueFor('cardsFormNumberLabel');
  String get cardsFormNumberHint => _valueFor('cardsFormNumberHint');
  String get cardsFormExpiryLabel => _valueFor('cardsFormExpiryLabel');
  String get cardsFormExpiryHint => _valueFor('cardsFormExpiryHint');
  String get cardsFormIssuerLabel => _valueFor('cardsFormIssuerLabel');
  String get cardsFormIssuerHint => _valueFor('cardsFormIssuerHint');
  String get cardsFormIssuerOtherOption =>
      _valueFor('cardsFormIssuerOtherOption');
  String get cardsFormIssuerOtherLabel =>
      _valueFor('cardsFormIssuerOtherLabel');
  String get cardsFormTypeLabel => _valueFor('cardsFormTypeLabel');
  String get cardsFormBalanceLabel => _valueFor('cardsFormBalanceLabel');
  String get cardsFormBalanceHint => _valueFor('cardsFormBalanceHint');
  String get cardsFormPrimaryToggle => _valueFor('cardsFormPrimaryToggle');
  String get cardsFormSave => _valueFor('cardsFormSave');
  String get cardsFormValidationRequired =>
      _valueFor('cardsFormValidationRequired');
  String get cardsFormNumberInvalid => _valueFor('cardsFormNumberInvalid');
  String get cardsFormExpiryInvalid => _valueFor('cardsFormExpiryInvalid');
  String get cardsFormBalanceInvalid => _valueFor('cardsFormBalanceInvalid');
  String get cardsDeleteConfirmTitle => _valueFor('cardsDeleteConfirmTitle');
  String get cardsDeleteConfirmMessage =>
      _valueFor('cardsDeleteConfirmMessage');
  String get cardsAddedMessage => _valueFor('cardsAddedMessage');
  String get cardsUpdatedMessage => _valueFor('cardsUpdatedMessage');
  String get cardsRemovedMessage => _valueFor('cardsRemovedMessage');
  String get commonCancel => _valueFor('commonCancel');
  String get commonComingSoon => _valueFor('commonComingSoon');
  String get profileTitle => _valueFor('profileTitle');
  String get profileOverviewSection => _valueFor('profileOverviewSection');
  String get profileMembershipLabel => _valueFor('profileMembershipLabel');
  String get profileSinceLabel => _valueFor('profileSinceLabel');
  String get profileMembershipDefault => _valueFor('profileMembershipDefault');
  String get profileDefaultName => _valueFor('profileDefaultName');
  String get profileMissingValue => _valueFor('profileMissingValue');
  String get profileSignInRequired => _valueFor('profileSignInRequired');
  String get profileLoadError => _valueFor('profileLoadError');
  String get profilePersonalInfoSection =>
      _valueFor('profilePersonalInfoSection');
  String get profileEmailLabel => _valueFor('profileEmailLabel');
  String get profilePhoneLabel => _valueFor('profilePhoneLabel');
  String get profileAddressLabel => _valueFor('profileAddressLabel');
  String get profileActionsSection => _valueFor('profileActionsSection');
  String get profileEditAction => _valueFor('profileEditAction');
  String get profileSecurityAction => _valueFor('profileSecurityAction');
  String get profilePaymentAction => _valueFor('profilePaymentAction');
  String get profileNotificationsAction =>
      _valueFor('profileNotificationsAction');
  String get profileLogoutAction => _valueFor('profileLogoutAction');
  String get profileLogoutConfirmTitle =>
      _valueFor('profileLogoutConfirmTitle');
  String get profileLogoutConfirmMessage =>
      _valueFor('profileLogoutConfirmMessage');
  String get profileLogoutConfirmAccept =>
      _valueFor('profileLogoutConfirmAccept');
  String get profileSignedOutMessage => _valueFor('profileSignedOutMessage');
  String get profileEditTitle => _valueFor('profileEditTitle');
  String get profileEditNameLabel => _valueFor('profileEditNameLabel');
  String get profileEditPhoneLabel => _valueFor('profileEditPhoneLabel');
  String get profileEditAddressLabel => _valueFor('profileEditAddressLabel');
  String get profileEditSave => _valueFor('profileEditSave');
  String get profileEditSuccess => _valueFor('profileEditSuccess');
  String get profileEditError => _valueFor('profileEditError');
  String get profileEditValidationName =>
      _valueFor('profileEditValidationName');
  String get notificationsIncomeTitle => _valueFor('notificationsIncomeTitle');
  String get notificationsExpenseTitle =>
      _valueFor('notificationsExpenseTitle');
  String get notificationsIncomeMessage =>
      _valueFor('notificationsIncomeMessage');
  String get notificationsExpenseMessage =>
      _valueFor('notificationsExpenseMessage');
  String get notificationsEmptyState => _valueFor('notificationsEmptyState');
  String get notificationsTimeJustNow => _valueFor('notificationsTimeJustNow');
  String get notificationsTimeMinute => _valueFor('notificationsTimeMinute');
  String get notificationsTimeMinutes => _valueFor('notificationsTimeMinutes');
  String get notificationsTimeHour => _valueFor('notificationsTimeHour');
  String get notificationsTimeHours => _valueFor('notificationsTimeHours');
  String get notificationsTimeYesterday =>
      _valueFor('notificationsTimeYesterday');
  String get notificationsTimeDays => _valueFor('notificationsTimeDays');
  String get summarySalaryTitle => _valueFor('summarySalaryTitle');
  String get summarySalaryAmount => _valueFor('summarySalaryAmount');
  String get summaryExpenseTitle => _valueFor('summaryExpenseTitle');
  String get summaryExpenseAmount => _valueFor('summaryExpenseAmount');
  String get summaryMonthlyTitle => _valueFor('summaryMonthlyTitle');
  String get summaryMonthlyAmount => _valueFor('summaryMonthlyAmount');
  String get forgotPasswordTitle => _valueFor('forgotPasswordTitle');
  String get forgotPasswordSubtitle => _valueFor('forgotPasswordSubtitle');
  String get forgotPasswordEmailPlaceholder =>
      _valueFor('forgotPasswordEmailPlaceholder');
  String get forgotPasswordSendCode => _valueFor('forgotPasswordSendCode');
  String get forgotPasswordVerifyTitle =>
      _valueFor('forgotPasswordVerifyTitle');
  String get forgotPasswordCodePlaceholder =>
      _valueFor('forgotPasswordCodePlaceholder');
  String get forgotPasswordNewPasswordPlaceholder =>
      _valueFor('forgotPasswordNewPasswordPlaceholder');
  String get forgotPasswordConfirmPasswordPlaceholder =>
      _valueFor('forgotPasswordConfirmPasswordPlaceholder');
  String get forgotPasswordSetPassword =>
      _valueFor('forgotPasswordSetPassword');
  String get forgotPasswordChangeEmail =>
      _valueFor('forgotPasswordChangeEmail');
  String get forgotPasswordSendError => _valueFor('forgotPasswordSendError');
  String get forgotPasswordCodeInvalid =>
      _valueFor('forgotPasswordCodeInvalid');
  String get forgotPasswordPasswordTooShort =>
      _valueFor('forgotPasswordPasswordTooShort');
  String get forgotPasswordPasswordMismatch =>
      _valueFor('forgotPasswordPasswordMismatch');
  String get forgotPasswordSuccess => _valueFor('forgotPasswordSuccess');
  String get forgotPasswordEmailInvalid =>
      _valueFor('forgotPasswordEmailInvalid');
  String forgotPasswordVerifySubtitle(String email) {
    return _valueFor(
      'forgotPasswordVerifySubtitle',
    ).replaceAll('{email}', email);
  }

  String forgotPasswordCodeSent(String email) {
    return _valueFor('forgotPasswordCodeSent').replaceAll('{email}', email);
  }

  String get onboardingTitle1 => _valueFor('onboardingTitle1');
  String get onboardingDesc1 => _valueFor('onboardingDesc1');
  String get onboardingTitle2 => _valueFor('onboardingTitle2');
  String get onboardingDesc2 => _valueFor('onboardingDesc2');
  String get onboardingTitle3 => _valueFor('onboardingTitle3');
  String get onboardingDesc3 => _valueFor('onboardingDesc3');
  String get onboardingCta => _valueFor('onboardingCta');
  String get homeDateLabel => _valueFor('homeDateLabel');
  String get entryFoodTitle => _valueFor('entryFoodTitle');
  String get entryFoodDate => _valueFor('entryFoodDate');
  String get entryFoodAmount => _valueFor('entryFoodAmount');
  String get entryFoodMethod => _valueFor('entryFoodMethod');
  String get entryUberTitle => _valueFor('entryUberTitle');
  String get entryUberDate => _valueFor('entryUberDate');
  String get entryUberAmount => _valueFor('entryUberAmount');
  String get entryUberMethod => _valueFor('entryUberMethod');
  String get entryShoppingTitle => _valueFor('entryShoppingTitle');
  String get entryShoppingDate => _valueFor('entryShoppingDate');
  String get entryShoppingAmount => _valueFor('entryShoppingAmount');
  String get entryShoppingMethod => _valueFor('entryShoppingMethod');
  String get statsTitle => _valueFor('statsTitle');
  String get spendingOverview => _valueFor('spendingOverview');
  String get monthlyTrend => _valueFor('monthlyTrend');
  String get categoryBreakdown => _valueFor('categoryBreakdown');
  String get incomeLabel => _valueFor('incomeLabel');
  String get expensesLabel => _valueFor('expensesLabel');
  String get savingsLabel => _valueFor('savingsLabel');
  String get foodCategory => _valueFor('foodCategory');
  String get transportCategory => _valueFor('transportCategory');
  String get entertainmentCategory => _valueFor('entertainmentCategory');
  String get shoppingCategory => _valueFor('shoppingCategory');
  String get transactionsTitle => _valueFor('transactionsTitle');
  String get transactionsSubtitle => _valueFor('transactionsSubtitle');
  String get transactionsEmptyState => _valueFor('transactionsEmptyState');
  String get transactionsEditAction => _valueFor('transactionsEditAction');
  String get transactionsDeleteAction => _valueFor('transactionsDeleteAction');
  String get transactionsEditComingSoon =>
      _valueFor('transactionsEditComingSoon');
  String get transactionsDeleteConfirmTitle =>
      _valueFor('transactionsDeleteConfirmTitle');
  String get transactionsDeleteConfirmMessage =>
      _valueFor('transactionsDeleteConfirmMessage');
  String get transactionsDeleteConfirmAccept =>
      _valueFor('transactionsDeleteConfirmAccept');
  String get transactionsDeletedMessage =>
      _valueFor('transactionsDeletedMessage');
  String get transactionsAddHeader => _valueFor('transactionsAddHeader');
  String get transactionsAddIncomeTitle =>
      _valueFor('transactionsAddIncomeTitle');
  String get transactionsAddIncomeSubtitle =>
      _valueFor('transactionsAddIncomeSubtitle');
  String get transactionsAddExpenseTitle =>
      _valueFor('transactionsAddExpenseTitle');
  String get transactionsAddExpenseSubtitle =>
      _valueFor('transactionsAddExpenseSubtitle');
  String get transactionsFormAmountLabel =>
      _valueFor('transactionsFormAmountLabel');
  String get transactionsFormCategoryLabel =>
      _valueFor('transactionsFormCategoryLabel');
  String get transactionsFormDateLabel =>
      _valueFor('transactionsFormDateLabel');
  String get transactionsFormNoteLabel =>
      _valueFor('transactionsFormNoteLabel');
  String get transactionsFormNoteHint => _valueFor('transactionsFormNoteHint');
  String get transactionsFormAmountError =>
      _valueFor('transactionsFormAmountError');
  String get transactionsFormAmountInvalid =>
      _valueFor('transactionsFormAmountInvalid');
  String get transactionsFormAddIncomeCta =>
      _valueFor('transactionsFormAddIncomeCta');
  String get transactionsFormAddExpenseCta =>
      _valueFor('transactionsFormAddExpenseCta');
  List<String> get transactionsIncomeCategories =>
      _splitList('transactionsIncomeCategories');
  List<String> get transactionsExpenseCategories =>
      _splitList('transactionsExpenseCategories');
  String get transactionsToastSaved => _valueFor('transactionsToastSaved');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
