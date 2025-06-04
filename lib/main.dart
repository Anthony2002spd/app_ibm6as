/*  ==============================================================
    Ibm6aphp – Registro de Datos (main.dart)
    App completa con todas las páginas y el rediseño de SexoPage
    Compatible con Flutter 3.32 (Material 3 activado)
    ============================================================== */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* ─────────────────────────────────────────────  APP ROOT  ───── */
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ibm6aphp App',
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
    ),
    debugShowCheckedModeBanner: false,
    home: const MainScreen(),
  );
}

/* ─────────────────────────────────────────────  MAIN SCREEN  ── */
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final _pages = const [
    SexoPage(),
    TelefonoPage(),
    PersonaPage(),
    EstadocivilPage(),
    DireccionPage(),
    Placeholder(), // Acerca de
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ibm6aphp • Registro')),
    body: _pages[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sexo'),
        BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Teléfono'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Persona'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Estado Civil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Dirección',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Acerca de'),
      ],
    ),
  );
}

/* ───────────────────────────────────────────  MODELOS DE DATOS  */
class Sexo {
  final String idsexo, nombre;
  Sexo({required this.idsexo, required this.nombre});
  factory Sexo.fromJson(Map<String, dynamic> j) =>
      Sexo(idsexo: j['idsexo'].toString(), nombre: j['nombre']);
}

class Telefono {
  final String idtelefono, numero;
  Telefono({required this.idtelefono, required this.numero});
  factory Telefono.fromJson(Map<String, dynamic> j) =>
      Telefono(idtelefono: j['idtelefono'].toString(), numero: j['numero']);
}

class Estadocivil {
  final String idestadocivil, nombre;
  Estadocivil({required this.idestadocivil, required this.nombre});
  factory Estadocivil.fromJson(Map<String, dynamic> j) => Estadocivil(
    idestadocivil: j['idestadocivil'].toString(),
    nombre: j['nombre'],
  );
}

class Direccion {
  final String iddireccion, calleprincipal, callesecundaria, numerocasa, persona_nombres, persona_apellidos, nombre;
  Direccion({
    required this.iddireccion,
    required this.calleprincipal,
    required this.callesecundaria,
    required this.numerocasa,
    required this.persona_nombres,
    required this.persona_apellidos,
    required this.nombre,
  });
  factory Direccion.fromJson(Map<String, dynamic> j) => Direccion(
    iddireccion: j['iddireccion'].toString(),
    calleprincipal: j['calleprincipal'] ?? 'N/A',
    callesecundaria: j['callesecundaria'] ?? 'N/A',
    numerocasa: j['numerocasa'] ?? 'N/A',
    persona_nombres: j['persona_nombres'] ?? 'N/A',
    persona_apellidos: j['persona_apellidos'] ?? 'N/A',
    nombre: j['nombre'] ?? 'N/A',
  );
}

class Persona {
  final String idpersona,
      nombres,
      apellidos,
      elsexo,
      elestadocivil,
      fechanacimiento;
  Persona({
    required this.idpersona,
    required this.nombres,
    required this.apellidos,
    required this.elsexo,
    required this.elestadocivil,
    required this.fechanacimiento,
  });
  factory Persona.fromJson(Map<String, dynamic> j) => Persona(
    idpersona: j['idpersona'].toString(),
    nombres: j['nombres'] ?? 'N/A',
    apellidos: j['apellidos'] ?? 'N/A',
    elsexo: j['elsexo'] ?? 'N/A',
    elestadocivil: j['elestadocivil'] ?? 'N/A',
    fechanacimiento: j['fechanacimiento'] ?? 'N/A',
  );
}

/* ───────────────────────────────────────────────  SEXO PAGE  ── */
class SexoPage extends StatefulWidget {
  const SexoPage({Key? key}) : super(key: key);

  @override
  State<SexoPage> createState() => _SexoPageState();
}

class _SexoPageState extends State<SexoPage> with SingleTickerProviderStateMixin {
  List<Sexo> _all = [];
  List<Sexo> _filtered = [];
  bool _loading = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _fetch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/SexoController.php?action=api',
        ),
      );
      if (response.statusCode == 200) {
        final data = (json.decode(response.body) as List)
            .map((e) => Sexo.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
        _animController.forward(from: 0.0);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Sexo: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((s) {
        final nombreLower = s.nombre.toLowerCase();
        final idLower = s.idsexo.toLowerCase();
        return nombreLower.contains(q) || idLower.contains(q);
      }).toList();
      _animController.reset();
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Sexos'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.03),
              theme.colorScheme.surfaceVariant.withOpacity(0.09),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetch,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o ID...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cargando datos...',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const _EmptyState() 
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                return _SexoCardModern(sexo: _filtered[i]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _all.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _filtered = _all;
                  _animController.reset();
                  _animController.forward();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.clear_all),
              tooltip: 'Restablecer búsqueda',
            )
          : null,
    );
  }
}

