import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Usuario? _usuario;
  bool _isLoading = false;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _usuario != null;

  // ✅ NUEVO: Getter para verificar si es admin
  bool get esAdmin {
    if (_usuario == null) return false;
    return _usuario!.email == 'admi@gmail.com';
  }

  AuthProvider() {
    print('🔧 Inicializando AuthProvider');
    // Escuchar cambios en el estado de autenticación
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print('🔔 authStateChanges: Usuario detectado ${user.uid}');
        _cargarUsuario(user.uid);
      } else {
        print('🔔 authStateChanges: Sin usuario');
        _usuario = null;
        notifyListeners();
      }
    });
  }

  Future<void> _cargarUsuario(String uid) async {
    try {
      print('📥 Cargando usuario desde Firestore: $uid');

      final doc = await _firestore.collection('registro').doc(uid).get();

      print('📄 Documento existe: ${doc.exists}');

      if (doc.exists) {
        final data = doc.data()!;
        print('📦 Datos del documento: $data');

        _usuario = Usuario.fromMap({
          ...data,
          'uid': uid,
        });

        print('✅ Usuario cargado: ${_usuario?.nombre}');
        print('✅ Email: ${_usuario?.email}');
        print('✅ DNI: ${_usuario?.dni}');
        print('👑 Es Admin: $esAdmin'); // ✅ NUEVO: Log para debug

        notifyListeners();
      } else {
        print('❌ Documento de usuario NO existe en Firestore para UID: $uid');
        _usuario = null;
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error al cargar usuario: $e');
      _usuario = null;
      notifyListeners();
    }
  }

  Future<String?> registrar({
    required String email,
    required String password,
    required String nombre,
    required String dni,
    required String telefono,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('📝 Iniciando registro...');
      print('   Email: $email');
      print('   Nombre: $nombre');

      // 1. Crear usuario en Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Usuario creado en Authentication: ${credential.user!.uid}');

      // 2. Crear objeto Usuario
      final usuario = Usuario(
        uid: credential.user!.uid,
        email: email,
        nombre: nombre,
        dni: dni,
        telefono: telefono,
      );

      // 3. Guardar en Firestore
      await _firestore
          .collection('registro')
          .doc(credential.user!.uid)
          .set(usuario.toMap());

      print('✅ Datos guardados en Firestore');
      print('📦 Datos: ${usuario.toMap()}');

      // 4. Cargar el usuario
      _usuario = usuario;
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      print('❌ Error de Firebase Auth: ${e.code}');

      switch (e.code) {
        case 'weak-password':
          return 'La contraseña es muy débil';
        case 'email-already-in-use':
          return 'Este email ya está registrado';
        case 'invalid-email':
          return 'Email inválido';
        default:
          return 'Error al registrar: ${e.message}';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('❌ Error inesperado: $e');
      return 'Error inesperado: $e';
    }
  }

  Future<String?> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('🔐 Iniciando sesión...');
      print('   Email: $email');

      // Iniciar sesión con Firebase Authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Inicio de sesión exitoso');
      print('   UID: ${userCredential.user!.uid}');

      // FORZAR la carga del usuario inmediatamente
      await _cargarUsuario(userCredential.user!.uid);

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      print('❌ Error de Firebase Auth: ${e.code}');

      switch (e.code) {
        case 'user-not-found':
          return 'Usuario no encontrado';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'invalid-email':
          return 'Email inválido';
        case 'invalid-credential':
          return 'Email o contraseña incorrectos';
        default:
          return 'Error al iniciar sesión: ${e.message}';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('❌ Error inesperado: $e');
      return 'Error inesperado: $e';
    }
  }

  Future<void> cerrarSesion() async {
    print('🚪 Cerrando sesión...');
    await _auth.signOut();
    _usuario = null;
    notifyListeners();
    print('✅ Sesión cerrada');
  }
}
