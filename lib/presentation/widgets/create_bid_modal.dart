import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/presentation/providers/bid_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBidModal extends ConsumerStatefulWidget {
  final String jobId;

  const CreateBidModal({super.key, required this.jobId});

  @override
  ConsumerState<CreateBidModal> createState() => _CreateBidModalState();
}

class _CreateBidModalState extends ConsumerState<CreateBidModal> {
  final _formKey = GlobalKey<FormState>();
  final _manpowerController = TextEditingController();
  final _sparesController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _manpowerController.dispose();
    _sparesController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    final manpower = double.tryParse(_manpowerController.text) ?? 0.0;
    final spares = double.tryParse(_sparesController.text) ?? 0.0;
    return manpower + spares;
  }

  Future<void> _submitBid() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Error: Debe iniciar sesión para crear una oferta.'),
        ),
      );
      return;
    }

    final manpower = double.parse(_manpowerController.text);
    final spares = double.parse(_sparesController.text);
    final message = _messageController.text.trim();
    final budgetTotal = manpower + spares;

    setState(() {
      _isLoading = true;
    });

    try {
      final bid = Bid(
        id: '', // Se generará en Firestore
        jobId: widget.jobId,
        workerId: currentUser.uid,
        budgetManpower: manpower,
        budgetSpares: spares,
        budgetTotal: budgetTotal,
        message: message,
        status: 'bidded',
        createdDate: DateTime.now(),
      );

      final createBid = ref.read(createBidProvider);
      await createBid(widget.jobId, bid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oferta creada con éxito!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Error: No se pudo crear la oferta. Intente de nuevo.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "Crear Propuesta",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Presupuesto",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _manpowerController,
                      decoration: const InputDecoration(
                        labelText: "Mano de obra",
                        hintText: "Ingrese el monto",
                        border: OutlineInputBorder(),
                        prefixText: "\$ ",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el monto de mano de obra';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 0) {
                          return 'Por favor ingrese un monto válido';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _sparesController,
                      decoration: const InputDecoration(
                        labelText: "Repuestos",
                        hintText: "Ingrese el monto",
                        border: OutlineInputBorder(),
                        prefixText: "\$ ",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el monto de repuestos';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 0) {
                          return 'Por favor ingrese un monto válido';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "\$ ${_calculateTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: "Mensaje (opcional)",
                        hintText: "Agregue un mensaje para el cliente",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 500,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitBid,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Enviar Propuesta"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

