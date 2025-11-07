import 'package:flutter/material.dart';

void showCoinRewardDialog(BuildContext context, int coinsWon, String? message, Function()? onDialogClosed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _CoinRewardDialog(coinsWon: coinsWon, message: message, onDialogClosed: onDialogClosed),
  );
}

class _CoinRewardDialog extends StatefulWidget {
  final int coinsWon;
  final String? message;
  final Function()? onDialogClosed;

  const _CoinRewardDialog({super.key, required this.coinsWon, this.message, this.onDialogClosed});

  @override
  State<_CoinRewardDialog> createState() => _CoinRewardDialogState();
}

class _CoinRewardDialogState extends State<_CoinRewardDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Inicia la animación al abrir el diálogo
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen de Tora con tragamonedas
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/tora/tora_slot_machine.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              flex: 0,
              child: Text(
              widget.message ?? '¡Felicidades!',
              textAlign: TextAlign.center,
            
              
              style:  TextStyle(

                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                
              ),
            )),
            const SizedBox(height: 16),
            

            // Banner animado de recompensa
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.amber.shade700, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events,
                          color: Colors.amber.shade800, size: 28),
                      const SizedBox(width: 8),
                      

                      Text(
                        '¡Ganaste ${widget.coinsWon} 🪙!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Botón para continuar
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: cs.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  if (widget.onDialogClosed != null) {
                    widget.onDialogClosed!(),
                  }
                },
                child: const Text(
                  '¡Genial!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
