import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tabiby/core/utils/assets_data.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../core/utils/cache_helper.dart';
import '../models/diet_plan_response.dart';
import '../models/diet_request_data.dart';

class DietPdfBuilder {
  Future<Uint8List> build({
    required DietPlanResponse plan,
    required DietRequestData request,
    DateTime? createdAt,
  }) async {
    final String langCode = _resolveLanguageCode();
    final bool isRtl = langCode.toLowerCase().startsWith('ar');
    final AppLocalizations l10n = await _loadLocalizations(langCode);

    final pw.Font baseFont = await _loadFont(isRtl: isRtl);
    final theme = pw.ThemeData.withFont(
      base: baseFont,
      bold: baseFont,
      italic: baseFont,
      boldItalic: baseFont,
    );

    // Load the logo image (make sure the path matches your pubspec.yaml)
    final ByteData logoData = await rootBundle.load(
      AssetsData.logoGreen,
    ); // <-- Change this path to your actual logo path
    final pw.MemoryImage logoImage = pw.MemoryImage(
      logoData.buffer.asUint8List(),
    );

    // Upgraded Color Palette
    final PdfColor primary = PdfColor.fromInt(0xFF059669);
    final PdfColor secondary = PdfColor.fromInt(0xFF064E3B);
    final PdfColor border = PdfColor.fromInt(0xFFE2E8F0);
    final PdfColor muted = PdfColor.fromInt(0xFF64748B);
    final PdfColor lightBg = PdfColor.fromInt(0xFFF8FAFC);
    final PdfColor surfaceCard = PdfColor.fromInt(0xFFFFFFFF);
    final PdfColor accentLight = PdfColor.fromInt(
      0xFFECFDF5,
    ); // Very soft green

    final String exportDate = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(createdAt ?? DateTime.now());

    final pw.TextDirection textDirection = isRtl
        ? pw.TextDirection.rtl
        : pw.TextDirection.ltr;
    final pw.TextAlign textAlign = isRtl
        ? pw.TextAlign.right
        : pw.TextAlign.left;

    final pageTheme = pw.PageTheme(
      // Standard A4 format
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      theme: theme,
      textDirection: textDirection,
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: PdfColors.white), // Clean white background
      ),
    );

    // 595.27 is the standard A4 width in points. Subtract 64 for left (32) and right (32) margins.
    // This safely avoids any 'PdfPageFormat' import errors.
    final double safeContentWidth = 595.27 - 64;

    // Use pdfDoc to prevent naming conflicts with the 'pdf' package
    final pdfDoc = pw.Document(
      theme: theme,
      title: l10n.translate('diet_result_title'),
    );

    // ==========================================
    // PART 1: OVERVIEW PAGE
    // ==========================================
    pdfDoc.addPage(
      pw.MultiPage(
        maxPages: 200,
        pageTheme: pageTheme,
        header: (context) => _buildHeader(
          context,
          l10n,
          primary,
          muted,
          border,
          exportDate,
          logoImage,
        ),
        footer: (context) => _buildFooter(context, l10n, muted, border),
        build: (context) => [
          _titleCard(
            l10n: l10n,
            plan: plan,
            request: request,
            primary: primary,
            secondary: secondary,
            muted: muted,
            accentLight: accentLight,
            textAlign: textAlign,
          ),
          pw.SizedBox(height: 24),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                title: l10n.translate('diet_result_daily_macros'),
                secondary: secondary,
                textAlign: textAlign,
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _macroTile(
                    title: l10n.translate('diet_result_protein'),
                    value: plan.dailyMacrosSummary.protein,
                    primary: primary,
                    border: border,
                    lightBg: lightBg,
                  ),
                  _macroTile(
                    title: l10n.translate('diet_result_carbs'),
                    value: plan.dailyMacrosSummary.carbs,
                    primary: primary,
                    border: border,
                    lightBg: lightBg,
                  ),
                  _macroTile(
                    title: l10n.translate('diet_result_fats'),
                    value: plan.dailyMacrosSummary.fats,
                    primary: primary,
                    border: border,
                    lightBg: lightBg,
                  ),
                ],
              ),
            ],
          ),
          if (plan.localizedSummary.trim().isNotEmpty) ...[
            pw.SizedBox(height: 24),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: accentLight,
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(color: primary.shade(0.2)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    title: l10n.translate('diet_result_clinical_summary'),
                    secondary: secondary,
                    textAlign: textAlign,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Paragraph(
                    text: plan.localizedSummary,
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.black,
                      lineSpacing: 2,
                    ),
                    textAlign: textAlign,
                    margin: pw.EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
          pw.SizedBox(height: 24),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                title: l10n.translate('diet_result_input_values_used'),
                secondary: secondary,
                textAlign: textAlign,
              ),
              pw.SizedBox(height: 12),
              pw.Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _kvPill(
                    label: l10n.translate('diet_form_name'),
                    value: request.name,
                    lightBg: lightBg,
                    border: border,
                  ),
                  _kvPill(
                    label: l10n.translate('diet_form_age'),
                    value: request.age.toString(),
                    lightBg: lightBg,
                    border: border,
                  ),
                  _kvPill(
                    label: l10n.translate('diet_form_gender'),
                    value: request.gender,
                    lightBg: lightBg,
                    border: border,
                  ),
                  _kvPill(
                    label: l10n.translate('diet_form_height_cm'),
                    value: request.height.toString(),
                    lightBg: lightBg,
                    border: border,
                  ),
                  _kvPill(
                    label: l10n.translate('diet_form_weight_kg'),
                    value: request.weight.toString(),
                    lightBg: lightBg,
                    border: border,
                  ),
                  _kvPill(
                    label: l10n.translate('diet_form_goal'),
                    value: request.goal,
                    lightBg: lightBg,
                    border: border,
                  ),
                  if ((request.favoriteFoods ?? '').trim().isNotEmpty)
                    _kvPill(
                      label: l10n.translate('favorite_foods'),
                      value: request.favoriteFoods!,
                      lightBg: lightBg,
                      border: border,
                    ),
                  if ((request.dislikedFoods ?? '').trim().isNotEmpty)
                    _kvPill(
                      label: l10n.translate('disliked_foods'),
                      value: request.dislikedFoods!,
                      lightBg: lightBg,
                      border: border,
                    ),
                  if (request.isSpecialist) ...[
                    _kvPill(
                      label: l10n.translate('diet_form_diet_type'),
                      value: request.dietType ?? '',
                      lightBg: lightBg,
                      border: border,
                    ),
                    _kvPill(
                      label: l10n.translate('diet_form_macro_distribution'),
                      value: request.macroDistribution ?? '',
                      lightBg: lightBg,
                      border: border,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // ==========================================
    // PART 2: WEEKLY PLAN (Scale to Fit)
    // ==========================================
    final entries = _orderedWeekEntries(plan.weekPlan);

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final String dayLabel = _translateDay(l10n, entry.key);
      final DayPlan dayPlan = entry.value;

      pdfDoc.addPage(
        pw.Page(
          pageTheme: pageTheme,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  context,
                  l10n,
                  primary,
                  muted,
                  border,
                  exportDate,
                  logoImage,
                ),

                pw.Expanded(
                  child: pw.FittedBox(
                    fit: pw.BoxFit.scaleDown,
                    alignment: isRtl
                        ? pw.Alignment.topRight
                        : pw.Alignment.topLeft,
                    child: pw.Container(
                      width: safeContentWidth,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (i == 0) ...[
                            _sectionTitle(
                              title: l10n.translate('diet_result_weekly_plan'),
                              secondary: secondary,
                              textAlign: textAlign,
                            ),
                            pw.SizedBox(height: 16),
                          ],
                          ..._buildDayContent(
                            dayLabel: dayLabel,
                            dayPlan: dayPlan,
                            l10n: l10n,
                            border: border,
                            primary: primary,
                            secondary: secondary,
                            muted: muted,
                            surfaceCard: surfaceCard,
                            accentLight: accentLight,
                            textAlign: textAlign,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                _buildFooter(context, l10n, muted, border),
              ],
            );
          },
        ),
      );
    }

    return pdfDoc.save();
  }

  // --- UI Components ---

  pw.Widget _buildHeader(
    pw.Context context,
    AppLocalizations l10n,
    PdfColor primary,
    PdfColor muted,
    PdfColor border,
    String exportDate,
    pw.MemoryImage logoImage,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: border, width: 1.5)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 24),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          // Using the image instead of text
          pw.Image(
            logoImage,
            height: 24,
          ), // Adjust the height to fit your design
          pw.Text(exportDate, style: pw.TextStyle(fontSize: 10, color: muted)),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(
    pw.Context context,
    AppLocalizations l10n,
    PdfColor muted,
    PdfColor border,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 12),
      margin: const pw.EdgeInsets.only(top: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: border, width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            l10n.translate('diet_result_title'),
            style: pw.TextStyle(fontSize: 10, color: muted),
          ),
          pw.Text(
            '${l10n.translate("pdf_page")} ${context.pageNumber} / ${context.pagesCount}',
            style: pw.TextStyle(
              fontSize: 10,
              color: muted,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _titleCard({
    required AppLocalizations l10n,
    required DietPlanResponse plan,
    required DietRequestData request,
    required PdfColor primary,
    required PdfColor secondary,
    required PdfColor muted,
    required PdfColor accentLight,
    required pw.TextAlign textAlign,
  }) {
    final String dietName = plan.dietTypeApplied.trim().isEmpty
        ? l10n.translate('diet_mode_fallback_plan_name')
        : plan.dietTypeApplied.trim();
    final String caloriesValue = plan.dailyCaloriesTarget <= 0
        ? '--'
        : '${plan.dailyCaloriesTarget} ${l10n.translate("diet_result_calories_short")}';
    final String waterValue =
        (plan.dailyWaterLiters == null ||
            plan.dailyWaterLiters!.isNaN ||
            plan.dailyWaterLiters! <= 0)
        ? '--'
        : '${plan.dailyWaterLiters!.toStringAsFixed(1)} L';

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: accentLight,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 4,
            height: 60,
            decoration: pw.BoxDecoration(
              color: primary,
              borderRadius: pw.BorderRadius.circular(4),
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  l10n.translate('diet_result_title'),
                  textAlign: textAlign,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: secondary,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  dietName,
                  textAlign: textAlign,
                  style: pw.TextStyle(fontSize: 14, color: primary),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  children: [
                    _highlightBlock(
                      label: l10n.translate('diet_result_daily_calories'),
                      value: caloriesValue,
                      color: secondary,
                    ),
                    pw.SizedBox(width: 32),
                    _highlightBlock(
                      label: l10n.translate('diet_result_daily_water'),
                      value: waterValue,
                      color: secondary,
                    ),
                    pw.SizedBox(width: 32),
                    _highlightBlock(
                      label: l10n.translate('diet_form_name'),
                      value: request.name.trim().isEmpty
                          ? l10n.translate('tabiby')
                          : request.name.trim(),
                      color: secondary,
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

  pw.Widget _highlightBlock({
    required String label,
    required String value,
    required PdfColor color,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  pw.Widget _macroTile({
    required String title,
    required String value,
    required PdfColor primary,
    required PdfColor border,
    required PdfColor lightBg,
  }) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: pw.BoxDecoration(
          color: lightBg,
          border: pw.Border.all(color: border),
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              value.trim().isEmpty ? '--' : value,
              style: pw.TextStyle(
                fontSize: 16,
                color: primary,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _sectionTitle({
    required String title,
    required PdfColor secondary,
    required pw.TextAlign textAlign,
  }) {
    return pw.Text(
      title,
      textAlign: textAlign,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: secondary,
      ),
    );
  }

  pw.Widget _kvPill({
    required String label,
    required String value,
    required PdfColor lightBg,
    required PdfColor border,
  }) {
    final String cleaned = value.trim();
    if (cleaned.isEmpty) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: lightBg,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: border),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.Text(
            cleaned,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _buildDayContent({
    required String dayLabel,
    required DayPlan dayPlan,
    required AppLocalizations l10n,
    required PdfColor border,
    required PdfColor primary,
    required PdfColor secondary,
    required PdfColor muted,
    required PdfColor surfaceCard,
    required PdfColor accentLight,
    required pw.TextAlign textAlign,
  }) {
    final widgets = <pw.Widget>[];

    // Day Banner
    widgets.add(
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: pw.BoxDecoration(
          color: secondary,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Text(
          dayLabel,
          textAlign: textAlign,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
    widgets.add(pw.SizedBox(height: 16));

    final mealEntries = <MapEntry<String, MealDetails?>>[
      MapEntry('diet_result_meal_breakfast', dayPlan.breakfast),
      MapEntry('diet_result_meal_lunch', dayPlan.lunch),
      MapEntry('diet_result_meal_dinner', dayPlan.dinner),
      MapEntry('diet_result_meal_snack', dayPlan.snack),
    ].where((e) => e.value != null).toList();

    for (final meal in mealEntries) {
      widgets.add(
        _mealCard(
          title: l10n.translate(meal.key),
          details: meal.value!,
          l10n: l10n,
          border: border,
          primary: primary,
          secondary: secondary,
          muted: muted,
          surfaceCard: surfaceCard,
          textAlign: textAlign,
        ),
      );
      widgets.add(pw.SizedBox(height: 16));
    }

    if (dayPlan.dailyAdvice.trim().isNotEmpty) {
      widgets.add(
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: accentLight,
            borderRadius: pw.BorderRadius.circular(12),
            border: pw.Border.all(color: primary.shade(0.2)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 4,
                    height: 16,
                    decoration: pw.BoxDecoration(
                      color: primary,
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(
                    l10n.translate('diet_result_daily_advice'),
                    textAlign: textAlign,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: secondary,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Paragraph(
                text: dayPlan.dailyAdvice,
                style: pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
                margin: pw.EdgeInsets.zero,
                textAlign: textAlign,
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  pw.Widget _mealCard({
    required String title,
    required MealDetails details,
    required AppLocalizations l10n,
    required PdfColor border,
    required PdfColor primary,
    required PdfColor secondary,
    required PdfColor muted,
    required PdfColor surfaceCard,
    required pw.TextAlign textAlign,
  }) {
    final ingredients = details.ingredients.where((e) => e.trim().isNotEmpty);
    final String mealText = _truncate(details.meal.trim(), maxChars: 700);
    final String tipText = _truncate(
      details.preparationTip.trim(),
      maxChars: 500,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: surfaceCard,
        borderRadius: pw.BorderRadius.circular(10), // Softer corners
        border: pw.Border.all(color: border, width: 0.8), // Clean, thin border
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // --- HEADER: Elegant Accent Line instead of Solid Badge ---
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: 4,
                height: 16,
                decoration: pw.BoxDecoration(
                  color: primary,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                title,
                textAlign: textAlign,
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: secondary,
                ),
              ),
              pw.Spacer(),
              // Highlight Calories on the far side
              pw.Text(
                '${details.calories} kcal',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Clean Macro Line
          pw.Row(
            children: [
              _macroMiniItem(
                label: 'P',
                value: '${details.proteinG}g',
                muted: muted,
              ),
              pw.SizedBox(width: 16),
              _macroMiniItem(
                label: 'C',
                value: '${details.carbsG}g',
                muted: muted,
              ),
              pw.SizedBox(width: 16),
              _macroMiniItem(
                label: 'F',
                value: '${details.fatsG}g',
                muted: muted,
              ),
            ],
          ),

          pw.SizedBox(height: 12),
          pw.Divider(color: border, thickness: 0.5), // Subtle separator
          pw.SizedBox(height: 12),

          // --- CONTENT ---
          if (details.meal.trim().isNotEmpty)
            pw.Paragraph(
              text: mealText,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
                lineSpacing: 1.5,
              ),
              margin: pw.EdgeInsets.zero,
              textAlign: textAlign,
            ),

          if (ingredients.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text(
              l10n.translate('diet_result_ingredients'),
              textAlign: textAlign,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: secondary,
              ),
            ),
            pw.SizedBox(height: 6),
            ...ingredients
                .take(10)
                .map(
                  (e) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: pw.Text(
                      '• ${_truncate(e.trim(), maxChars: 90)}',
                      textAlign: textAlign,
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                ),
          ],

          if (details.preparationTip.trim().isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(
                  0xFFF8FAFC,
                ), // Very soft, elegant cool-gray
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: border, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    l10n.translate('diet_result_tip'),
                    textAlign: textAlign,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: muted,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Paragraph(
                    text: tipText,
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                      lineSpacing: 1.2,
                    ),
                    margin: pw.EdgeInsets.zero,
                    textAlign: textAlign,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- NEW HELPER METHOD (Paste this right below _mealCard) ---
  pw.Widget _macroMiniItem({
    required String label,
    required String value,
    required PdfColor muted,
  }) {
    return pw.Row(
      children: [
        pw.Text('$label: ', style: pw.TextStyle(fontSize: 11, color: muted)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  String _truncate(String text, {required int maxChars}) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars).trimRight()}...';
  }

  List<MapEntry<String, DayPlan>> _orderedWeekEntries(
    Map<String, DayPlan> map,
  ) {
    final entries = map.entries.toList();
    const order = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    int indexOf(String day) {
      final i = order.indexWhere((d) => d.toLowerCase() == day.toLowerCase());
      return i == -1 ? 999 : i;
    }

    entries.sort((a, b) => indexOf(a.key).compareTo(indexOf(b.key)));
    return entries;
  }

  String _translateDay(AppLocalizations l10n, String dayKey) {
    final normalized = dayKey.trim().toLowerCase();
    switch (normalized) {
      case 'saturday':
      case 'sunday':
      case 'monday':
      case 'tuesday':
      case 'wednesday':
      case 'thursday':
      case 'friday':
        return l10n.translate(normalized);
      default:
        return dayKey;
    }
  }

  String _resolveLanguageCode() {
    final cached = CacheHelper.getData(key: "LOCALE");
    final code = cached?.toString().trim();
    if (code == 'ar' || code == 'en') {
      return code!;
    }
    return 'en';
  }

  Future<AppLocalizations> _loadLocalizations(String code) async {
    final l10n = AppLocalizations(locale: Locale(code));
    await l10n.loadJsonLanguage();
    return l10n;
  }

  Future<pw.Font> _loadFont({required bool isRtl}) async {
    final ByteData data = await rootBundle.load(
      isRtl
          ? 'assets/fonts/cocon-next-arabic.ttf'
          : 'assets/fonts/Hacen Beirut.ttf',
    );
    return pw.Font.ttf(data);
  }
}
