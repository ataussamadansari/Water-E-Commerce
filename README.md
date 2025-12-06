# Water E-Commerce Flutter Apps

Four complete Flutter applications for Water E-Commerce system using **Dio**, **GetX**, and **dotenv**.

## 🚀 Apps

1. **Admin App** - Manage users, orders, and products (Purple theme)
2. **Customer App** - Browse products and place orders (Blue theme)
3. **Delivery App** - Manage deliveries and update status (Green theme)
4. **Sale App** - Handle sales operations (Orange theme)

## 🔗 API Base URL
```
https://waterapi.varanasiservice.com/api/v1
```

## 📦 Technology Stack
- **Flutter/Dart** - Cross-platform framework
- **GetX** - State management & routing
- **Dio** - HTTP client with interceptors
- **flutter_dotenv** - Environment configuration
- **SharedPreferences** - Token storage

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

For each app (admin, customer, delivery, sale):

1. **Navigate to app directory:**
```bash
cd customer
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

Or select specific device:
```bash
flutter run -d chrome  # For web
flutter run -d android # For Android
flutter run -d ios     # For iOS
```

## 📁 Project Structure

Each app follows this structure:
```
lib/
├── controllers/
│   ├── auth_controller.dart       # Authentication logic
│   └── [app]_controller.dart      # App-specific logic
├── core/
│   └── api_service.dart           # Dio API service with interceptors
├── models/                        # Data models (customer app)
│   ├── order_model.dart
│   └── product_model.dart
├── views/
│   ├── login_page.dart            # Login screen
│   └── home_page.dart             # Main dashboard
├── main.dart                      # App entry point
└── .env                           # Environment variables
```

## 🎯 Features

### Admin App (Purple)
- ✅ User management dashboard
- ✅ Order tracking and management
- ✅ Product inventory management
- ✅ Three-tab interface (Users, Orders, Products)
- ✅ Pull-to-refresh functionality

### Customer App (Blue)
- ✅ View personal orders
- ✅ Browse product catalog
- ✅ Place new orders
- ✅ Two-tab interface (Orders, Products)
- ✅ Grid view for products

### Delivery App (Green)
- ✅ View assigned deliveries
- ✅ Update delivery status (In Transit, Delivered)
- ✅ Real-time status updates
- ✅ Delivery address display
- ✅ Quick action menu

### Sale App (Orange)
- ✅ View sales history
- ✅ Create new sales
- ✅ Product catalog access
- ✅ Two-tab interface (Sales, Products)
- ✅ Sales tracking

## 🔐 Authentication

All apps use **JWT token-based authentication**:
- Login via `/auth/login` endpoint
- Token stored in SharedPreferences
- Automatic token injection via Dio interceptors
- Secure logout with token removal

## 🌐 API Endpoints

### Authentication
- `POST /auth/login` - User login

### Admin
- `GET /admin/users` - Get all users
- `GET /admin/orders` - Get all orders
- `GET /admin/products` - Get all products
- `POST /admin/users` - Create user
- `PUT /admin/orders/:id` - Update order

### Customer
- `GET /customer/orders` - Get customer orders
- `GET /customer/products` - Get products
- `POST /customer/orders` - Create order

### Delivery
- `GET /delivery/orders` - Get assigned deliveries
- `PUT /delivery/orders/:id` - Update delivery status

### Sales
- `GET /sales` - Get all sales
- `GET /sales/products` - Get products
- `POST /sales` - Create sale

## 🔧 Configuration

Each app has a `.env` file:
```env
API_BASE_URL=https://waterapi.varanasiservice.com/api/v1
```

To change the API URL, edit the `.env` file in each app directory.

## 🎨 App Themes

- **Admin**: Deep Purple (`Colors.deepPurple`)
- **Customer**: Blue (`Colors.blue`)
- **Delivery**: Green (`Colors.green`)
- **Sale**: Orange (`Colors.orange`)

## 📱 Running Multiple Apps

You can run all apps simultaneously on different devices:

```bash
# Terminal 1
cd admin && flutter run -d device1

# Terminal 2
cd customer && flutter run -d device2

# Terminal 3
cd delivery && flutter run -d device3

# Terminal 4
cd sale && flutter run -d device4
```

## 🐛 Troubleshooting

**Issue: Dependencies not found**
```bash
flutter clean
flutter pub get
```

**Issue: .env file not loading**
- Ensure `.env` exists in app root
- Check `pubspec.yaml` has `.env` in assets
- Restart the app

**Issue: API connection failed**
- Verify API URL in `.env`
- Check internet connection
- Ensure API server is running

## 📝 Notes

- Each app is independent and can run separately
- API endpoints may need adjustment based on actual API documentation
- Token expires based on backend configuration
- All apps support hot reload for faster development

## 🚀 Next Steps

1. Customize API endpoints based on your backend
2. Add more features (search, filters, notifications)
3. Implement proper error handling
4. Add unit and widget tests
5. Configure app icons and splash screens
6. Set up CI/CD pipeline

## 📄 License

This project is for demonstration purposes.
