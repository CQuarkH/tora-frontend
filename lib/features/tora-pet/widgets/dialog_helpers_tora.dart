import 'package:flutter/material.dart';
// widgets/dialogs.dart
import 'dart:math' as math;

import 'package:tora_frontend/features/tora-pet/services/accessory_storage_service.dart';

AccessoryStorageService _accessoryStorageService = AccessoryStorageService();

Future<bool?> showConfirmPurchaseDialog(
  BuildContext context, {
  required String itemName,
  required int price,
  required int currentCoins,
}) {
  final cs = Theme.of(context).colorScheme;
  final size = MediaQuery.of(context).size;
  final isNarrow = size.width < 340;                
  final isTiny = size.width < 300;                  
  final textScaler = MediaQuery.of(context).textScaler;
  final scaled = textScaler.scale(isTiny ? 0.85 : (isNarrow ? 0.92 : 1.0)); // Escala global

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SafeArea( // evita choques con notches/teclado
        child: MediaQuery( // aplica escala de texto SOLO a este diálogo
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scaled)),
          child: SingleChildScrollView( // evita overflow vertical
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título compacto
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '¿Listo para comprar?',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Imagen con tope simple
                SizedBox(
                  width: math.min(size.width * 0.5, 180),
                  height: math.min(size.width * 0.5, 180),
                  child: Image.asset(
                    'assets/images/tora/tora_seller.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                // Texto intro (no desborda)
                Text(
                  '¡Este objeto se ve genial!',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 12),

                // Descripción (2 líneas máx)
                Text(
                  '¿Quieres llevar el "$itemName" por $price 🪙?',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: cs.onSurface),
                ),

                const SizedBox(height: 24),

                // Caja de monedas
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cs.primary, width: 1.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Tienes $currentCoins monedas disponibles.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: cs.onSurface),
                  ),
                ),

                const SizedBox(height: 20),

                // Botones compactos
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text(
                          'Tal vez luego',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          '¡Sí, comprar!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


Future<void> showInsufficientCoinsDialog(
  BuildContext context, {
  required String itemName,
  required int required,
  required int current,
}) {
  final cs = Theme.of(context).colorScheme;
  final size = MediaQuery.of(context).size;
  final isNarrow = size.width < 340;
  final isTiny = size.width < 300;
  final baseScaler = MediaQuery.of(context).textScaler;
  final scaled = baseScaler.scale(isTiny ? 0.85 : (isNarrow ? 0.92 : 1.0));

  final shortfall = (required - current).clamp(0, required);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scaled)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28), // Aumentado aquí
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TÍTULO + CIERRE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Monedas insuficientes',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
                      onPressed: () => Navigator.of(ctx).pop(),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// IMAGEN
                SizedBox(
                  width: math.min(size.width * 0.5, 180),
                  height: math.min(size.width * 0.5, 180),
                  child: Image.asset(
                    'assets/images/tora/tora_seller_sad.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                /// TEXTO INTRODUCTORIO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '¡Vaya!\nAún no tienes suficientes monedas para esto.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// MENSAJE DE DETALLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: cs.primary,
                      ),
                      children: [
                        TextSpan(text: '“$itemName” cuesta '),
                        TextSpan(
                          text: '$required 🪙',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        const TextSpan(text: ', pero tú tienes '),
                        TextSpan(
                          text: '$current 🪙',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const TextSpan(text: ' por ahora.'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// CAJA DE DÉFICIT
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.secondary, width: 1.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    'Te faltan $shortfall 🪙 para completar la compra.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: cs.secondary),
                  ),
                ),

                const SizedBox(height: 32),

                /// BOTÓN
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: cs.primaryContainer,
                      foregroundColor: cs.onSurface,
                    ),
                    child: Text(
                      'Entendido',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
