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
              // Handle profile icon press
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
                style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
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

class CampaignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign Details'),
      ),
      body: Center(
        child: Text(
          'Campaign Details Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}