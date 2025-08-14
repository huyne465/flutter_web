# 🚀 Node.js Express MongoDB Authentication API

## 🛠️ Công nghệ sử dụng

### Backend Framework & Runtime
- **Node.js** - JavaScript runtime môi trường server
- **Express.js 5.1.0** - Web framework cho Node.js
- **Babel** - Transpiler hỗ trợ ES6+ và module imports
- **Bun** - sử dụng bun thay cho npm để tối ưu tốc độ

### Database & ODM
- **MongoDB** - NoSQL database
- **Mongoose 8.17.0** - Object Document Mapper cho MongoDB

### Authentication & Security
- **bcryptjs 3.0.2** - Mã hóa mật khẩu
- **Joi** - Validation schema cho dữ liệu đầu vào

### Development Tools
- **Nodemon 3.1.10** - Auto-restart server khi có thay đổi
- **ESLint 8.47.0** - Code linting và formatting
- **CORS** - Cross-Origin Resource Sharing

### Environment & Configuration
- **dotenv 17.2.1** - Quản lý biến môi trường

## ✨ Tính năng chính

### 🔐 Authentication System
- **Đăng ký tài khoản** - Tạo tài khoản mới với validation
- **Đăng nhập** - Xác thực người dùng
- **Mã hóa mật khẩu** - Sử dụng bcrypt hash
- **Validation dữ liệu** - Kiểm tra tính hợp lệ của input

### 👤 User Management
- **Tạo user mới** - API tạo người dùng
- **Lấy danh sách users** - API lấy tất cả người dùng
- **Lấy thông tin user theo ID** - API lấy chi tiết người dùng
- **Kiểm tra duplicate** - Tránh trùng lặp username/email

### 🔒 Security Features
- **Password hashing** - Mật khẩu được mã hóa an toàn
- **Input validation** - Validation với Joi schema
- **Error handling** - Xử lý lỗi toàn diện
- **CORS configuration** - Cấu hình cross-origin requests
