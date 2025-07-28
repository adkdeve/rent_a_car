## Rent A Car Project

A cross-platform (Android, iOS, Web, Desktop) Flutter application for browsing, booking, and managing car rentals, powered by Firebase (Authentication, Firestore, Messaging) and styled with Provider for state management.

---

### 🚀 Features

- 📱 Multi-platform support (Android, iOS, Web, macOS, Linux, Windows)
- 🔐 Email/password authentication & profile management
- 🚗 Browse featured and recommended cars, filter by brand/type
- ❤️ Add/remove favorites, view detailed car info
- 📆 Full booking flow with date & time pickers
- 🔔 Push notifications for booking status
- 💬 In-app chat between user and owner
- 🌙 Light & dark themes

---

### 🏗️ Architecture & Project Layout

```
rent_a_car_project/
│
├─ android/            # Android platform code
├─ ios/                # iOS platform code
├─ linux/              # Linux desktop support
├─ macos/              # macOS desktop support
├─ web/                # Web support
├─ windows/            # Windows desktop support
│
├─ assets/             # Images, Lottie animations, etc.
│   ├─ avatar.jpg
│   ├─ category_default.png
│   └─ success_checkmark.json
│
├─ lib/                # Dart source code
│   ├─ main.dart       # App entrypoint: initializes Firebase & Providers
│   │
│   ├─ globalContent.dart  
│   │   • `GlobalConfig` (app-wide state)  
│   │   • `FavoriteManager` (singleton favorite list manager)  
│   │   • `FavoriteButton` widget
│   │
│   ├─ carModel/        # Domain layer
│   │   ├─ Car.dart     # `Car` data class & serializers
│   │   └─ CarRepository.dart  # Firestore data access
│   │
│   ├─ providers/       # State-management (ChangeNotifier)
│   │   ├─ CarProvider.dart  
│   │   ├─ CategoriesProvider.dart  
│   │   └─ NotificationProvider.dart  
│   │
│   ├─ Screen/          # UI layer: all screens, grouped by feature
│   │   ├─ SplashScreen/  
│   │   ├─ Auth | Profile/  
│   │   ├─ HomeScreenContent.dart  
│   │   ├─ FeaturedCarScreen.dart  
│   │   ├─ Search/  
│   │   ├─ Categories/  
│   │   ├─ BookingProcessScreen.dart  
│   │   ├─ BookingDetailsScreen.dart  
│   │   └─ …more…
│   │
│   └─ Widgets/         # Reusable UI components
│       ├─ rounded_input_field.dart  
│       ├─ alert_service.dart  
│       └─ date_utils.dart  
│
├─ test/               # Unit & widget tests
│
├─ pubspec.yaml        # Dependencies & assets
├─ pubspec.lock
└─ .gitignore
```

---

### ⚙️ Getting Started

#### Prerequisites

- [Flutter SDK ≥ 3.10](https://flutter.dev/docs/get-started/install)
- [Dart SDK ≥ 3.5](https://dart.dev/get-dart)
- Firebase project with **Authentication**, **Cloud Firestore**, and **Cloud Messaging** enabled.

#### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/<your-username>/rent_a_car_project.git
   cd rent_a_car_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
    - **Android:** place your `google-services.json` under `android/app/`
    - **iOS/macOS:** place `GoogleService-Info.plist` under `ios/Runner/` and `macos/Runner/`
    - **Web:** update `index.html` per [Firebase Web setup](https://firebase.google.com/docs/web/setup)

4. **Run on device or emulator**
   ```bash
   flutter run
   ```

---

### 💡 Usage

- On first launch, you’ll see a splash screen & onboarding flow.
- Sign up or log in; you’ll land on the home screen showing featured cars.
- Browse, search, apply filters, and tap a car to view details.
- Tap **Book Now** to select dates & confirm reservations.
- Mark as favorite with the ❤️ icon, and view all favorites later.
- Use the chat screen to message car owners directly.

---

### 🛠️ Technology Stack

- **Flutter** / Dart
- **Firebase**:
    - Authentication
    - Cloud Firestore (data storage)
    - Cloud Messaging (push notifications)
- **Provider** for state management
- **Third-party packages**:
    - `smooth_page_indicator`
    - `flashy_tab_bar2`
    - `swipeable_card_stack`
    - `path_provider`
    - `lottie`
    - …and more (see `pubspec.yaml`)

---

### 🎯 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/YourFeature`
5. Open a Pull Request

Please follow the existing code style and include relevant tests.

---

### 📄 License

This project is licensed under the [MIT License](LICENSE).


---

✉️ Questions? Contact [alee0066.aka@gmail.com] or open an issue.