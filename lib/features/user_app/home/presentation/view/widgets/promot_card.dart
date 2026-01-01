import 'package:flutter/material.dart';
import 'package:tabiby/core/Api_services/urls.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../../../../core/utils/assets_data.dart';
import '../../../data/models/promot_model.dart';

class PromotCard extends StatelessWidget {
  const PromotCard({super.key, required this.promot});

  final Promot promot;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final imageWidth = cardWidth * 0.95;
        final positionOffset = -cardWidth * 0.20;

        return Container(
          height: 160,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColors,
                AppColors.primaryColors.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColors.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Decorative background circle
              Positioned(
                right: isRtl ? null : -50,
                left: isRtl ? -50 : null,
                top: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // 2. The Image
              Positioned(
                bottom: 0,
                right: isRtl ? null : positionOffset,
                left: isRtl ? positionOffset : null,
                top: -30,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(isRtl ? -1.0 : 1.0, 1.0, 1.0),
                  child: promot.img == null
                      ? Image.asset(
                          AssetsData.defaultDoctor,
                          width: imageWidth,
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          Urls.fixUrl(promot.img!),
                          width: imageWidth,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AssetsData.defaultDoctor,
                              width: imageWidth,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                ),
              ),

              // 3. Text and Button Content
              Align(
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: SizedBox(
                  // Limit content width to 65% so it doesn't overlap the image
                  width: cardWidth * 0.65,
                  height: 160,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isRtl
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // Expanded + FittedBox ensures text fits all available height
                        Expanded(
                          child: Align(
                            alignment: isRtl
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown, // Shrinks text if too big
                              alignment: isRtl
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: SizedBox(
                                // Forces wrapping before shrinking
                                width: cardWidth * 0.55,
                                child: Text(
                                  promot.information ??
                                      'looking_for_a_professional_dermatologist'
                                          .tr(context),
                                  textAlign: isRtl
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        18, // Base size (will shrink if needed)
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
