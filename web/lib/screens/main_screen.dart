import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'mis_reservas_screen.dart';
import 'perfil_screen.dart';
import 'admin/admin_reservas_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verificarRol();
  }

  // ✅ Verificar si es admin por email
  Future<void> _verificarRol() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.usuario?.email;

    print('🔍 Email del usuario: $email');

    if (email == null) {
      print('❌ No hay email');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // ✅ ADMIN: Detectar por email específico
    setState(() {
      _isAdmin = email == 'admi@gmail.com'; // ← Solo este email es admin
      _isLoading = false;
    });

    print('✅ Es admin: $_isAdmin');
  }

  // ✅ Pantallas según el rol (SIN const)
  List<Widget> get _screens {
    if (_isAdmin) {
      return [
        const HomeScreen(),
        const AdminReservasScreen(), // ← Panel Admin
        const PerfilScreen(), // ← Sin const porque usa Provider/StreamBuilder
      ];
    } else {
      return [
        const HomeScreen(),
        const MisReservasScreen(), // ← Mis Reservas (cliente)
        const PerfilScreen(), // ← Sin const porque usa Provider/StreamBuilder
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras verifica el rol
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          backgroundColor: Colors.white,
          elevation: 0,
          items: _isAdmin
              ? const [
                  // ✅ NAVEGACIÓN PARA ADMIN
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 28),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: 'Inicio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined, size: 28),
                    activeIcon: Icon(Icons.dashboard, size: 28),
                    label: 'Panel Admin',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 28),
                    activeIcon: Icon(Icons.person, size: 28),
                    label: 'Perfil',
                  ),
                ]
              : const [
                  // ✅ NAVEGACIÓN PARA CLIENTE
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 28),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: 'Inicio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined, size: 28),
                    activeIcon: Icon(Icons.receipt_long, size: 28),
                    label: 'Mis Reservas',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 28),
                    activeIcon: Icon(Icons.person, size: 28),
                    label: 'Perfil',
                  ),
                ],
        ),
      ),
    );
  }
}
