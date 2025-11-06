class Accessory {
  final String id;
  final String path;
  final String name;
  final int price;
  final bool isBought;

  const Accessory({
    required this.id,
    required this.path,
    required this.name,
    required this.price,
    required this.isBought,
  });

  Accessory copyWith({
    String? id,
    String? path,
    String? name,
    int? price,
    bool? isBought,
  }) {
    return Accessory(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      price: price ?? this.price,
      isBought: isBought ?? this.isBought,
    );
  }
}