import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/tora-pet/models/accessory.dart';
import 'package:tora_frontend/features/tora-pet/models/coin.dart';

class ToraCoinsService{
   static final _apiClient = ApiClient();
   static int coins = 1000;

   static Future<Coin> getCoins() async {

    final AuthService _authService = AuthService();
    final user = await _authService.getCurrentUser();
    print('User ID: ${user?.id}');
  
    final response = await _apiClient.get('/coins/${user?.id}');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.body as List;
      return Coin.fromJson(data.first);
    } else {
      throw Exception('Failed to load coins');
    }
  }

  

 static int getUserCoins() {
  return coins;
}

static void deductCoins(int amount) {
  coins -= amount;
}

static void markAccessoryBought(Accessory accessory) {

}



}