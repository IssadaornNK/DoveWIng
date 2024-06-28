import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dove Wing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Campaign name',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultrices eros in cursus turpis massa tincidunt dui. Eu ultrices vitae auctor eu augue ut. Egestas sed tempus urna et pharetra.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                FormBuilderRadioGroup<String>(
                  name: 'donation_amount', // Replace with a suitable name
                  decoration: InputDecoration(labelText: 'Donation Amount'),
                  options: [
                    FormBuilderFieldOption(
                        value: 'once_259', child: Text('One-time \$2.59')),
                    FormBuilderFieldOption(
                        value: 'monthly_059', child: Text('Continue \$0.59/m')),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Donate'),
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      // Process donation
                      print(_formKey.currentState!.value);
                    } else {
                      print("validation failed");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
