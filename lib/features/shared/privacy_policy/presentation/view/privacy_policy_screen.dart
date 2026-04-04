import 'package:flutter/material.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../core/utils/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'app_title_privacy'.tr(context)),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: <Widget>[
            _PolicyHeroCard(
              icon: Icons.privacy_tip_outlined,
              badge: 'privacy_policy'.tr(context),
              title: 'privacy_welcome'.tr(context),
              subtitle: 'privacy_intro'.tr(context),
            ),
            const SizedBox(height: 14),
            _LastUpdatedCard(text: 'privacy_last_updated'.tr(context)),
            const SizedBox(height: 18),
            _PolicySectionCard(
              sectionNumber: '01',
              title: 'privacy_header_1'.tr(context),
              items: <String>[
                'privacy_list_1a'.tr(context),
                'privacy_list_1b'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '02',
              title: 'privacy_header_2'.tr(context),
              items: <String>[
                'privacy_list_2a'.tr(context),
                'privacy_list_2b'.tr(context),
                'privacy_list_2c'.tr(context),
                'privacy_list_2d'.tr(context),
                'privacy_list_2e'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '03',
              title: 'privacy_header_3'.tr(context),
              items: <String>[
                'privacy_list_3a'.tr(context),
                'privacy_list_3b'.tr(context),
                'privacy_list_3c'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '04',
              title: 'privacy_header_4'.tr(context),
              paragraphs: <String>['privacy_content_4'.tr(context)],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '05',
              title: 'privacy_header_5'.tr(context),
              items: <String>[
                'privacy_list_5a'.tr(context),
                'privacy_list_5b'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '06',
              title: 'privacy_header_6'.tr(context),
              paragraphs: <String>['privacy_content_6'.tr(context)],
            ),
            const SizedBox(height: 14),
            _PolicySectionCard(
              sectionNumber: '07',
              title: 'privacy_header_7'.tr(context),
              paragraphs: <String>['privacy_content_7'.tr(context)],
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyHeroCard extends StatelessWidget {
  const _PolicyHeroCard({
    required this.icon,
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String badge;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.16,
                          ),
                        ),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _PolicyHeroChip(
                      icon: Icons.lock_outline_rounded,
                      label: 'privacy_header_1'.tr(context),
                    ),
                    _PolicyHeroChip(
                      icon: Icons.security_rounded,
                      label: 'privacy_header_3'.tr(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyHeroChip extends StatelessWidget {
  const _PolicyHeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: AppColors.primaryColors),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1F2C28),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LastUpdatedCard extends StatelessWidget {
  const _LastUpdatedCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule_outlined,
              color: AppColors.primaryColors,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  const _PolicySectionCard({
    required this.sectionNumber,
    required this.title,
    this.items = const <String>[],
    this.paragraphs = const <String>[],
  });

  final String sectionNumber;
  final String title;
  final List<String> items;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  sectionNumber,
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2C28),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: 34,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 14),
          if (paragraphs.isNotEmpty)
            ...paragraphs.map(
              (String paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  paragraph,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.65,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          if (items.isNotEmpty)
            ...items.map(
              (String item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.primaryColors,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade700,
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
  }
}