class _SexoCardModern extends StatelessWidget {
  const _SexoCardModern({Key? key, required this.sexo}) : super(key: key);
  final Sexo sexo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Seleccionaste: ${sexo.nombre} (ID: ${sexo.idsexo})'),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.2),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.people, color: theme.colorScheme.onPrimary, size: 28),
            ),
            title: Text(
              sexo.nombre,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onBackground),
            ),
            subtitle: Text(
              'ID: ${sexo.idsexo}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
/* ─────────────────────────  WIDGET ESTADO VACÍO  ────────────── */
class _EmptyState extends StatelessWidget {
  /// Mensaje que se mostrará.  Si no se envía, usa un texto genérico.
  const _EmptyState({this.msg = 'No hay datos'});

  final String msg;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 72, color: Colors.grey),
            const SizedBox(height: 12),
            Text(msg),
          ],
        ),
      );
}

/* ───────────────────────────────────────────  TELÉFONO PAGE  ── */
class TelefonoPage extends StatefulWidget {
  const TelefonoPage({Key? key}) : super(key: key);

  @override
  State<TelefonoPage> createState() => _TelefonoPageState();
}

class _TelefonoPageState extends State<TelefonoPage> with SingleTickerProviderStateMixin {
  List<Telefono> _all = [];
  List<Telefono> _filtered = [];
  bool _loading = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _fetch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://educaysoft.org/Ibm6aphp/app/controllers/TelefonoController.php?action=api',
      ));
      if (response.statusCode == 200) {
        final data = (json.decode(response.body) as List)
            .map((e) => Telefono.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
        _animController.forward(from: 0.0);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Teléfono: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((t) {
        final numLower = t.numero.toLowerCase();
        final idLower = t.idtelefono.toLowerCase();
        return numLower.contains(q) || idLower.contains(q);
      }).toList();
      _animController.reset();
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Teléfonos'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.03),
              theme.colorScheme.surfaceVariant.withOpacity(0.09),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetch,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por número o ID...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cargando datos...',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const _EmptyState(msg: 'No hay Teléfonos')
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                return _TelefonoCardModern(telefono: _filtered[i]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _all.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _filtered = _all;
                  _animController.reset();
                  _animController.forward();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.clear_all),
              tooltip: 'Restablecer búsqueda',
            )
          : null,
    );
  }
}

class _TelefonoCardModern extends StatelessWidget {
  const _TelefonoCardModern({Key? key, required this.telefono}) : super(key: key);
  final Telefono telefono;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Seleccionaste: ${telefono.numero} (ID: ${telefono.idtelefono})'),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.2),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.phone, color: theme.colorScheme.onPrimary, size: 28),
            ),
            title: Text(
              telefono.numero,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onBackground),
            ),
            subtitle: Text(
              'ID: ${telefono.idtelefono}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────  ESTADOCIVIL PAGE  ─ */
class EstadocivilPage extends StatefulWidget {
  const EstadocivilPage({Key? key}) : super(key: key);

  @override
  State<EstadocivilPage> createState() => _EstadocivilPageState();
}

class _EstadocivilPageState extends State<EstadocivilPage> with SingleTickerProviderStateMixin {
  List<Estadocivil> _all = [];
  List<Estadocivil> _filtered = [];
  bool _loading = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _fetch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://educaysoft.org/Ibm6aphp/app/controllers/EstadocivilController.php?action=api',
      ));
      if (response.statusCode == 200) {
        final data = (json.decode(response.body) as List)
            .map((e) => Estadocivil.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
        _animController.forward(from: 0.0);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Estado Civil: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((e) {
        final nombreLower = e.nombre.toLowerCase();
        final idLower = e.idestadocivil.toLowerCase();
        return nombreLower.contains(q) || idLower.contains(q);
      }).toList();
      _animController.reset();
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Estados Civiles'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.03),
              theme.colorScheme.surfaceVariant.withOpacity(0.09),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetch,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o ID...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cargando datos...',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const _EmptyState(msg: 'No hay Estados Civiles')
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                return _EstadocivilCardModern(estado: _filtered[i]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _all.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _filtered = _all;
                  _animController.reset();
                  _animController.forward();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.clear_all),
              tooltip: 'Restablecer búsqueda',
            )
          : null,
    );
  }
}

