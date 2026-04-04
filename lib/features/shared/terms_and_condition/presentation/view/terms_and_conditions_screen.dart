import 'package:flutter/material.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../core/utils/colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const String routeName = '/terms-and-conditions';

  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'app_title_terms'.tr(context)),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: <Widget>[
            _TermsHeroCard(
              title: 'app_title_terms'.tr(context),
              subtitle: 'terms_intro'.tr(context),
            ),
            const SizedBox(height: 18),
            _TermsNoticeCard(text: 'notice_important'.tr(context)),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '01',
              title: 'terms_header_1'.tr(context),
              paragraphs: <String>['terms_content_1'.tr(context)],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '02',
              title: 'terms_header_2'.tr(context),
              paragraphs: <String>[
                'terms_content_2a'.tr(context),
                'terms_content_2b'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '03',
              title: 'terms_header_3'.tr(context),
              paragraphs: <String>[
                'terms_content_3a'.tr(context),
                'terms_content_3b'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '04',
              title: 'terms_header_4'.tr(context),
              paragraphs: <String>['terms_content_4'.tr(context)],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '05',
              title: 'terms_header_5'.tr(context),
              paragraphs: <String>[
                'terms_content_5a'.tr(context),
                'terms_content_5b'.tr(context),
              ],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '06',
              title: 'terms_header_6'.tr(context),
              paragraphs: <String>['terms_content_6'.tr(context)],
            ),
            const SizedBox(height: 14),
            _TermsSectionCard(
              sectionNumber: '07',
              title: 'terms_header_7'.tr(context),
              paragraphs: <String>['terms_content_7'.tr(context)],
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsHeroCard extends StatelessWidget {
  const _TermsHeroCard({required this.title, required this.subtitle});

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
            bottom: 24,
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
                      child: const Icon(
                        Icons.gavel_rounded,
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
                        'terms_conditions'.tr(context),
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
                    _TermsHeroChip(
                      icon: Icons.policy_outlined,
                      label: 'terms_header_1'.tr(context),
                    ),
                    _TermsHeroChip(
                      icon: Icons.verified_user_outlined,
                      label: 'terms_header_5'.tr(context),
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

class _TermsHeroChip extends StatelessWidget {
  const _TermsHeroChip({required this.icon, required this.label});

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

class _TermsNoticeCard extends StatelessWidget {
  const _TermsNoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE28C63).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE28C63).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: Color(0xFFE28C63),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A5132),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsSectionCard extends StatelessWidget {
  const _TermsSectionCard({
    required this.sectionNumber,
    required this.title,
    required this.paragraphs,
  });

  final String sectionNumber;
  final String title;
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
          ...paragraphs.map(
            (String text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.65,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
