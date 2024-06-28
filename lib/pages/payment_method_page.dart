import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super. key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
            const SizedBox(height: 20),
          const  PaymentOption(
              label: 'Visa Card',
              value: 'visa',
              icon: Icons.credit_card,
              options: [
                'Option 1',
                'Option 2',
                'Option 3',
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Pay securely with your bank account using Visa or MasterCard',
                style: GoogleFonts.inika(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:  Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                labelStyle: GoogleFonts.inika(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name on Card',
                labelStyle: GoogleFonts.inika(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      labelStyle: GoogleFonts.inika(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: GoogleFonts.inika(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 119, 208),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment_success');
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
    );
  }
}

class PaymentOption extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final List<String> options;

 const PaymentOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.options,
    super.key,
  });

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  String? selectedValue;
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
                color: selectedValue == widget.value
                    ? const Color.fromARGB(255, 5, 119, 208)
                    : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Radio<String>(
                  value: widget.value,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
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
                      color:  Color.fromARGB(255, 5, 119, 208),
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
                            color:  Color.fromARGB(255, 5, 119, 208),
                          ),
                        ),
                      ),
                      onTap: () {
                        // Perform action when an option is tapped
                       if (kDebugMode) {
                         print('Option selected: $option');
                       }
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