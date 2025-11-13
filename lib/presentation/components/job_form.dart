import 'package:changas_ya_app/Domain/Profession/profession.dart';
import 'package:changas_ya_app/presentation/widgets/profession_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/components/banner_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class JobForm extends ConsumerStatefulWidget {
  Future<void> Function(Map<String, dynamic> jobData, List<File> images)
  onSubmit;

  JobForm({super.key, required this.onSubmit});

  @override
  ConsumerState<JobForm> createState() => _JobFormState();
}

class _JobFormState extends ConsumerState<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = []; // Para futura implementación de imágenes
  Profession? _selectedProfession;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final formWidth = isWeb ? 600.0 : double.infinity;

    final titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Center(
      child: Container(
        width: formWidth,
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 0 : 20.0,
          vertical: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner igual que otros screens
              Bannerwidget(
                imageAsset: 'lib/images/signup_banner.png',
                titleStyle: titleStyle,
                titleToShow: 'Crear trabajo',
              ),

              const SizedBox(height: 20),

              // Título del trabajo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título del trabajo',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    return null;
                  },
                ),
              ),

              // Input para subir imágenes - Placeholder para futura implementación
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imágenes del trabajo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: InkWell(
                        onTap: _pickImages,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedImages.isEmpty
                                  ? 'Toca para subir imágenes'
                                  : '${_selectedImages.length} imagen(es) seleccionada(s)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Puedes subir varias imágenes de la reparación',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Descripción del trabajo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descripción del trabajo',
                    hintText:
                        'Describe detalladamente el trabajo a realizar...',
                    prefixIcon: Icon(Icons.description_outlined),
                    helperText: 'Campo obligatorio',
                    helperStyle: TextStyle(color: Colors.red),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es requerida';
                    }
                    if (value.trim().length < 10) {
                      return 'La descripción debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
              ),

              ProfessionDropdown(
                onChanged: (profession) {
                  setState(() {
                    _selectedProfession = profession;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.publish, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Publicar trabajo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 20),

              // Notas informativas con mejor diseño
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Al publicar, tu trabajo será visible para todos los profesionales.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles == null || pickedFiles.isEmpty) return;

      const int maxImages = 5;

      if (pickedFiles.length > maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Solo podés subir hasta 5 imágenes.")),
        );
        return;
      }

      const int maxFileSize = 5 * 1024 * 1024; // son 5mb

      for (final xfile in pickedFiles) {
        final file = File(xfile.path);
        final fileSize = file.lengthSync();

        if (fileSize > maxFileSize) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Una de las imágenes supera el límite de 5MB: ${xfile.name}",
              ),
            ),
          );
          return;
        }
      }

      final allowedExtensions = ['jpg', 'jpeg', 'png'];

      for (final xfile in pickedFiles) {
        final ext = xfile.name.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(ext)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Formato no permitido: ${xfile.name}. Solo JPG o PNG.",
              ),
            ),
          );
          return;
        }
      }

      setState(() {
        _selectedImages = pickedFiles.map((xfile) => File(xfile.path)).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pickedFiles.length} imágenes seleccionadas."),
        ),
      );
    } catch (e) {
      print("Error seleccionando imágenes: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocurrió un error al seleccionar imágenes."),
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final jobData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'Buscando profesional',
        'budgetManpower': _budgetController.text.isNotEmpty
            ? double.parse(_budgetController.text)
            : null,
        'imageUrls': [], // Por ahora vacio hasta implementar iel mage_picker
        'relatedOffice': _selectedProfession?.id,
        'datePosted': DateTime.now(),
      };

      await widget.onSubmit(jobData, _selectedImages);

      // Limpiar formulario
      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      setState(() {
        _selectedImages = [];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
