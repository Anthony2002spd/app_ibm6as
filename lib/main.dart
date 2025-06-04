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
  const TelefonoPage({super.key});
  @override
  State<TelefonoPage> createState() => _TelefonoPageState();
}

class _TelefonoPageState extends State<TelefonoPage> {
  List<Telefono> _all = [], _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/TelefonoController.php?action=api'));
      if (r.statusCode == 200) {
        final data = (json.decode(r.body) as List)
            .map((e) => Telefono.fromJson(e))
            .toList();
        setState(() => _all = _filtered = data);
      } else {
        throw Exception('Error ${r.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Teléfono: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String q) => setState(() => _filtered = _all
      .where((t) =>
          t.numero.toLowerCase().contains(q.toLowerCase()) ||
          t.idtelefono.contains(q))
      .toList());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _fetch,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceVariant,
                prefixIcon: Icon(Icons.search, color: cs.primary),
                hintText: 'Buscar Teléfono (número o ID)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? const _EmptyState(msg: 'No hay Teléfonos')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) => _TelefonoCard(
                              telefono: _filtered[i],
                            ),
                      ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────────  Tarjeta  ────────────────────── */
class _TelefonoCard extends StatelessWidget {
  const _TelefonoCard({required this.telefono});
  final Telefono telefono;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => debugPrint(
          'Teléfono: ${telefono.idtelefono} - ${telefono.numero}'),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: cs.shadow.withOpacity(.12),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: cs.primary,
              child: Icon(Icons.phone, color: cs.onPrimary)),
          title: Text(telefono.numero,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimaryContainer)),
          subtitle: Text('ID: ${telefono.idtelefono}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

/* ─────────────────────────────────────────  ESTADOCIVIL PAGE  ─ */
class EstadocivilPage extends StatefulWidget {
  const EstadocivilPage({super.key});
  @override
  State<EstadocivilPage> createState() => _EstadocivilPageState();
}

class _EstadocivilPageState extends State<EstadocivilPage> {
  List<Estadocivil> _all = [], _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/EstadocivilController.php?action=api'));
      if (r.statusCode == 200) {
        final data = (json.decode(r.body) as List)
            .map((e) => Estadocivil.fromJson(e))
            .toList();
        setState(() => _all = _filtered = data);
      } else {
        throw Exception('Error ${r.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Estado Civil: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String q) => setState(() => _filtered = _all
      .where((e) =>
          e.nombre.toLowerCase().contains(q.toLowerCase()) ||
          e.idestadocivil.contains(q))
      .toList());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _fetch,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceVariant,
                prefixIcon: Icon(Icons.search, color: cs.primary),
                hintText: 'Buscar Estado Civil (nombre o ID)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? const _EmptyState(msg: 'No hay Estados Civiles')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            _EstadoCivilCard(estado: _filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────────  Tarjeta  ────────────────────── */
class _EstadoCivilCard extends StatelessWidget {
  const _EstadoCivilCard({required this.estado});
  final Estadocivil estado;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => debugPrint(
          'Estado Civil: ${estado.idestadocivil} - ${estado.nombre}'),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: cs.shadow.withOpacity(.12),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: cs.primary,
              child: Icon(Icons.favorite, color: cs.onPrimary)),
          title: Text(estado.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimaryContainer)),
          subtitle: Text('ID: ${estado.idestadocivil}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}


/* ────────────────────────────────────────────  DIRECCIÓN PAGE  ─ */
class DireccionPage extends StatefulWidget {
  const DireccionPage({super.key});
  @override
  State<DireccionPage> createState() => _DireccionPageState();
}

class _DireccionPageState extends State<DireccionPage> {
  List<Direccion> _all = [], _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/DireccionController.php?action=api'));
      if (r.statusCode == 200) {
        final data = (json.decode(r.body) as List)
            .map((e) => Direccion.fromJson(e))
            .toList();
        setState(() => _all = _filtered = data);
      } else {
        throw Exception('Error ${r.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Dirección: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String q) => setState(() => _filtered = _all
      .where((d) =>
          d.calleprincipal.toLowerCase().contains(q.toLowerCase()) ||
          d.callesecundaria.toLowerCase().contains(q.toLowerCase()) ||
          d.numerocasa.toLowerCase().contains(q.toLowerCase()) ||
          d.iddireccion.contains(q))
      .toList());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _fetch,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceVariant,
                prefixIcon: Icon(Icons.search, color: cs.primary),
                hintText: 'Buscar Dirección (calles, número o ID)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? const _EmptyState(msg: 'No hay Direcciones')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            _DireccionCard(dir: _filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────────  Tarjeta  ────────────────────── */
class _DireccionCard extends StatelessWidget {
  const _DireccionCard({required this.dir});
  final Direccion dir;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => debugPrint(
          'Dirección: ${dir.nombre} - ${dir.persona_nombres}'),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: cs.shadow.withOpacity(.12),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: cs.primary,
              child: Icon(Icons.location_on, color: cs.onPrimary)),
          title: Text(dir.nombre,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimaryContainer)),
          subtitle: Text(
              '• ${dir.persona_nombres} ${dir.persona_apellidos}\nID: ${dir.iddireccion}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────────  PERSONA PAGE ─ */
class PersonaPage extends StatefulWidget {
  const PersonaPage({super.key});
  @override
  State<PersonaPage> createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  List<Persona> _all = [], _filtered = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final r = await http.get(
        Uri.parse(
          'https://educaysoft.org/Ibm6aphp/app/controllers/PersonaController.php?action=api',
        ),
      );
      if (r.statusCode == 200) {
        final data = (json.decode(r.body) as List)
            .map((e) => Persona.fromJson(e))
            .toList();
        setState(() {
          _all = data;
          _filtered = data;
        });
      } else {
        throw Exception('Error ${r.statusCode}');
      }
    } catch (e) {
      debugPrint('Error Persona: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _search(String q) => setState(
    () => _filtered = _all
        .where(
          (p) =>
              p.nombres.toLowerCase().contains(q.toLowerCase()) ||
              p.apellidos.toLowerCase().contains(q.toLowerCase()) ||
              p.fechanacimiento.contains(q),
        )
        .toList(),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          onChanged: _search,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Buscar Persona (nombres, apellidos o fecha)',
          ),
        ),
      ),
      Expanded(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _filtered.isEmpty
            ? const Center(child: Text('No hay Personas'))
            : ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final p = _filtered[i];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('${p.nombres} ${p.apellidos}'),
                    subtitle: Text(
                      'ID: ${p.idpersona} · Sexo: ${p.elsexo} · EC: ${p.elestadocivil}\nF.Nac.: ${p.fechanacimiento}',
                    ),
                  );
                },
              ),
      ),
    ],
  );
}
