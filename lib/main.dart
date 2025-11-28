import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/carrito_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseOk = true;
  String firebaseError = '';

  try {
    print('🔍 Iniciando Firebase...');
    print('📱 Plataforma web: ${kIsWeb}');

    // Verificar si Firebase ya está inicializado
    if (Firebase.apps.isEmpty) {
      print('📦 Intentando inicializar Firebase...');
      print('⚙️ Opciones: ${DefaultFirebaseOptions.currentPlatform}');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase inicializado correctamente');
    } else {
      print('ℹ️ Firebase ya estaba inicializado');
    }
  } catch (e, st) {
    firebaseOk = false;
    firebaseError = e.toString();
    print('❌ Error al inicializar Firebase: $e');
    print('📍 Stack trace: $st');
  }

  runApp(MyApp(firebaseOk: firebaseOk, firebaseInitError: firebaseError));
}

class MyApp extends StatelessWidget {
  final bool firebaseOk;
  final String firebaseInitError;

  const MyApp({super.key, this.firebaseOk = true, this.firebaseInitError = ''});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'TernoFit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        home: Builder(builder: (context) {
          if (!firebaseOk) {
            // Mostrar pantalla de error clara para ayudar a diagnosticar en web
            return Scaffold(
              appBar: AppBar(title: const Text('Error de inicialización')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No se pudo inicializar Firebase.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Problema: lib/firebase_options.dart tiene valores VACÍOS.\n\nSolución:\n1. Ejecuta: dart pub global activate flutterfire_cli\n2. Luego: flutterfire configure\n3. Reconstruye: flutter build web --release\n4. Recarga esta página',
                    ),
                    const SizedBox(height: 12),
                    Text('Error técnico: $firebaseInitError',
                        style: const TextStyle(
                            fontSize: 11, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Instrucciones cortas para el usuario
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('¿Qué hacer?'),
                            content: const Text(
                                'Ejecuta `flutter build web` y sirve la carpeta `build/web`, o usa `flutterfire configure` para generar `lib/firebase_options.dart` con la configuración de tu proyecto Firebase.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar')),
                            ],
                          ),
                        );
                      },
                      child: const Text('Cómo solucionarlo'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated) {
                // ✅ VERIFICAR SI ES ADMIN
                final email = authProvider.usuario?.email ?? '';

                if (email == 'admi@gmail.com') {
                  print('👑 Admin detectado, mostrando AdminHomeScreen');
                  return const AdminHomeScreen();
                } else {
                  print('🏠 Cliente autenticado, mostrando MainScreen');
                  return const MainScreen();
                }
              } else {
                print('🔐 Usuario no autenticado, mostrando LoginScreen');
                return const LoginScreen();
              }
            },
          );
        }),
      ),
    );
  }
}
