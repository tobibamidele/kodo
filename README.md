# Kodo

Kodo is a real-time chat application built with **Flutter** and **Firebase**.  
It supports live messaging, message reactions, editing, and persistent chat state across sessions.

This repository contains **only application code**. Firebase configuration is intentionally excluded.

---

## Features

- Real-time messaging (Firestore + Streams)
- Message reactions
- Persistent local caching
- Firebase Authentication
- Cross-platform (Android, iOS)

---

## Tech Stack

- **Flutter**
- **Firebase**
  - Authentication
  - Cloud Firestore
  - Cloud Storage
- **FlutterFire CLI**
- **Riverpod** (state management)

---

## Project Setup

### Prerequisites

- Flutter SDK installed
- Firebase account
- FlutterFire CLI installed

```sh
dart pub global activate flutterfire_cli
````

---

## Firebase Setup (Required)

This project does **not** include Firebase credentials.

### 1. Create a Firebase project

* Go to [https://console.firebase.google.com](https://console.firebase.google.com)
* Create a new project

### 2. Register apps

Register the platforms you plan to use (Android / iOS).

### 3. Generate Firebase config

From the project root:

```sh
flutterfire configure
```

This will generate:

* `android/app/google-services.json`
* `ios/Runner/GoogleService-Info.plist`
* `lib/firebase_options.dart`

⚠️ **Do not commit these files**.

---

## Example Config Files

Example (safe) files are provided:

* `android/app/google-services.example.json`
* `lib/firebase_options.example.dart`

Rename and replace them with your generated files locally.

---

## Running the App

```sh
flutter pub get
flutter run
```

---
