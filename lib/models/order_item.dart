class OrderItem {
  final String productId;
  final String productName;
  final double price;
  int quantity;
  final List<String> selectedAddons;
  final String? notes;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.selectedAddons = const [],
    this.notes,
  });

  double get total => price * quantity;
}
