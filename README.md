# Monex (Flutter)

Một ứng dụng demo tài chính/ngân hàng viết bằng Flutter. App có Onboarding, Đăng nhập/Đăng ký, Trang chủ, Thẻ, Giao dịch, Chuyển tiền (kèm xác nhận), Thông báo và Hồ sơ. Repo đã cấu hình sẵn Firebase (tùy chọn).

• Entry: `lib/main.dart`
• Test mẫu: `test/widget_test.dart`

## Tính năng chính

- Onboarding: Splash, Welcome, walkthrough (`lib/onboarding/*`)
- Authentication: Sign in / Sign up / Account (`lib/auth/*`)
- Home + Drawer menu (`lib/home/*`, `lib/menu/*`)
- Cards và Transactions (`lib/cards/*`, `lib/transactions/*`)
- Chuyển tiền + Xác nhận (`lib/transfer/*`)
- Notifications (`lib/notifications/*`)
- Profile & Profile info (`lib/profile/*`)
- Assets, theme (`lib/theme/*`)

## Bản đồ routes (MaterialApp.routes)

Các route được khai báo trong `lib/main.dart`:

```
/onboarding              -> MonexOnboarding
/splash                  -> SplashPage
/welcome                 -> WelcomePage
/signin                  -> SignInPage
/signup                  -> SignUpPage
/account                 -> AccountPage
/profile                 -> ProfilePage
/home                    -> HomePage
/cards                   -> CardsPage
/transactions            -> TransactionsPage
/transactionDetails      -> TransactionDetailsPage
/transfer                -> TransferPage
/transferConfirmation    -> TransferConfirmationPage(args: amount, to)
/notifications           -> NotificationsPage
/profileInfo             -> ProfileInfoPage
```

Lưu ý: Ứng dụng có widget `_CounterPage` làm home mặc định (demo counter). Để app vào flow Splash/Onboarding ngay khi chạy, tạo app với `MonexApp(showSplashAtStartup: true)`.

## Cấu trúc thư mục chính

```
lib/
  auth/                  # Sign in / Sign up / Account
  cards/                 # Trang thẻ
  home/                  # Trang chủ
  menu/                  # Drawer/menu
  notifications/         # Thông báo
  onboarding/            # Splash + Onboarding + Welcome
  profile/               # Hồ sơ + info
  transactions/          # Giao dịch + chi tiết
  transfer/              # Chuyển tiền + xác nhận
  theme/                 # Hình ảnh / styles
  main.dart              # Entry & routes
```

## Môi trường và dependencies

- Flutter SDK: yêu cầu 3.x (pubspec: `sdk: ^3.9.0`)
- Một số package chính trong `pubspec.yaml`:
  - firebase_core ^4.1.1, firebase_auth ^6.1.0, cloud_firestore ^6.0.2
  - google_sign_in ^7.2.0, provider ^6.1.2, intl ^0.19.0, shared_preferences ^2.3.2

Android Gradle có bật Google Services plugin và BoM Firebase (`android/app/build.gradle.kts`).

## Cài đặt & chạy

1. Cài dependencies

```powershell
flutter pub get
```

2. Chạy app

```powershell
flutter devices
flutter run
```

3. Phân tích & format (khuyến nghị trước khi commit)

```powershell
flutter analyze
dart format .
```

4. Test

```powershell
flutter test
```

5. Build release

```powershell
# Android APK
flutter build apk --release

# iOS (chỉ trên macOS/Xcode)
flutter build ios --release
```

## Firebase (tùy chọn)

Repo có sẵn `android/app/google-services.json`. Nếu dùng Firebase cho dự án riêng:

- Android: đặt file `google-services.json` vào `android/app/` (thay bằng file của dự án bạn)
- iOS: thêm `ios/Runner/GoogleService-Info.plist` và bật plugin tương ứng nếu cần
- Kiểm tra Gradle/iOS đã cấu hình Google Services đúng. Repo này đã khai báo cơ bản.

Không dùng Firebase? Có thể giữ file mặc định (không ảnh hưởng nhiều) hoặc gỡ các plugin Firebase trong `pubspec.yaml` và cấu hình nền tảng.

## Troubleshooting nhanh

- Thiếu cấu hình Firebase:

  - Tải `google-services.json` / `GoogleService-Info.plist` từ Firebase Console và đặt đúng vị trí.

- iOS codesign fail:
  - Mở `ios/Runner.xcworkspace` trong Xcode, cấu hình Team, Bundle ID, Signing.


