import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _dummyDomain = '@ayamdepresi.com';

  /// Mendapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  /// Stream untuk memantau perubahan status login (login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Konversi username menjadi format email dummy untuk Firebase Auth
  String _toDummyEmail(String username) {
    // Hilangkan spasi dan ubah ke huruf kecil
    final cleanUsername = username.replaceAll(' ', '').toLowerCase();
    return '$cleanUsername$_dummyDomain';
  }

  /// Login menggunakan username dan password
  Future<UserCredential> login({
    required String username,
    required String password,
  }) async {
    try {
      final email = _toDummyEmail(username);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
         throw Exception('Username atau password salah.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat login.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Register user baru, lalu simpan datanya ke Firestore
  Future<UserCredential> register({
    required String username,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final email = _toDummyEmail(username);
      
      // 1. Buat user di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // 2. Simpan data tambahan ke Firestore (koleksi Users)
        await _firestore.collection('Users').doc(user.uid).set({
          'userId': user.uid,
          'username': username,
          'nama': name,
          'noWA': phone,
          'lantai': 0, // default dummy
          'noKamar': '', // default dummy
          'poinMember': 0,
          'totalOrder': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Username sudah digunakan oleh beban lain.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat mendaftar.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
