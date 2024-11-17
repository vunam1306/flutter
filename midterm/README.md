# midterm

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

TECH ZONE
Tech Zone là nền tảng thương mại điện tử hiện đại, được phát triển bằng Flutter và FireBase cung cấp cho người dùng trải nghiệm mua sắm công nghệ chuyên nghiệp và tiện lợi. Ứng dụng cung cấp nhiều tính năng cho người dùng và quản trị viên để quản lý sản phẩm, tài khoản, đơn hàng và thanh toán.


1. Tính năng
1.1. User
•	Xem sản phẩm: Duyệt các sản phẩm trong ứng dụng.
•	Thêm vào giỏ hàng : Thêm sản phẩm vào giỏ hàng.
•	Đặt hàng: Đặt đơn hàng.
•	Quản lý tài khoản: Tạo tài khoản, đăng nhập và quản lý hồ sơ cá nhân 
•	Khôi phục mật khẩu: Đặt lại mật khẩu qua email khi người dùng quên.
1.2. Admin
•	Quản lí sản phẩm: thêm, sửa, xóa sản phẩm
•	Quản lí đơn hàng: theo dõi đơn hàng

2. Công nghệ sử dụng
2.1. Frontend Libraries
•	Flutter
•	Provider
•	Firebase Authentication
•	Firebase Firestore
•	Firebase Storage
2.2 Backend Libraries
•	Firebase Functions
•	Firebase Authentication
•	Firebase Firestore
•	Firebase Storage
•	Firebase Cloud Messagin




3. Cài đặt
Ứng dụng yêu cầu Flutter SDK và Firebase để chạy
3.1. Yêu cầu hệ thống
•	Flutter SDK: Cài đặt Flutter từ trang chính thức: Flutter SDK.
•	Firebase CLI: Cài đặt Firebase CLI bằng lệnh npm install -g firebase-tools nếu chưa có.
•	Android Studio (hoặc Xcode cho macOS): Để phát triển và chạy ứng dụng trên Android (hoặc iOS).
3.2.  Cấu hình Backend với Firebase
- Tạo 1 dự án Firebase
- Cài đặt Firebase CLI
•	Cài đặt Firebase CLI bằng lệnh: npm install -g firebase-tools
•	Sử dụng lệnh firebase init để thiết lập dự án Firebase của bạn với các dịch vụ Firestore, Functions và Storage.
- Cấu hình biến môi trường
•	FIREBASE_API_KEY
•	FIREBASE_AUTH_DOMAIN
•	FIREBASE_PROJECT_ID
•	FIREBASE_STORAGE_BUCKET
•	FIREBASE_MESSAGING_SENDER_ID
•	FIREBASE_APP_ID
•	CLOUD_FUNCTIONS_URL (URL của Firebase Cloud Functions)
3.3.  Cấu hình Frontend với Flutter
- Cài đặt các phụ thuộc
 
4. Chạy chương trình
- Kết nối thiết bị Android của bạn
- Thêm đoạn mã sau vào tệp main.dart:
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
- Mở terminal và sử dụng lệnh flutter run để chạy ứng dụng



