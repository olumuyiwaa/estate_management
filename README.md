# 🏡 Estate Management App — Flutter

A full-featured mobile estate management solution built with Flutter.

## 📱 Screens Included

| Screen | Features |
|---|---|
| **Dashboard** | Stats, pinned notices, quick actions, incident preview, payment overview |
| **Members** | Search/filter by role, verified badge, add member sheet, action menu |
| **Finance** | Balance card, bar chart (income), pie chart (expenses), payments list, expense tracker |
| **Security** | Visitor registration, QR pass, access log, entry/exit tracking |
| **Incidents** | Report issue, filter by status, priority colour coding, detailed view |
| **Notices** | Pinned announcements, category badges |
| **Facility Booking** | 6 facilities, booking form, booking history |
| **Marketplace** | Buy/sell items, service listings, seller contact |
| **Vendors** | Approved vendors, ratings, category view |
| **Profile** | Wallet balance, top-up, personal info, settings |

## 🚀 Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0 (https://flutter.dev/docs/get-started/install)
- Dart SDK ≥ 3.0.0 (bundled with Flutter)

### Steps

```bash
# 1. Navigate to the project folder
cd estate_app

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. Build a release APK
flutter build apk --release
```

## 📦 Dependencies

```yaml
fl_chart: ^0.68.0          # Bar and Pie charts
intl: ^0.19.0              # Date/number formatting  
google_fonts: ^6.2.1       # DM Sans + Playfair Display
flutter_animate: ^4.5.0    # Smooth animations
badges: ^3.1.2             # Notification badges
```

## 🎨 Design System

- **Primary:** Deep Navy `#0D1B2A`
- **Accent:** Warm Gold `#C9973A`
- **Typography:** Playfair Display (headings) + DM Sans (body)
- **Corner radius:** 12–20px cards, smooth and modern

## 📁 Project Structure

```
lib/
├── main.dart                 # Entry point + navigation shell
├── theme/
│   └── app_theme.dart        # Colors, typography, component themes
├── models/
│   └── models.dart           # Data models (Member, Payment, Incident…)
├── data/
│   └── dummy_data.dart       # Sample data for all screens
├── widgets/
│   └── widgets.dart          # Shared reusable components
└── screens/
    ├── dashboard_screen.dart
    ├── members_screen.dart
    ├── finance_screen.dart
    ├── security_screen.dart
    ├── incidents_screen.dart
    └── more_screens.dart     # Notices, Facilities, Marketplace, Vendors, Profile
```

## 🔧 Next Steps (Production)

1. **Backend** — Connect to your Node.js/Express API
2. **Auth** — Add login screen with JWT / Firebase Auth
3. **Real payments** — Integrate Paystack or Flutterwave (Nigerian market)
4. **Push notifications** — Firebase Cloud Messaging
5. **Biometrics** — `local_auth` package for verification
6. **Camera** — `image_picker` for incident photos and KYC docs
7. **QR code** — `qr_flutter` + `mobile_scanner` for gate passes
8. **Chat** — Firebase Realtime DB or Stream Chat SDK
9. **Calendar sync** — `add_2_calendar` for meeting scheduler
