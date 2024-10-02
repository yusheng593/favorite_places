import 'package:favorite_places/providers/user_places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _NewFavoriteState();
}

class _NewFavoriteState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';

  void _saveTitle() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      ref.read(userPlacesProvider.notifier).addPlace(_enteredTitle);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLength: 50,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue ?? '';
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: _saveTitle,
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Place",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
