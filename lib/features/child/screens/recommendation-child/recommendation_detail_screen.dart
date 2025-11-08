import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/child/models/recommendation.dart';
import 'package:tora_frontend/core/widgets/alert_win_coins_helper.dart';
import 'package:tora_frontend/features/tora-pet/services/coins_state.dart';

class RecommendationDetailScreen extends StatefulWidget {
  final RecommendationItem recommendation;

  const RecommendationDetailScreen({super.key, required this.recommendation});

  @override
  State<RecommendationDetailScreen> createState() =>
      _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState
    extends State<RecommendationDetailScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  void _nextStep() {
    if (_currentStep < widget.recommendation.steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Recomendación completada
  
      showCoinRewardDialog(context, coinsWon: 1000, message: widget.recommendation.successMessage);
      Navigator.of(context).pop();
  }
  }
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / widget.recommendation.steps.length;

    return Scaffold(
      backgroundColor: ToraTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: widget.recommendation.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ToraTheme.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalle Recomendación',
          style: const TextStyle(
            color: ToraTheme.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header con título y progreso
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: widget.recommendation.cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        widget.recommendation.icon,
                        color: widget.recommendation.iconColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recommendation.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ToraTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Paso ${_currentStep + 1} de ${widget.recommendation.steps.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: ToraTheme.darkText.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Barra de progreso
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.recommendation.iconColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // Contenido del paso
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.recommendation.steps.length,
              itemBuilder: (context, index) {
                final currentStep = widget.recommendation.steps[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Número del paso
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.recommendation.cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.recommendation.iconColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${currentStep.stepNumber}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: widget.recommendation.iconColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Pictograma o ícono
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: widget.recommendation.cardColor.withOpacity(
                            0.5,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          currentStep.fallbackIcon ?? Icons.help_outline,
                          size: 70,
                          color: widget.recommendation.iconColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título del paso
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: widget.recommendation.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.recommendation.iconColor.withOpacity(
                              0.3,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          currentStep.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ToraTheme.darkText,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Descripción
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ToraTheme.pureWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ToraTheme.lightGray,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          currentStep.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ToraTheme.darkText,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botones de navegación
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
            decoration: BoxDecoration(
              color: ToraTheme.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: widget.recommendation.iconColor,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: widget.recommendation.iconColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Anterior',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: widget.recommendation.iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.recommendation.iconColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep < widget.recommendation.steps.length - 1
                              ? 'Siguiente'
                              : '¡Entendido!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentStep < widget.recommendation.steps.length - 1
                              ? Icons.arrow_forward
                              : Icons.check_circle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
