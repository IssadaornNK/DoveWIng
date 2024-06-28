import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

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
            Center(
              child: Image.asset(
                'images/campaign_image.png', // Replace with your image asset
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Campaign Name',
              style: GoogleFonts.inika(
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 119, 208),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Details about the campaign go here. Provide a brief description of the campaign.',
              style: GoogleFonts.inika(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 5, 119, 208),
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const PaymentOption(
              label: 'One-time 2.59\$',
              value: 'one_time',
            ),
            const SizedBox(height: 10),
           const PaymentOption(
              label: 'Continue 0.59\$/m',
              value: 'continue',
            ),
            const SizedBox(height: 20),
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
                    Navigator.pushNamed(context, '/payment_method');
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
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatefulWidget {
  final String label;
  final String value;

  const PaymentOption({required this.label, required this.value, super.key});

  @override
 State<PaymentOption> createState() => _PaymentOptionState();
}


class _PaymentOptionState extends State<PaymentOption> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = widget.value;
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
            Text(
              widget.label,
              style: GoogleFonts.inika(
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 119, 208),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
