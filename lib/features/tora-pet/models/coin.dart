
class Coin {
  final String value;

  Coin({required this.value});
  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      value: json['value'],
    );
  }
  
  

}