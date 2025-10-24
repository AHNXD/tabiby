import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect current language direction (LTR or RTL)
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Use a LayoutBuilder to get the *PromoCard's* container width,
    // instead of the whole screen width, for responsive positioning.
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        // The image's width is 'cardWidth * 0.45' (from Image.asset width)
        // The image's desired position is to be near the end of the container.
        // We calculate the left/right position to push the image to the end side.
        // For LTR: Right side is 'cardWidth * 0.28' from the left.
        // For RTL: Left side is 'cardWidth * 0.28' from the right.
        // A better approach is to use 'left' for LTR and 'right' for RTL
        // with a small negative offset to move it slightly out of the card (like -10)
        // or a small positive offset from the edge.

        // Image width: cardWidth * 0.45.
        // Let's set the image's "inner edge" (Left for LTR, Right for RTL)
        // to be at approximately 75% of the card's width for a fixed look,
        // or simply align its center near the end.

        // **Revised Positioning Logic:**
        // To align the image's center near the end of the card,
        // we'll calculate the offset from the edge.
        // We'll use a fixed percentage (e.g., 25%) relative to the card's width
        // to position the image's center, ensuring it's always near the edge
        // regardless of screen size, as long as the *card* fills the width.

        final imageWidth = cardWidth * 1;
        // Position the image so its center is at about 75% of the card's width.
        // This puts its left/right edge close to the card edge.
        // Center position: cardWidth * 0.75
        // Positioned 'left' for LTR: (cardWidth * 0.75) - (imageWidth / 2)
        // Positioned 'right' for RTL: (cardWidth * 0.25) - (imageWidth / 2)

        // Alternatively, let's simplify and just set the image's position
        // relative to the nearest edge (left for LTR, right for RTL).
        // Let's use a fixed value to pull the image *out* of the container a little.
        final positionOffset =
            -cardWidth *
            0.22; // Pull image out by 15% of card width for better visual overlap

        return Container(
          height: 160,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF81C784), Color.fromARGB(255, 5, 89, 53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Responsive + direction-aware image
              Positioned(
                bottom: 0,
                // LTR: Place the image starting from the left edge.
                // We shift it to the right using a calculated 'left' value.
                // The image's effective area will be (left...left + imageWidth).
                // Let's position the image's *center* near the edge.
                // **Corrected positioning to align image center near the card's end:**
                // LTR (right-aligned): Set 'left' position.
                // 'left' is (cardWidth - imageWidth) - offset_from_edge
                // The original *left* value of screenWidth * 0.28 was an arbitrary offset
                // for a specific screen size.
                // To keep the image centered around the **end** of the card:
                // We use 'right' for LTR and 'left' for RTL.

                // For LTR, the image is on the RIGHT. Use 'right'.
                right: isRtl ? null : positionOffset,
                // For RTL, the image is on the LEFT. Use 'left'.
                left: isRtl ? positionOffset : null,

                top: -40,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(
                      isRtl ? -1.0 : 1.0, // flip horizontally if RTL
                      1.0,
                      1.0,
                    ),
                  child: Image.asset(
                    'assets/images/doctor.png',
                    width: imageWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Text & Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'looking_for_a_professional_dermatologist'.tr(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'explore'.tr(context),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
