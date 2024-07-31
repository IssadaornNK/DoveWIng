class Campaign {
  final int? donationId;
  final String title;
  final String description;
  final String imageUrl;
  final bool isPayment;

  Campaign({this.donationId, required this.title, required this.description, required this.imageUrl, required this.isPayment});
}