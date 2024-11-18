# finalterm


TECH ZONE
Tech Zone là nền tảng thương mại điện tử hiện đại, được phát triển bằng Flutter và FireBase cung cấp cho người dùng trải nghiệm mua sắm công nghệ chuyên nghiệp và tiện lợi. Ứng dụng cung cấp nhiều tính năng cho người dùng và quản trị viên để quản lý sản phẩm, tài khoản, đơn hàng và thanh toán.


1. Tính năng
- User
•	Xem sản phẩm: Duyệt các sản phẩm trong ứng dụng.

![image](https://github.com/user-attachments/assets/69099d67-0e17-491c-a441-2bb963b235a4)

•	Thêm vào giỏ hàng : Thêm sản phẩm vào giỏ hàng.

![image](https://github.com/user-attachments/assets/6906ed7c-7160-4b17-a059-5890f0c8ac7a)

•	Đặt hàng: Đặt đơn hàng.

![image](https://github.com/user-attachments/assets/fa201129-90e5-4fe3-a4b7-3a397b5daac5)

•	Quản lý tài khoản: Tạo tài khoản, đăng nhập và quản lý hồ sơ cá nhân 

![image](https://github.com/user-attachments/assets/5be3239e-afcd-4c8e-85f0-0e39834ad417)

•	Khôi phục mật khẩu: Đặt lại mật khẩu qua email khi người dùng quên.
- Admin
•	Quản lí sản phẩm: thêm, sửa, xóa sản phẩm

![image](https://github.com/user-attachments/assets/22fbe56d-1cb5-48f4-a0b4-ea9a0f06dfa7)

•	Quản lí đơn hàng: theo dõi đơn hàng

![image](https://github.com/user-attachments/assets/c618d057-d1d0-41f6-820c-9125ea44001b)


2. Công nghệ sử dụng
- Frontend Libraries
•	Flutter
•	Provider
•	Firebase Authentication
•	Firebase Firestore
•	Firebase Storage
- Backend Libraries
•	Firebase Functions
•	Firebase Authentication
•	Firebase Firestore
•	Firebase Storage
•	Firebase Cloud Messagin




3. Cài đặt
   
Ứng dụng yêu cầu Flutter SDK và Firebase để chạy

- Yêu cầu hệ thống
•	Flutter SDK: Cài đặt Flutter từ trang chính thức: Flutter SDK.
•	Firebase CLI: Cài đặt Firebase CLI bằng lệnh npm install -g firebase-tools nếu chưa có.
•	Android Studio (hoặc Xcode cho macOS): Để phát triển và chạy ứng dụng trên Android (hoặc iOS).
- Cấu hình Backend với Firebase
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
- Cấu hình Frontend với Flutter
  

- Cài đặt các phụ thuộc

   ![image](https://github.com/user-attachments/assets/59763ce5-5ac7-4c86-8aa2-9770188662d7)

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



