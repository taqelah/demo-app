import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../models/checkout_info.dart';

class CheckoutInfoScreen extends StatefulWidget {
  const CheckoutInfoScreen({super.key});

  @override
  State<CheckoutInfoScreen> createState() => _CheckoutInfoScreenState();
}

class _CheckoutInfoScreenState extends State<CheckoutInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _info = CheckoutInfo();

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _proceed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pushNamed(context, '/checkout-review', arguments: _info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your shipping details',
                key: TestKeys.checkoutInfoTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: TestKeys.checkoutInfoFullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: _requiredValidator,
                onSaved: (value) => _info.fullName = value!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.checkoutInfoAddress1,
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: _requiredValidator,
                onSaved: (value) => _info.addressLine1 = value!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.checkoutInfoAddress2,
                decoration: const InputDecoration(
                    labelText: 'Address Line 2 (Optional)'),
                onSaved: (value) => _info.addressLine2 = value?.trim() ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.checkoutInfoCity,
                decoration: const InputDecoration(labelText: 'City'),
                validator: _requiredValidator,
                onSaved: (value) => _info.city = value!.trim(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: TestKeys.checkoutInfoState,
                      decoration: const InputDecoration(labelText: 'State'),
                      validator: _requiredValidator,
                      onSaved: (value) => _info.state = value!.trim(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: TestKeys.checkoutInfoZip,
                      decoration:
                          const InputDecoration(labelText: 'Zip Code'),
                      keyboardType: TextInputType.number,
                      validator: _requiredValidator,
                      onSaved: (value) => _info.zipCode = value!.trim(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: TestKeys.checkoutInfoCountry,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: _requiredValidator,
                onSaved: (value) => _info.country = value!.trim(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: TestKeys.checkoutInfoProceedButton,
                onPressed: _proceed,
                child: const Text('To Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
