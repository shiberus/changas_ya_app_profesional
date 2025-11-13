import 'package:changas_ya_app/presentation/providers/professional_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/presentation/providers/save_profile_provider.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

// TODO: Buscar como hacer para que suba una foto y después obtenga la ruta la misma
class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formRegisterKey = GlobalKey<FormState>();

  final FieldValidation validation = FieldValidation();
  final UserAuthController _auth = UserAuthController();

  String userId = '';
  bool isWorker = false;
  String snackBarMessage = '';
  Color? snackBarColor = Colors.red[400];

  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _photoController = TextEditingController();
  //Lista de controladores para cada entrad de oficio.
  late List<TextEditingController> _tradesControllers = [];

  void _addTradesControllers(List<String> userTrades) {
    if (userTrades.isNotEmpty) {
      for (String trade in userTrades) {
        _addField(trade);
      }
    } else {
      _addField(null);
    }
  }

  void _addField(String? tradeValue) {
    final tradeController = TextEditingController(text: tradeValue);
    _tradesControllers.add(tradeController);
    // int numOfControllers = _tradesControllers.length;
    // _tradesFields.add(
    //   FormRemovableTextField(tradeController: tradeController, numOfControllers: numOfControllers, validation: validation),
    // );
    if (mounted) {
      setState(() {});
    }
  }

  // Obtengo los datos de los oficios desde los controladores.
  List<String> obtainTradesList() {
    final List<String> trades = _tradesControllers
        .map((tradeController) => tradeController.text)
        .where((text) => text.trim().isNotEmpty)
        .toList();
    return trades;
  }

  String? getUserId() {
    return _auth.getuserUid();
  }

  // Carga los datos guardados en la base de datos del usuario.
  Future<SnackBar> initialUserData() async {
    final uId = getUserId();
    try {
      if (uId == null) throw Exception();

      final userProfile = await ref
          .read(profileRepositoryProvider)
          .fetchProfileById(uId);

      if (userProfile == null) throw Exception();

      // Hago la llamada a la nueva función que crea los nuevos text fields
      _addTradesControllers(userProfile.trades);
      // Esto debería cargar los datos iguales para todos los oficios del usuario.

      userId = userProfile.uid;
      isWorker = userProfile.isWorker;
      _nameController.text = userProfile.name;
      _emailController.text = userProfile.email;
      _addressController.text = userProfile.address ?? '';
      _phoneController.text = userProfile.phone ?? '';
      _photoController.text = userProfile.photoUrl ?? '';
      //Le asigno a la lista de controladores los nuevos controladores obtenido de la DB.
      //_tradesControllers = loadedControllers;

      snackBarMessage = "¡Datos cargados correctamente!";
      snackBarColor = Colors.green[400];
    } on Exception catch (e) {
      snackBarMessage = e.toString();
    }
    SnackBar newSanckBar = SnackBar(
      content: Text(snackBarMessage),
      backgroundColor: snackBarColor,
    );
    return newSanckBar;
  }

  void removeTrade(int index) async {
    _tradesControllers[index].dispose();
    _tradesControllers.removeAt(index);
    await registerData();
    setState(() { });
  }

  // Guarda los nuevos datos del usuario en la base de datos.
  Future<void> registerData() async {
    if (_formRegisterKey.currentState!.validate()) {
      final updatedProfile = Profile(
        uid: userId,
        name: _nameController.text,
        email: _emailController.text.trim(),
        isWorker: isWorker,
        address: _addressController.text,
        phone: _phoneController.text,
        photoUrl: _photoController.text,
        trades: obtainTradesList(),
      );

      try {
        await ref
            .read(saveProfileNotifierProvider.notifier)
            .saveProfile(updatedProfile);
      } catch (e) {
        snackBarMessage = "Ocurrió un error al guardar los datos.";
      }
    }
  }

  // Al montar el estado del Widget la acción siguiente es cargar el estado.
  // Esto sobreescribe esta acción y carga los datos del usuario.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final snackBar = await initialUserData();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(saveProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Form(
        key: _formRegisterKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Chip(
                  padding: EdgeInsets.all(8),
                  avatar: state.isLoading
                      ? CircularProgressIndicator(color: Colors.blue[400])
                      : Icon(Icons.check_circle, color: Colors.green[400]),
                  label: state.isLoading
                      ? Text(
                          "Guardando",
                          style: TextStyle(color: Colors.blue[400]),
                        )
                      : Text(
                          "Guardado",
                          style: TextStyle(color: Colors.green[400]),
                        ),
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15.0,
                children: [
                  InputTextField(
                    controller: _nameController,
                    validation: (text) => validation.validateName(text),
                    label: "Nombre",
                  ),
                  InputTextField(
                    controller: _emailController,
                    validation: (text) => validation.validateEmail(text),
                    label: "Email",
                  ),
                  InputTextField(
                    controller: _addressController,
                    validation: (text) => validation.validateAddress(text),
                    label: "Dirección",
                  ),
                  InputTextField(
                    controller: _phoneController,
                    validation: (text) => validation.validatePhone(text),
                    label: "Teléfono",
                  ),

                  //Si es profecional permito que cargue más oficios
                  isWorker
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Alinea a la izquierda
                                children: [
                                  Icon(Icons.work, color: Colors.blueAccent),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Oficios registrados',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15.0),

                              ..._tradesControllers.asMap().entries.map((
                                entry,
                              ) {
                                final int index = entry.key;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormRemovableTextField(
                                    tradeController: _tradesControllers[index],
                                    index: index,
                                    callback: () => removeTrade(index),
                                    validation: validation,
                                  ),
                                );
                              }),
                              const SizedBox(height: 15.0),

                              ElevatedButton(
                                onPressed: () => _addField(null),
                                child: Text("Añadir oficio"),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement image picker and set _photoController.text with the selected file path.
                      },
                      child: Text("Seleccionar foto de perfil"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onChanged: () async {
          await Future.delayed(
            const Duration(seconds: 3),
            () => registerData(),
          );
        },
      ),
    );
  }
}

class FormRemovableTextField extends StatelessWidget {
  const FormRemovableTextField({
    super.key,
    required this.tradeController,
    required this.index,
    required this.callback,
    required this.validation,
  });

  final TextEditingController tradeController;
  final int index;
  final Function()? callback;
  final FieldValidation validation;

  @override
  Widget build(BuildContext context) {
    return 
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: tradeController,
                decoration: InputDecoration(
                  labelText: "Oficio ${index + 1}",
                  border: const OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? text) => validation.validateTrades(text),
              ),
            ),
            SizedBox(width: 8.0,),
            TextButton.icon(
              icon: Icon(Icons.close),
              onPressed: callback,
              label: Text(''),
            )
          ],
        );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required TextEditingController controller,
    required this.validation,
    required this.label,
  }) : _controller = controller;

  final TextEditingController _controller;
  // Declaro que el validador como una función que ingresa por parametro.
  final String? Function(String?) validation;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validation,
    );
  }
}
