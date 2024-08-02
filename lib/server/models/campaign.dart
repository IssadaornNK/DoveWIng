class Campaign {
  final String title;
  final String description;
  final String imageUrl;
  final bool isPayment;

  Campaign({required this.title, required this.description, required this.imageUrl, required this.isPayment});
}

class ProgressCampaign {
  late int? donationId;
  late String title;
  late String description;
  late final String imageUrl;
  late final bool isPayment;

  ProgressCampaign({this.donationId, required this.title, required this.description, required this.imageUrl, required this.isPayment});
}