import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DonatedPage extends StatefulWidget {
  const DonatedPage({super.key});

  @override
  State<DonatedPage> createState() => _DonatedPageState();
}

class _DonatedPageState extends State<DonatedPage> {
  String errorMessage = '';
  bool isLoading = true;
  List<Map<String, dynamic>> donatedCampaigns = [];

  @override
  void initState() {
    super.initState();
    fetchDonatedCampaigns();
  }

  Future<void> fetchDonatedCampaigns() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage = 'No token found';
        isLoading = false;
      });
      return;
    }

    try {
      final donationResponse = await http.get(
          Uri.parse('http://localhost:3307/user/donations'),
          headers: {'Authorization': 'Bearer $token'});

      log('token: $token');
      log('Donation Response status: ${donationResponse.statusCode}');
      log('Donation Response body: ${donationResponse.body}');

      if (donationResponse.statusCode == 200) {
        final donations = jsonDecode(donationResponse.body);
        List<Map<String, dynamic>> formattedDonations =
            List<Map<String, dynamic>>.from(donations).map((donation) {
          DateTime originalDate = DateTime.parse(donation['date']);
          DateTime newDate = originalDate.add(const Duration(days: 1));
          String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

          return {...donation, 'date': formattedDate};
        }).toList();

        log('Donation Data: $donations');

        setState(() {
          isLoading = false;
          donatedCampaigns = formattedDonations;
        });
      } else {
        final errorDonationData = jsonDecode(donationResponse.body);
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to fetch donated campaigns data: ${errorDonationData['message']}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

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
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Donated Campaigns',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: donatedCampaigns.length,
                          itemBuilder: (context, index) {
                            final donatedCampaign = donatedCampaigns[index];
                            return Column(
                              children: [
                                _buildDonatedCampaignCard(
                                  context,
                                  imagePath: donatedCampaign['imgurl'],
                                  campaignName: donatedCampaign['name'],
                                  campaignDetails: donatedCampaign['details'],
                                ),
                                if (index < donatedCampaigns.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

Widget _buildDonatedCampaignCard(BuildContext context,
    {String? imagePath, String? campaignName, String? campaignDetails}) {
  return GestureDetector(
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
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
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            campaignDetails!,
            style: const TextStyle(
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}
