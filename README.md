# TDiscount Mobile App

A modern Flutter mobile application for Android and iOS devices, designed for the TDiscount marketplace.

## Overview

TDiscount App is a comprehensive e-commerce mobile application that provides users with a seamless shopping experience. The app allows customers to browse products, search through various categories, manage their shopping cart, and complete purchases with ease.

## Features

### 🛍️ Shopping Experience
- **Product Catalog**: Browse through a wide variety of product categories
- **Advanced Search**: Search for specific products with filtering
- **Product Details**: View detailed product information, images, and specifications
- **Related Products**: Discover similar products and recommendations

### 🛒 Cart & Orders
- **Shopping Cart**: Add products to cart with quantity management
- **Price Calculation**: Real-time total price and savings calculation
- **Order Management**: Complete the order process seamlessly

### 🎨 User Interface
- **Modern Design**: Clean and intuitive user interface
- **Dark/Light Theme**: Toggle between light and dark themes
- **Responsive Layout**: Optimized for different screen sizes

### 👤 User Management
- **Authentication**: Secure login and logout functionality
- **Profile Settings**: Manage personal information and preferences
- **language Support**: French language support 

## Technical Stack

- **Framework**: Flutter
- **State Management**: Provider pattern
- **Architecture**: MVVM (Model-View-ViewModel)
- **API Integration**: WooCommerce REST API
- **Local Storage**: SharedPreferences
- **Theme Management**: Dynamic theme switching

## Project Structure

```
lib/
├── models/           # Data models
├── services/         # API services
├── viewModels/       # Business logic
├── views/            # UI screens
└── utils/           # Utilities and constants
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository
```bash
git clone [repository-url]
cd tdiscount_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure environment variables
```bash
# Create .env file and add your WooCommerce credentials
WC_BASE_URL=your_base_url
WC_CONSUMER_KEY=your_consumer_key
WC_CONSUMER_SECRET=your_consumer_secret
```

4. Run the application
```bash
flutter run
```

## Features in Detail

### Product Management
- Fetch products by categories with pagination
- Product caching for improved performance
- Image optimization with unsupported format filtering
- Related products functionality

### Shopping Cart
- Add/remove products from cart
- Quantity management with real-time updates
- Price calculations with discount tracking
- Persistent cart storage

### User Experience
- Smooth navigation with nav bar
- Search functionality with results display
- Theme persistence across app sessions
- Loading states and error handling

## Contributing

This project follows standard Flutter development practices. Please ensure code quality and test coverage when contributing.

## License

This project is developed for TDiscount marketplace. All rights reserved.

## Contact

For support or inquiries, please contact



