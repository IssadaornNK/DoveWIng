import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'DoveWing',
          style: TextStyle(color: Colors.blue, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.blue),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign for today',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildCampaignCard(context),
              SizedBox(height: 10),
              _buildCampaignCard(context),
              SizedBox(height: 10),
              _buildCampaignCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/campaign');
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              color: Colors.grey[300],
            ),
            SizedBox(height: 10),
            Text(
              'Campaign name',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut',
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  String? _selectedDonation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Campaign Details',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.grey[300],
              ),
              SizedBox(height: 20),
              Text(
                'Campaign name',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Donate',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(height: 10),
              _buildDonationOption('One-time donation: \$2.59', 'one-time'),
              SizedBox(height: 10),
              _buildDonationOption(
                  'Continuous donation: \$0.49/month', 'continuous'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedDonation != null
                    ? () {
                        // Handle submit donation
                        print('Selected donation: $_selectedDonation');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                  // onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationOption(String text, String value) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
      ),
      child: RadioListTile<String>(
        title: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
        value: value,
        groupValue: _selectedDonation,
        onChanged: (String? newValue) {
          setState(() {
            _selectedDonation = newValue;
          });
        },
      ),
    );
  }
}
