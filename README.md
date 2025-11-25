# Jetstream - Flight Logging App

A modern, AI-powered flight logging application built with Flutter. Track your flights, analyze your travel patterns, and get personalized insights using advanced AI technology.

## 🚀 Features

- **AI-Powered Flight Logging**: Use natural language to log flights - just describe your experience and AI extracts all the details
- **Real-time Data Sync**: All flights are stored in Cloud Firestore for seamless access across devices
- **Smart Analytics**: Get real-time statistics including total flights, miles, hours, and airline breakdowns
- **Sentiment Analysis**: Automatically detects sentiment from your flight descriptions
- **Personalized Insights**: AI-generated travel insights based on your flight history
- **Beautiful Modern UI**: Clean, intuitive interface with smooth animations
- **Multiple Auth Methods**: Sign in with Google or Apple
- **Real Distance Calculations**: Accurate flight distances using Haversine formula with 60+ airport coordinates

## 📋 Requirements

- **Flutter**: 3.38.3 or higher
- **Dart**: 3.10.0 or higher
- **Firebase Project** with:
  - Firebase Authentication (Google & Apple Sign-in enabled)
  - Cloud Firestore
- **Google Gemini API Key** for AI features

## 🛠️ Setup Instructions

### 1. Install Flutter

Ensure you have Flutter 3.38.3 or higher installed:

```bash
flutter --version
```

If you need to upgrade:

```bash
flutter upgrade
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd jetstream_new
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Setup

#### Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Add your iOS and Android apps to the Firebase project

#### Enable Authentication

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Google** sign-in
3. Enable **Apple** sign-in (for iOS)

#### Setup Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Start in **Production mode**
4. Deploy the security rules:

```bash
firebase deploy --only firestore:rules
```

The security rules are already configured in `firestore.rules` to ensure users can only access their own data.

#### Deploy Firestore Indexes

```bash
firebase deploy --only firestore:indexes
```

This will create the necessary composite indexes defined in `firestore.indexes.json`.

#### Configure Firebase in Your App

Run the FlutterFire CLI to automatically configure Firebase:

```bash
# Install FlutterFire CLI if you haven't already
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure
```

This will:
- Generate `lib/firebase_options.dart`
- Configure your iOS and Android apps
- Download necessary configuration files

### 5. Google Gemini API Setup

1. Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add it to your app in one of these ways:

   **Option A: Environment Variable (Recommended for production)**
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
   ```

   **Option B: Hardcode (Development only)**
   
   Edit `lib/services/ai_service.dart` and replace `YOUR_API_KEY_HERE` with your actual key:
   ```dart
   apiKey: key.isEmpty ? 'YOUR_ACTUAL_API_KEY' : key,
   ```

   ⚠️ **Important**: Never commit your API key to version control!

### 6. Platform-Specific Setup

#### iOS Setup

1. Open `ios/Runner.xcworkspace` in Xcode
2. Update the bundle identifier
3. Configure signing with your Apple Developer account
4. For Apple Sign-in:
   - Enable "Sign in with Apple" capability in Xcode
   - Configure in [Apple Developer Console](https://developer.apple.com/)

#### Android Setup

1. Update `android/app/build.gradle` with your app details
2. Update `android/app/src/main/AndroidManifest.xml` if needed
3. For Google Sign-in, ensure your SHA-1 certificate is added to Firebase:
   ```bash
   # Get debug SHA-1
   cd android
   ./gradlew signingReport
   ```
   Add the SHA-1 to Firebase Console > Project Settings > Your Android App

### 7. Run the App

```bash
# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android

# Run on Web
flutter run -d chrome

# Run with Gemini API key
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

## 🏗️ Project Structure

```
lib/
├── common_widgets/      # Reusable UI components
├── features/           # Feature-based modules
│   ├── auth/          # Authentication screens
│   ├── home/          # Home screen with stats
│   ├── flight_log/    # Natural language flight logging
│   ├── all_flights/   # Flight list view
│   ├── flight_details/# Individual flight details
│   ├── insights/      # AI-generated insights
│   ├── profile/       # User profile
│   └── settings/      # App settings
├── models/            # Data models
├── routing/           # App navigation (GoRouter)
├── services/          # Business logic
│   ├── ai_service.dart      # Google Gemini AI integration
│   ├── auth_service.dart    # Firebase Authentication
│   └── flight_service.dart  # Flight data & Firestore
└── theme/             # App theming
```

## 🎨 Key Technologies

- **Flutter 3.38.3** - Latest stable Flutter framework
- **Dart 3.10.1** - Latest Dart language
- **Firebase Auth** - Authentication with Google & Apple
- **Cloud Firestore** - Real-time NoSQL database
- **Google Generative AI** - Gemini 1.5 Flash for AI features
- **GoRouter** - Type-safe navigation
- **Provider** - State management
- **Google Fonts** - Beautiful typography
- **Flutter Animate** - Smooth animations

## 📱 Features Overview

### AI-Powered Flight Logging

Simply describe your flight in natural language:

```
"Flew Delta from JFK to LAX yesterday. Amazing crew and comfortable seats!"
```

The AI will automatically extract:
- Airline (Delta)
- Flight route (JFK → LAX)
- Sentiment (positive)
- Tags and highlights
- Estimated rating

### Real Distance & Time Calculations

- Uses Haversine formula for accurate great-circle distances
- Database of 60+ major airport coordinates worldwide
- Calculates actual flight times when available, estimates when not
- Converts distances to miles and duration to hours

### Smart Analytics

- Total flights logged
- Total miles traveled
- Total hours in the air
- Favorite airline (most frequently flown)
- Favorite aircraft type
- Average flight rating
- Airline and aircraft breakdowns

### Personalized Insights

Get AI-generated insights based on your flight history:
- Travel patterns and trends
- Recommendations for future travel
- Experience quality analysis
- Notable statistics

## 🔒 Security

- Firestore security rules ensure users can only access their own data
- Authentication required for all operations
- API keys should be stored securely (not in version control)
- All sensitive data is encrypted in transit and at rest

## 🧪 Testing

Run tests:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

## 🚀 Building for Production

### iOS

```bash
flutter build ios --release --dart-define=GEMINI_API_KEY=your_key
```

### Android

```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=your_key
```

### Web

```bash
flutter build web --release --dart-define=GEMINI_API_KEY=your_key
```

## 📝 Environment Variables

The app supports the following environment variables:

- `GEMINI_API_KEY` - Your Google Gemini API key

Pass them during build/run:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

## 🐛 Troubleshooting

### Firebase Issues

- Ensure `flutterfire configure` was run successfully
- Check that `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are present
- Verify authentication methods are enabled in Firebase Console

### API Key Issues

- Make sure your Gemini API key is valid
- Check API quotas in [Google Cloud Console](https://console.cloud.google.com/)
- Ensure the key is passed correctly via `--dart-define`

### Build Issues

- Run `flutter clean` and `flutter pub get`
- Delete `ios/Pods` and `ios/Podfile.lock`, then run `pod install` in the ios directory
- For Android, try `./gradlew clean` in the android directory

## 📄 License

This project is private and proprietary.

## 🤝 Contributing

This is a private project. For any questions or issues, please contact the development team.

## 📞 Support

For support, please contact: support@jetstream.app

---

Built with ❤️ using Flutter and Firebase
