# SmartAC - Flutter App

> AI-Powered Accounting Platform  

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-teal)](https://dart.dev)
[![iOS](https://img.shields.io/badge/iOS-16+-black)](https://apple.com)
[![Android](https://img.shields.io/badge/Android-8+-green)](https://android.com)
[![Web](https://img.shields.io/badge/Web-AWS_S3-orange)](https://aws.amazon.com)

---

## Live Demo

👉 Web: **http://smartac-frontend-1775237755.s3-website.eu-west-2.amazonaws.com**
👉 Android: **https://appdistribution.firebase.dev/i/6c2309e7959899a4**
👉 iOS: **Coming soon, app is in review by app-store**

---

## What is SmartAC?

SmartAC is a cross-platform Flutter application (iOS, Android, Web) that provides an interface to an AI-powered accounting backend. It allows accountants to analyse transactions, detect anomalies, run AI agents, and generate reports.

---

## Screens

| Screen | Description |
|---|---|
| Dashboard | Stats, risk distribution chart, recent transactions |
| Transactions | Full list with risk labels, anomaly flags, fuzzy scores |
| Orchestrator | Run the full AI agent cycle with one tap |
| Documents | View all AI-generated letters and reports |
| Audit Log | GDPR-compliant trail of every AI decision |

---

**Design pattern:** BLoC/Cubit - every screen has a Cubit managing state, a repository handling API calls, and DTOs for type-safe data transfer.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x / Dart 3.x |
| State Management | flutter_bloc (Cubit) |
| Dependency Injection | get_it + injectable |
| HTTP Client | Dio |
| JSON Serialisation | json_serializable + json_annotation |
| Code Generation | build_runner |
| Charts | fl_chart (donut chart) |
| Icons | Material Icons |

---

## Local Setup

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Xcode (for iOS)
- Android Studio (for Android)
- AWS CLI (for web deployment)

### Run locally

```bash
# 1. Clone and enter project
cd smart_ac_frontend

# 2. Install dependencies
make get

# 3. Generate code (DTOs, DI)
make gen

# 4. Run on desired platform
flutter run                        # connected device
flutter run -d chrome              # web browser
flutter run -d ios                 # iOS simulator
flutter run -d android             # Android emulator
```

### Backend URL

Update in your network config:
Inside DioHandler, set:

```dart
baseUrl: 'http://11.111.111.111:8000/',
```

---

## Build & Deploy

### iOS

```bash
flutter build ios --release
# Open Xcode → Product → Archive → Distribute
```

### Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Web (AWS S3)

```bash
flutter build web --release

aws s3 sync build/web s3://smartac-frontend-0000000000 \
    --delete \
    --cache-control "max-age=00000000" \
    --exclude "index.html"

aws s3 cp build/web/index.html s3://smartac-frontend-0000000000/index.html \
    --cache-control "no-cache"
```

---

---

---

## Platforms

| Platform | Status | Distribution |
|---|---|---|
| Web | ✅ Live | AWS S3 |
| Android | ✅ Built | Firebase App Distribution |
| iOS | 🔄 In progress | App Store / TestFlight |

---