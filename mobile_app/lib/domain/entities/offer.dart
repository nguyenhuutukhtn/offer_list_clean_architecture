class Offer {
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final double originalPrice;
  final double discountedPrice;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.originalPrice,
    required this.discountedPrice,
  });
}