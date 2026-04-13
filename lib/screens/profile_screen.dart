// Archivo: lib/screens/profile_screen.dart

import 'dart:io'; // Para manejar archivos de imagen (File)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Librería para la foto
import 'package:path_provider/path_provider.dart'; // Para guardar la foto permanente
import 'package:path/path.dart' as path; // Para manipular nombres de archivos
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false; // Controla si vemos la credencial o el formulario
  String? _imagePath; // Guardará la ruta local de la foto del alumno

  // Controladores para el formulario
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _matriculaCtrl = TextEditingController();
  final TextEditingController _carreraCtrl = TextEditingController();
  final TextEditingController _curpCtrl = TextEditingController();
  final TextEditingController _nssCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // Instancia para elegir la foto

  @override
  void initState() {
    super.initState();
    _cargarDatosDeMemoria();
  }

  // --- PERSISTENCIA Y CARGA DE DATOS (Incluyendo Foto) ---
  Future<void> _cargarDatosDeMemoria() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreCtrl.text = prefs.getString('perfil_nombre') ?? '';
      _matriculaCtrl.text = prefs.getString('perfil_matricula') ?? '';
      _carreraCtrl.text =
          prefs.getString('perfil_carrera') ?? 'INGENIERÍA EN COMPUTACIÓN';
      _curpCtrl.text = prefs.getString('perfil_curp') ?? '';
      _nssCtrl.text = prefs.getString('perfil_nss') ?? '';
      _imagePath = prefs.getString(
        'perfil_image_path',
      ); // Carga la ruta de la foto
    });
  }

  // Lógica para guardar datos y foto permanentes
  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_nombre', _nombreCtrl.text.toUpperCase());
    await prefs.setString('perfil_matricula', _matriculaCtrl.text);
    await prefs.setString('perfil_carrera', _carreraCtrl.text.toUpperCase());
    await prefs.setString('perfil_curp', _curpCtrl.text.toUpperCase());
    await prefs.setString('perfil_nss', _nssCtrl.text);

    // Guardamos la ruta de la foto si existe
    if (_imagePath != null) {
      await prefs.setString('perfil_image_path', _imagePath!);
    }

    setState(() {
      _isEditing = false; // Salimos del modo edición
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Credencial Digital Actualizada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // --- LÓGICA DE LA FOTO (Manejo Avanzado) ---
  Future<void> _seleccionarFuenteImagen() async {
    // Muestra un diálogo para elegir entre Cámara o Galería
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Foto de la Credencial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: guindaUTM,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: guindaUTM),
              title: const Text('Elegir de la Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSaveImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: guindaUTM),
              title: const Text('Tomar Foto con la Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSaveImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndSaveImage(ImageSource source) async {
    // 1. Abre la cámara/galería
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxHeight: 800,
    );

    if (image == null) return; // Usuario canceló

    // 2. Obtiene la carpeta de documentos permanentes de la app
    final Directory directory = await getApplicationDocumentsDirectory();
    final String pathDir = directory.path;

    // 3. Genera un nombre de archivo único para la foto
    final String fileName =
        'foto_alumno_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';

    // 4. Copia la foto temporal a la carpeta permanente
    final File permanentImage = await File(
      image.path,
    ).copy('$pathDir/$fileName');

    // 5. Actualiza el estado para mostrar la nueva foto
    setState(() {
      _imagePath = permanentImage.path;
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _matriculaCtrl.dispose();
    _carreraCtrl.dispose();
    _curpCtrl.dispose();
    _nssCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      // --- APPBAR ESMERILADO ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text(
                  'Mi Credencial UTM',
                  style: TextStyle(
                    color: guindaUTM,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.7),
                elevation: 0,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.close : Icons.edit,
                      color: guindaUTM,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                        if (!_isEditing) _cargarDatosDeMemoria();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: _isEditing ? _buildFormulario() : _buildCredencialDigital(),
      ),
    );
  }

  // --- MODO 1: CREDENCIAL DIGITAL (VISTA) ---
  Widget _buildCredencialDigital() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 100),
      child: Column(
        children: [
          // Tarjeta que imita el diseño físico
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cremaUTM,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Cabecera Guinda Institucional
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: guindaUTM,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'UNIVERSIDAD TECNOLÓGICA DE LA MIXTECA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(height: 4, width: double.infinity, color: doradoUTM),

                // Cuerpo de la credencial
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ESPACIO DE LA FOTO REAL DEL ALUMNO ---
                      Container(
                        width: 90,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _buildImagenAlumno(fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Datos del alumno
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDatoCredencial(
                              'Matrícula',
                              _matriculaCtrl.text.isEmpty
                                  ? 'Sin registrar'
                                  : _matriculaCtrl.text,
                            ),
                            const SizedBox(height: 10),
                            _buildDatoCredencial(
                              'Alumno',
                              _nombreCtrl.text.isEmpty
                                  ? 'ESTUDIANTE'
                                  : _nombreCtrl.text,
                            ),
                            const SizedBox(height: 10),
                            _buildDatoCredencial(
                              'Carrera',
                              _carreraCtrl.text.isEmpty
                                  ? 'CARRERA'
                                  : _carreraCtrl.text,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade400, height: 1),

                // Reverso (CURP y NSS)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildDatoCredencial(
                          'NSS (IMSS)',
                          _nssCtrl.text.isEmpty ? '---' : _nssCtrl.text,
                          centrado: true,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: _buildDatoCredencial(
                          'CURP',
                          _curpCtrl.text.isEmpty ? '---' : _curpCtrl.text,
                          centrado: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          const Text(
            'Muestra esta credencial digital para identificarte en el campus.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => _isEditing = true);
            },
            icon: const Icon(Icons.edit, color: guindaUTM),
            label: const Text(
              'Actualizar Datos',
              style: TextStyle(color: guindaUTM, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: guindaUTM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widgecito auxiliar para pintar cada campo en la credencial
  Widget _buildDatoCredencial(
    String etiqueta,
    String valor, {
    bool centrado = false,
  }) {
    return Column(
      crossAxisAlignment: centrado
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          valor,
          textAlign: centrado ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // --- MODO 2: FORMULARIO (EDICIÓN) ---
  Widget _buildFormulario() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completa tu información',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: guindaUTM,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Estos datos se guardarán únicamente en tu teléfono.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // --- SECCIÓN PARA SUBIR/CAMBIAR FOTO ---
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: _buildImagenAlumno(
                      fit: BoxFit.cover,
                      errorColor: guindaUTM,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _seleccionarFuenteImagen,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: doradoUTM,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Toca la cámara para cambiar tu foto',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          _buildInput('Nombre Completo', _nombreCtrl, Icons.person_outline),
          const SizedBox(height: 15),
          _buildInput(
            'Matrícula',
            _matriculaCtrl,
            Icons.numbers,
            isNumber: true,
          ),
          const SizedBox(height: 15),
          _buildInput('Carrera', _carreraCtrl, Icons.school_outlined),
          const SizedBox(height: 15),
          _buildInput('CURP', _curpCtrl, Icons.badge_outlined),
          const SizedBox(height: 15),
          _buildInput(
            'NSS (IMSS)',
            _nssCtrl,
            Icons.local_hospital_outlined,
            isNumber: true,
          ),

          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _guardarDatos,
            style: ElevatedButton.styleFrom(
              backgroundColor: guindaUTM,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: const Text(
              'GUARDAR CREDENCIAL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widgecito que decide si pintar el ícono o la foto real
  Widget _buildImagenAlumno({
    required BoxFit fit,
    Color errorColor = Colors.white,
  }) {
    if (_imagePath != null && File(_imagePath!).existsSync()) {
      return Image.file(File(_imagePath!), fit: fit);
    } else {
      // Si no hay foto, muestra el ícono genérico
      return Icon(Icons.person, size: 60, color: errorColor);
    }
  }

  // Widgecito auxiliar para inputs rápidos
  Widget _buildInput(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: guindaUTM),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: guindaUTM, width: 2),
        ),
      ),
    );
  }
}
