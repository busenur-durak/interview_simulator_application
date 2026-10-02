# Interview Simulator

A Flutter interview coach. You pick a field and a level, answer questions from an AI interviewer, and receive an evaluation at the end.

The interview engine keeps phase, topic, and conversation memory separate from the screen. Sectors in the app include technology, IT, finance, business, marketing, and services. The interface is localized in Turkish and English. Accounts and interview data go through Firebase Authentication and Cloud Firestore.

This was built as a graduation-course project.

## Stack

Flutter, Dart, Provider, Firebase Auth, Cloud Firestore, Firebase Remote Config

## Run

```bash
flutter pub get
flutter run
```

Add your own Firebase configuration before running. `firebase_options.dart` is part of the project and should point at your Firebase app.

## Author

Busenur Durak · Management Information Systems, İzmir Bakırçay University
