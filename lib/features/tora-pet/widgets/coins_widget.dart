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
      ToraCoinsService.getCoins()
          .then((result) {
            coins.value = result;
            isLoading.value = false;
          })
          .catchError((_) {
            coins.value = null;
            isLoading.value = false;
          });
      return null;
    }, []);

    if (isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono de la moneda
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(
              'assets/images/tora/tora_coin.png',
              fit: BoxFit.contain,
            ),
          ),

          // Separador
          const SizedBox(width: 8),

          // Cantidad
          Text(
            coins.value != null ? coins.value!.toString() : '0',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
