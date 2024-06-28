class User {
  final String username;
  final String profilePictureUrl;
  final List<Donation> pastDonations;

  User({
    required this.username,
    required this.profilePictureUrl,
    required this.pastDonations,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var donationsJson = json['pastDonations'] as List;
    List<Donation> donationsList = donationsJson.map((i) => Donation.fromJson(i)).toList();

    return User(
      username: json['username'],
      profilePictureUrl: json['profilePictureUrl'],
      pastDonations: donationsList,
    );
  }
}

class Donation {
  final String date;
  final String amount;
  final String type;

  Donation({
    required this.date,
    required this.amount,
    required this.type,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      date: json['date'],
      amount: json['amount'],
      type: json['type'],
    );
  }
}