class _EstadocivilCardModern extends StatelessWidget {
  const _EstadocivilCardModern({Key? key, required this.estado}) : super(key: key);
  final Estadocivil estado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Seleccionaste: ${estado.nombre} (ID: ${estado.idestadocivil})'),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.2),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.favorite, color: theme.colorScheme.onPrimary, size: 28),
            ),
            title: Text(
              estado.nombre,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onBackground),
            ),
            subtitle: Text(
              'ID: ${estado.idestadocivil}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
/* ────────────────────────────────────────────  DIRECCIÓN PAGE  ─ */
class DireccionPage extends StatefulWidget {
  const DireccionPage({Key? key}) : super(key: key);

  @override
  State<DireccionPage> createState() => _DireccionPageState();
}

class _DireccionPageState extends State<DireccionPage> with SingleTickerProviderStateMixin {
  List<Direccion> _all = [];
  List<Direccion> _filtered = [];
  bool _loading = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _fetch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://educaysoft.org/Ibm6aphp/app/controllers/DireccionController.php?action=api',
      ));
      if (response.statusCode == 200) {
        final data = (json.decode(response.body) as List)
            .map((e) => Direccion.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
        _animController.forward(from: 0.0);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Dirección: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((d) {
        final calleP = d.calleprincipal.toLowerCase();
        final calleS = d.callesecundaria.toLowerCase();
        final nroCasa = d.numerocasa.toLowerCase();
        final idLower = d.iddireccion.toLowerCase();
        return calleP.contains(q) ||
            calleS.contains(q) ||
            nroCasa.contains(q) ||
            idLower.contains(q);
      }).toList();
      _animController.reset();
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Direcciones'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.03),
              theme.colorScheme.surfaceVariant.withOpacity(0.09),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetch,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por calle, número o ID...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cargando datos...',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const _EmptyState(msg: 'No hay Direcciones')
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                return _DireccionCardModern(dir: _filtered[i]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _all.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _filtered = _all;
                  _animController.reset();
                  _animController.forward();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.clear_all),
              tooltip: 'Restablecer búsqueda',
            )
          : null,
    );
  }
}

class _DireccionCardModern extends StatelessWidget {
  const _DireccionCardModern({Key? key, required this.dir}) : super(key: key);
  final Direccion dir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dirección seleccionada: ${dir.nombre} (ID: ${dir.iddireccion})'),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.2),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.location_on, color: theme.colorScheme.onPrimary, size: 28),
            ),
            title: Text(
              dir.nombre,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            subtitle: Text(
              '• ${dir.persona_nombres} ${dir.persona_apellidos}\nID: ${dir.iddireccion}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}


/* ───────────────────────────────────────────────  PERSONA PAGE ─ */
class PersonaPage extends StatefulWidget {
  const PersonaPage({Key? key}) : super(key: key);

  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> with SingleTickerProviderStateMixin {
  List<Persona> _all = [];
  List<Persona> _filtered = [];
  bool _loading = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _fetch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/PersonaController.php?action=api',
        ),
      );
      if (response.statusCode == 200) {
        final data = (json.decode(response.body) as List)
            .map((e) => Persona.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
        _animController.forward(from: 0.0);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Persona: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((p) {
        final nombresLower = p.nombres.toLowerCase();
        final apellidosLower = p.apellidos.toLowerCase();
        final fechaLower = p.fechanacimiento.toLowerCase();
        return nombresLower.contains(q) ||
            apellidosLower.contains(q) ||
            fechaLower.contains(q);
      }).toList();
      _animController.reset();
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Personas'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceVariant.withOpacity(0.03),
              theme.colorScheme.surfaceVariant.withOpacity(0.09),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetch,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, apellido o fecha...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cargando datos...',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const _EmptyState(msg: 'No hay Personas')
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                return _PersonaCardModern(persona: _filtered[i]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _all.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _filtered = _all;
                  _animController.reset();
                  _animController.forward();
                });
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.clear_all),
              tooltip: 'Restablecer búsqueda',
            )
          : null,
    );
  }
}

class _PersonaCardModern extends StatelessWidget {
  const _PersonaCardModern({Key? key, required this.persona}) : super(key: key);
  final Persona persona;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Seleccionaste: ${persona.nombres} ${persona.apellidos}\n'
                'Nacimiento: ${persona.fechanacimiento}',
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.2),
                theme.colorScheme.primaryContainer.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.person, color: theme.colorScheme.onPrimary, size: 28),
            ),
            title: Text(
              '${persona.nombres} ${persona.apellidos}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            subtitle: Text(
              'Nacimiento: ${persona.fechanacimiento}\nID: ${persona.idpersona}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
