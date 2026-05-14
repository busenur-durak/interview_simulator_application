import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _user?.isGuest ?? true;
  bool get isLoggedIn => _user != null;
  String? get errorMessage => _errorMessage;

  /// Check if there's an already signed-in Firebase user
  void checkCurrentUser() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _user = currentUser;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signUpWithEmail(email, password, displayName);
      // Save user profile to Firestore
      await _firestoreService.saveUser(_user!);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void continueAsGuest() {
    _user = _authService.continueAsGuest();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Maps a Firebase error code to a localization key.
  /// Translate in the UI via `t(context, key)`.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'authErrorUserNotFound';
      case 'wrong-password':
      case 'invalid-credential':
        return 'authErrorInvalidCredential';
      case 'email-already-in-use':
        return 'authErrorEmailInUse';
      case 'weak-password':
        return 'authErrorWeakPassword';
      case 'invalid-email':
        return 'authErrorInvalidEmail';
      case 'too-many-requests':
        return 'authErrorTooManyRequests';
      case 'network-request-failed':
        return 'authErrorNetwork';
      default:
        return 'authErrorGeneral';
    }
  }
}
