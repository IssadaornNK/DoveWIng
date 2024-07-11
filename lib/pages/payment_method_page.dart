import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String selectedValue = 'Visa Card'; // Default value

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(currentYear, currentMonth),
      firstDate: DateTime(currentYear, currentMonth),
      lastDate: DateTime(currentYear + 10),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 5, 119, 208),
            hintColor: const Color.fromARGB(255, 5, 119, 208),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final formattedDate = '${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().substring(2)}';
      setState(() {
        _expiryDateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color.fromARGB(255, 5, 119, 208),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'DoveWing',
            style: GoogleFonts.inika(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 119, 208),
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 5, 119, 208),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Payment Method',
                style: GoogleFonts.inika(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PaymentOption(
                label: selectedValue,
                value: selectedValue,
                icon: Icons.credit_card,
                options: [
                  selectedValue == 'Visa Card' ? 'Master Card' : 'Visa Card'
                ],
                onSelected: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Pay securely with your bank account using Visa or Master Card',
                  style: GoogleFonts.inika(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 119, 208),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: GoogleFonts.inika(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CardNumberInputFormatter(),
                ],
                maxLength: 19, // Allow space-separated 16 digits + spaces (4 groups of 4)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  final cleanedValue = value.replaceAll(' ', '');
                  if (!RegExp(r'^\d{16}$').hasMatch(cleanedValue)) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name on Card',
                  labelStyle: GoogleFonts.inika(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name on card';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectExpiryDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      labelStyle: GoogleFonts.inika(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your expiry date';
                      }
                      if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                        return 'Expiry date must be in the format MM/YY';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  labelStyle: GoogleFonts.inika(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CvvInputFormatter(),
                ],
                maxLength: 3, // Allow only 3 digits
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CVV';
                  }
                  if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 5, 119, 208),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pushNamed(context, '/payment_success');
                      }
                    },
                    child: Text(
                      'Donate',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newString = newValue.text.replaceAll(' ', '');
    if (newString.length > 16) {
      // limit to 16 digits
      return oldValue;
    }

    String formattedString = '';
    
    for (int i = 0; i < newString.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedString += ' ';
      }
      formattedString += newString[i];
    }
    
    return newValue.copyWith(
      text: formattedString,
      selection: TextSelection.collapsed(offset: formattedString.length),
    );
  }
}

class CvvInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newString = newValue.text.replaceAll(' ', '');
    if (newString.length > 3) {
      // limit to 3 digits
      return oldValue;
    }
    return newValue;
  }
}

class PaymentOption extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const PaymentOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.options,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.value == widget.label
                    ? const Color.fromARGB(255, 5, 119, 208)
                    : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: widget.label,
                  groupValue: widget.value,
                  onChanged: (value) {
                    setState(() {
                      widget.onSelected(value!);
                    });
                  },
                  activeColor: const Color.fromARGB(255, 5, 119, 208),
                ),
                Icon(
                  widget.icon,
                  color: const Color.fromARGB(255, 5, 119, 208),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: GoogleFonts.inika(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 119, 208),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color.fromARGB(255, 5, 119, 208),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.options
                  .map(
                    (option) => ListTile(
                      title: Text(
                        option,
                        style: GoogleFonts.inika(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 5, 119, 208),
                          ),
                        ),
                      ),
                      onTap: () {
                        // Perform action when an option is tapped
                        if (kDebugMode) {
                          print('Option selected: $option');
                        }
                        widget.onSelected(option);
                        setState(() {
                          isExpanded = false;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
