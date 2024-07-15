// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';

import 'package:dove_wings/server/models/campaign.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Function to get the token from secure storage
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<Campaign> campaigns = [
    Campaign(
      title: 'StopTrashPlant',
      description:
          '#StopTrashPlant- Do not waste life, become a Organ donor. The organs recreated in this Print Advertisement is to spread the awareness of Donate Organ, To celebrate the upcoming National Organ Donation Day, Fundación Argentina de Trasplante and advertising agency DDB joined efforts to come up with a campaign that took place on the streets of Buenos Aires. The campaign had two main objectives: to raise awareness about organ donation and to let people express their willingness to become organ donors.',
      imageUrl: 'images/campaigns/campaign1.jpg',
    ),
    Campaign(
      title: 'People at Work',
      description:
          'Paving the Way for Gender Equality in Construction: A Groundbreaking Initiative ‘People at Work’ by Publicis Brazil and the Women in Construction Institute. In a bid to catalyze a transformative shift in the construction industry, Publicis Brazil, in collaboration with the Women in Construction Institute, has launched a groundbreaking initiative ‘People at Work’ on this year’s International Women’s Day. With women accounting for just one in ten construction workers, there’s a pressing need to address the gender disparities entrenched within this historically male-dominated sector. This article delves into the initiative’s objectives, impact, and how you can contribute to fostering a more inclusive work environment in construction.',
      imageUrl: 'images/campaigns/campaign2.jpg',
    ),
    Campaign(
      title: 'Land of the Unfree',
      description:
          "'Land of the Unfree' On June 24th, 2022 the United States Supreme Court ruled to end protections to the right to abortion. This means that now individual states across the USA regulate the right to abortion. Abortion is now totally or near-totally banned in 26 states in the USA — more than half of the country — with more poised to enact restrictions or bans on the right to abortion.",
      imageUrl: 'images/campaigns/campaign3.jpg',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'DoveWing',
          style: TextStyle(color: Colors.blue, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.blue),
            onPressed: () {
              // Handle profile icon press
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Campaign for today',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildCampaignCard(context,
                  imagePath: campaigns[0].imageUrl,
                  campaignName: campaigns[0].title,
                  campaignDetails: campaigns[0].description),
              const SizedBox(height: 10),
              _buildCampaignCard(context,
                  imagePath: campaigns[1].imageUrl,
                  campaignName: campaigns[1].title,
                  campaignDetails: campaigns[1].description),
              const SizedBox(height: 10),
              _buildCampaignCard(context,
                  imagePath: campaigns[2].imageUrl,
                  campaignName: campaigns[2].title,
                  campaignDetails: campaigns[2].description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context,
      {String? imagePath, String? campaignName, String? campaignDetails}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/campaign',
            arguments: Campaign(
                title: campaignName,
                description: campaignDetails,
                imageUrl: imagePath ?? ''));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : const Center(
                      child: Text('No Image',
                          style: TextStyle(color: Colors.white))),
            ),
            const SizedBox(height: 10),
            Text(
              campaignName!,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 5),
            Text(
              campaignDetails!,
              style: const TextStyle(fontSize: 14),
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
  String? _selectedDonationName;
  String? _selectedDonationType;
  double? _selectedDonationAmount;

  @override
  Widget build(BuildContext context) {
    final Campaign campaign =
        ModalRoute.of(context)!.settings.arguments as Campaign;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text(
          'Campaign Details',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: deviceWidth,
                  height: deviceWidth * 0.56, // Maintain 16:9 aspect ratio
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      campaign.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )),
              const SizedBox(height: 20),
              Text(
                campaign.title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 10),
              Text(
                campaign.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Donate',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 10),
              _buildDonationOption('One-time donation: \$2.59', campaign.title,
                  'one-time', 2.59),
              const SizedBox(height: 10),
              _buildDonationOption('Continuous donation: \$0.49/month',
                  campaign.title, 'continuous', 0.49),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedDonationName != null &&
                        _selectedDonationType != null &&
                        _selectedDonationAmount != null
                    ? () async {
                        // Prepare donation data
                        final donationData = {
                          'name': _selectedDonationName,
                          'amount': _selectedDonationAmount,
                          'type': _selectedDonationType,
                        };

                        // Capture the context before the asynchronous operation
                        final currentContext = context;

                        // Make POST request to server
                        final token = await getToken();
                        if (token != null) {
                          final response = await post(
                            Uri.parse('http://localhost:3307/donations'),
                            body: jsonEncode(donationData),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token'
                            },
                          );
                          if (response.statusCode == 200) {
                            // Donation successful
                            log('Donation submitted successfully!');
                            // Show success message or navigate to confirmation screen (replace with your logic)
                            if (currentContext.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Donation submitted.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushNamed(currentContext,
                                  '/payment_method'); // Can be used for future payment flow
                            }
                          } else {
                            // Donation failed
                            log('Error submitting donation: ${response.statusCode}');
                            // Show error message to user (replace with your error handling)
                            if (currentContext.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Error donating. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          log('Token not found. Please log in again.');
                          if (currentContext.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Token not found. Please log in again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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

  Widget _buildDonationOption(
      String text, String name, String type, double amount) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
      ),
      child: RadioListTile<String>(
        title: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        ),
        value: type,
        groupValue: _selectedDonationType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedDonationName = name;
            _selectedDonationType = newValue;
            _selectedDonationAmount = amount;
          });
        },
      ),
    );
  }
}
