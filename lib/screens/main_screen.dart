import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'autores_screen.dart';
import 'categorias_tab.dart';
import 'equipe_tab.dart';
import 'guias_tab.dart';
import 'home_tab.dart';
import 'links_screen.dart';
import 'perfil_screen.dart';
import 'projetos_etapas_tab.dart';
import 'sobre_screen.dart';

/// Equivalente a MainActivity / activity_main.xml: Toolbar + DrawerLayout
/// (nav_header.xml + drawer_menu.xml) + BottomNavigationView (bottom_nav_menu.xml).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indiceAtual = 0;
  final _authService = AuthService();

  static const _titulos = ['Home', 'Categorias', 'Projetos e Etapas', 'Guias', 'Equipe'];

  final _abas = const [
    HomeTab(),
    CategoriasTab(),
    ProjetosEtapasTab(),
    GuiasTab(),
    EquipeTab(),
  ];

  Future<void> _confirmarLogout() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  void _irPara(int indice) {
    Navigator.of(context).pop(); // fecha o drawer
    setState(() => _indiceAtual = indice);
  }

  void _abrirTela(Widget tela) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indiceAtual])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Equivalente a nav_header.xml
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.verde,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/bg.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (_, __, ___) =>
                          const FlutterLogo(size: 60),
                    ),
                    const SizedBox(height: 8),
                    const Text('FisioDesk 1.0',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => _irPara(0),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o APP'),
              onTap: () => _abrirTela(const SobreScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: const Text('Sobre os Autores'),
              onTap: () => _abrirTela(const AutoresScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Links Úteis'),
              onTap: () => _abrirTela(const LinksScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Perfil do Usuário'),
              onTap: () => _abrirTela(const PerfilScreen()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.vermelho),
              title: const Text('Sair', style: TextStyle(color: AppColors.vermelho)),
              onTap: () {
                Navigator.of(context).pop();
                _confirmarLogout();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _indiceAtual, children: _abas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (i) => setState(() => _indiceAtual = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Categorias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: 'Projetos'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Guias'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Equipe'),
        ],
      ),
    );
  }
}
