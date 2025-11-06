import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/tora-pet/services/tora_coins_service.dart';
import 'package:tora_frontend/features/tora-pet/models/coin.dart';

class CoinsWidget extends HookWidget {
	const CoinsWidget({super.key});

	@override
	Widget build(BuildContext context) {
		final coins = useState<Coin?>(null);
		final isLoading = useState(true);

		useEffect(() {
			ToraCoinsService.getCoins().then((result) {
				coins.value = result;
				isLoading.value = false;
			}).catchError((_) {
				coins.value = null;
				isLoading.value = false;
			});
			return null;
		}, []);

		if (isLoading.value) {
			return const Center(child: CircularProgressIndicator());
		}

		if (coins.value == null || coins.value!.value == 0) {
			return const Center(child: Text('0'));
		}

		return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
            ),
            child: Image.asset(
            'assets/images/tora/tora_coin.png',
            width: 20,
            height: 20,
          )),
          
          
          
        
          
        ],
      ),
    );
	}
}
