import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../models/checkout_info.dart';
import '../widgets/test_id.dart';

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
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TestId(
                TestKeys.checkoutInfoTitle,
                child: Text(
                  'Enter your shipping details',
                  key: TestKeys.checkoutInfoTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              TestId(
                TestKeys.checkoutInfoFullName,
                child: TextFormField(
                  key: TestKeys.checkoutInfoFullName,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: _requiredValidator,
                  onSaved: (value) => _info.fullName = value!.trim(),
                ),
              ),
              const SizedBox(height: 12),
              TestId(
                TestKeys.checkoutInfoAddress1,
                child: TextFormField(
                  key: TestKeys.checkoutInfoAddress1,
                  decoration: const InputDecoration(labelText: 'Address Line 1'),
                  validator: _requiredValidator,
                  onSaved: (value) => _info.addressLine1 = value!.trim(),
                ),
              ),
              const SizedBox(height: 12),
              TestId(
                TestKeys.checkoutInfoAddress2,
                child: TextFormField(
                  key: TestKeys.checkoutInfoAddress2,
                  decoration: const InputDecoration(
                      labelText: 'Address Line 2 (Optional)'),
                  onSaved: (value) => _info.addressLine2 = value?.trim() ?? '',
                ),
              ),
              const SizedBox(height: 12),
              TestId(
                TestKeys.checkoutInfoCity,
                child: TextFormField(
                  key: TestKeys.checkoutInfoCity,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: _requiredValidator,
                  onSaved: (value) => _info.city = value!.trim(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TestId(
                             TestKeys.checkoutInfoState,
                             child: TextFormField(
                      key: TestKeys.checkoutInfoState,
                      decoration: const InputDecoration(labelText: 'State'),
                      validator: _requiredValidator,
                      onSaved: (value) => _info.state = value!.trim(),
                    ),
                           ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TestId(
                             TestKeys.checkoutInfoZip,
                             child: TextFormField(
                      key: TestKeys.checkoutInfoZip,
                      decoration:
                          const InputDecoration(labelText: 'Zip Code'),
                      keyboardType: TextInputType.number,
                      validator: _requiredValidator,
                      onSaved: (value) => _info.zipCode = value!.trim(),
                    ),
                           ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TestId(
                TestKeys.checkoutInfoCountry,
                child: TextFormField(
                  key: TestKeys.checkoutInfoCountry,
                  decoration: const InputDecoration(labelText: 'Country'),
                  validator: _requiredValidator,
                  onSaved: (value) => _info.country = value!.trim(),
                ),
              ),
              const SizedBox(height: 24),
              TestId(
                TestKeys.checkoutInfoProceedButton,
                child: ElevatedButton(
                  key: TestKeys.checkoutInfoProceedButton,
                  onPressed: _proceed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('To Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
