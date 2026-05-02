import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class MyAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;
  String? _tempEmail;
  String? _tempPassword;
  String? _errorMessage;

  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;
  String? get errorMessage => _errorMessage;

  // Getter untuk user aktif
  User? get firebaseUser => _auth.currentUser;

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use': return 'Email sudah terdaftar.';
      case 'user-not-found': return 'Akun tidak ditemukan.';
      case 'wrong-password': return 'Password salah.';
      case 'invalid-email': return 'Format email tidak valid.';
      case 'weak-password': return 'Password terlalu lemah.';
      default: return 'Terjadi kesalahan: $code';
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await credential.user?.updateDisplayName(name);
      await credential.user?.sendEmailVerification();
      
      _tempEmail = email;
      _tempPassword = password;
      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user?.emailVerified == false) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }
      return await verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      // TODO: isi integrasi Google Sign-In sesuai kebutuhan
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Gagal login dengan Google");
      return false;
    }
  }

  Future<bool> verifyTokenToBackend() async {
    try {
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError("Gagal verifikasi ke server");
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading();
    try {
      await _auth.signOut();
      _status = AuthStatus.unauthenticated;
      _tempEmail = null;
      _tempPassword = null;
    } catch (e) {
      _setError("Gagal logout");
    }
    notifyListeners();
  }

  // Tambahan untuk verifikasi email
  Future<bool> checkEmailVerified() async {
    try {
      await _auth.currentUser?.reload(); // refresh data user
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      _setError("Gagal cek verifikasi email");
      return false;
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      _setError("Gagal kirim ulang email verifikasi");
    }
  }
}
