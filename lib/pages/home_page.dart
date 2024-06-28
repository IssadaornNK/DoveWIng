import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        centerTitle: true, // Centers the title
        title: Text(
          'DoveWing',
          style: GoogleFonts.inika(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: const Color.fromARGB(255, 5, 119, 208),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color.fromARGB(255, 5, 119, 208)),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
              // Handle profile icon tap
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            color: Color.fromARGB(255, 5, 119, 208),
            height: 1.0,
            thickness: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Campaign progress section
            Text(
              'Your campaign progress',
              style: GoogleFonts.inika(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color.fromARGB(255, 5, 119, 208),
              ),
            ),
            const SizedBox(height: 16),
            // Campaign progress box
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 5, 119, 208)),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/150',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Campaign Name',
                      style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This is a description of the campaign. It gives details about the campaign progress and goals.',
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Handle "See more" tap
                },
                child: Text(
                  'See more',
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color.fromARGB(255, 5, 119, 208),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Campaign for today section
            Text(
              'Campaign for today',
              style: GoogleFonts.inika(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color.fromARGB(255, 5, 119, 208),
              ),
            ),
            const SizedBox(height: 16),
            // Campaign for today box
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 5, 119, 208)),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/150',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Today\'s Campaign Name',
                      style: GoogleFonts.inika(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This is a description of today\'s campaign. It highlights what is planned for the day.',
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // List of other campaigns
            Text(
              'Other Campaigns',
              style: GoogleFonts.inika(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color.fromARGB(255, 5, 119, 208),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Campaign 1'),
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            // Add more campaign list items here
          ],
        ),
      ),
    );
  }
}
