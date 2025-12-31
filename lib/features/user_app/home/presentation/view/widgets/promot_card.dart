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

        final imageWidth = cardWidth * 1;

        final positionOffset = -cardWidth * 0.22;

        return Container(
          height: 160,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [AppColors.primaryColors, AppColors.secColors],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 0,

                right: isRtl ? null : positionOffset,

                left: isRtl ? positionOffset : null,

                top: -40,
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
                        ),
                ),
              ),

              Align(
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: SizedBox(
                  width: cardWidth * 0.6,
                  height: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: isRtl
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: SizedBox(
                        width: (cardWidth * 0.6) - 40,
                        child: Text(
                          promot.information ??
                              'looking_for_a_professional_dermatologist'.tr(
                                context,
                              ),
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: cardWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
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
