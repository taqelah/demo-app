import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

class FormShowcaseScreen extends StatefulWidget {
  const FormShowcaseScreen({super.key});

  @override
  State<FormShowcaseScreen> createState() => _FormShowcaseScreenState();
}

class _FormShowcaseScreenState extends State<FormShowcaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String? _selectedDropdown;
  bool _termsAccepted = false;
  String _selectedSize = 'Medium';
  bool _newsletter = false;
  double _rating = 3.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Form submitted successfully!'),
            backgroundColor: Colors.green),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _numberController.clear();
    _passwordController.clear();
    _dateController.clear();
    _timeController.clear();
    setState(() {
      _selectedDropdown = null;
      _termsAccepted = false;
      _selectedSize = 'Medium';
      _newsletter = false;
      _rating = 3.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Validation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                key: TestKeys.formNameField,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.formEmailField,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.formPhoneField,
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone is required';
                  if (v.trim().length < 10) return 'At least 10 digits';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.formNumberField,
                controller: _numberController,
                decoration:
                    const InputDecoration(labelText: 'Number (1-100)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null || n < 1 || n > 100) return 'Enter 1-100';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.formPasswordField,
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: TestKeys.formDropdown,
                initialValue: _selectedDropdown,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Casual', 'Formal', 'Party', 'Bridal']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDropdown = v),
                validator: (v) => v == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                key: TestKeys.formCheckboxTerms,
                title: const Text('I accept the terms and conditions'),
                value: _termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const Divider(),
              Text('Size',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              RadioGroup<String>(
                groupValue: _selectedSize,
                onChanged: (String? v) => setState(() => _selectedSize = v ?? _selectedSize),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      key: TestKeys.formRadioSmall,
                      title: const Text('Small'),
                      value: 'Small',
                    ),
                    RadioListTile<String>(
                      key: TestKeys.formRadioMedium,
                      title: const Text('Medium'),
                      value: 'Medium',
                    ),
                    RadioListTile<String>(
                      key: TestKeys.formRadioLarge,
                      title: const Text('Large'),
                      value: 'Large',
                    ),
                  ],
                ),
              ),
              const Divider(),
              SwitchListTile(
                key: TestKeys.formSwitchNewsletter,
                title: const Text('Subscribe to newsletter'),
                value: _newsletter,
                onChanged: (v) => setState(() => _newsletter = v),
              ),
              const Divider(),
              Text('Rating',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      key: TestKeys.formSliderRating,
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.round().toString(),
                      onChanged: (v) => setState(() => _rating = v),
                    ),
                  ),
                  Text(
                    '${_rating.round()}/5',
                    key: TestKeys.formSliderValueText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              TextFormField(
                key: TestKeys.formDateField,
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    _dateController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.formTimeField,
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null && context.mounted) {
                    _timeController.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: TestKeys.formSubmitButton,
                      onPressed: _submitForm,
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      key: TestKeys.formResetButton,
                      onPressed: _resetForm,
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
