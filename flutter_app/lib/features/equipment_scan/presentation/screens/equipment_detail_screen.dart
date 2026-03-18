import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EquipmentDetailScreen extends ConsumerStatefulWidget {
  final int equipmentId;
  final int missionId;

  const EquipmentDetailScreen({
    Key? key,
    required this.equipmentId,
    required this.missionId,
  }) : super(key: key);

  @override
  ConsumerState<EquipmentDetailScreen> createState() =>
      _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState
    extends ConsumerState<EquipmentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  String? _selectedPhysicalState;
  int? _selectedLocationId;
  bool _hasAnomaly = false;
  final List<String> _photosPaths = [];

  final List<String> _physicalStates = [
    'Neuf',
    'Bon état',
    'Usagé',
    'Défectueux',
    'À réformer',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _takePicture() async {
    // TODO: Implement camera capture
    // final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (image != null) {
    //   setState(() {
    //     _photosPaths.add(image.path);
    //   });
    // }
  }

  void _reportAnomaly() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signaler une anomalie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type d\'anomalie:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Équipement endommagé',
                'Informations incorrectes',
                'Mauvaise localisation',
                'Autre',
              ]
                  .map((type) => ChoiceChip(
                        label: Text(type),
                        selected: false,
                        onSelected: (selected) {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Submit anomaly
              Navigator.pop(context);
              setState(() {
                _hasAnomaly = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anomalie signalée')),
              );
            },
            child: const Text('Signaler'),
          ),
        ],
      ),
    );
  }

  void _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // TODO: Save equipment data
      await Future.delayed(const Duration(seconds: 1)); // Mock

      if (!mounted) return;
      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Return to mission

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Équipement enregistré avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock equipment data
    final equipment = _getMockEquipment();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails équipement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndContinue,
            tooltip: 'Enregistrer',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Equipment info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getEquipmentIcon(equipment['type']),
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                equipment['name'],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                equipment['type'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Fabricant', equipment['manufacturer']),
                    _buildInfoRow('Modèle', equipment['model']),
                    _buildInfoRow('N° Série', equipment['serial']),
                    _buildInfoRow('N° Inventaire', equipment['inventory_number']),
                    _buildInfoRow('Utilisateur', equipment['user']),
                    _buildInfoRow('Localisation', equipment['location']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Physical state
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'État physique',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _physicalStates
                          .map(
                            (state) => ChoiceChip(
                              label: Text(state),
                              selected: _selectedPhysicalState == state,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedPhysicalState =
                                      selected ? state : null;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Photos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photos (${_photosPaths.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _takePicture,
                          tooltip: 'Prendre une photo',
                        ),
                      ],
                    ),
                    if (_photosPaths.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text('Aucune photo'),
                        ),
                      )
                    else
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photosPaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.image, size: 48),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 16,
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _photosPaths.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes et observations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Ajouter des notes...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Anomaly button
            if (_hasAnomaly)
              Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.orange),
                  title: const Text('Anomalie signalée'),
                  trailing: TextButton(
                    onPressed: _reportAnomaly,
                    child: const Text('Modifier'),
                  ),
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: _reportAnomaly,
                icon: const Icon(Icons.report_problem),
                label: const Text('Signaler une anomalie'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.all(16),
                ),
              ),

            const SizedBox(height: 24),

            // Save button
            ElevatedButton(
              onPressed: _saveAndContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Enregistrer et continuer',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Non défini',
              style: TextStyle(
                color: value != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEquipmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'computer':
      case 'ordinateur':
        return Icons.computer;
      case 'monitor':
      case 'écran':
        return Icons.monitor;
      case 'printer':
      case 'imprimante':
        return Icons.print;
      case 'phone':
      case 'téléphone':
        return Icons.phone;
      default:
        return Icons.devices;
    }
  }

  Map<String, String> _getMockEquipment() {
    return {
      'name': 'PC-Bureau-001',
      'type': 'Ordinateur',
      'manufacturer': 'Dell',
      'model': 'OptiPlex 7090',
      'serial': 'ABC123XYZ789',
      'inventory_number': 'INV-2024-001',
      'user': 'Jean Dupont',
      'location': 'Siège > Étage 2 > Bureau 205',
    };
  }
}
