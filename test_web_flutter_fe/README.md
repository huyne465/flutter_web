# Flutter Web Frontend

## 🚀 Technologies Used

### Core Framework
- **Flutter** (3.8.0+) - Cross-platform UI framework
- **Dart** - Programming language
- **Web Platform** - Compiled to JavaScript for web deployment

### State Management
- **GetX** (4.7.2) - Reactive state management
  - `GetxController` for ViewModels
  - `Obx` for reactive UI updates
  - Named routing with bindings

### Architecture
- **MVVM Pattern** - Model-View-ViewModel architecture
- **Clean Architecture** - Separation of concerns with layers
- **Injectable** - Code generation for dependency injection

### Dependency Injection
- **GetIt** - Service locator pattern
- **Injectable** - Automatic DI code generation with annotations
- Lazy singleton registration for services

### HTTP & API
- **Dio** - HTTP client for REST API calls
- **Retrofit** - Type-safe HTTP client generation
- **Alice** - HTTP inspector for debugging

### UI & Responsive Design
- **Flutter ScreenUtil** - Screen adaptation and responsive design
- **Easy Localization** - Internationalization support
- **EasyLoading** - Loading states and progress indicators

### Storage & Data
- **SharedPreferences** - Local key-value storage
- **dart_jsonwebtoken** - JWT token handling

## 🛠 Key Features

- **Reactive UI** with GetX Obx widgets
- **Form Validation** with real-time feedback
- **JWT Authentication** with secure token handling
- **Error Handling** with user-friendly snackbars
- **Loading States** with EasyLoading integration
- **Responsive Design** adapted for web platform
- **Clean API Layer** with repository pattern
