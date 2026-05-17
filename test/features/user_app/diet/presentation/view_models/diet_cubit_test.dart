import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_plan_history_item.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_plan_response.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_request_data.dart';
import 'package:tabiby/features/user_app/diet/data/models/paginated_diet_plans_result.dart';
import 'package:tabiby/features/user_app/diet/data/repos/diet_repository.dart';
import 'package:tabiby/features/user_app/diet/presentation/view_models/diet_cubit.dart';

void main() {
  group('DietCubit', () {
    late _FakeDietRepository repo;
    late DietCubit cubit;

    setUp(() {
      repo = _FakeDietRepository();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loads diet history on creation', () async {
      final item = _historyItem(id: 'plan-1');
      repo.dietPlansResult = right(
        PaginatedDietPlansResult(
          items: <DietPlanHistoryItem>[item],
          meta: const DietPlansMeta(page: 1, limit: 10, total: 1),
        ),
      );

      cubit = DietCubit(repo);
      await _settle();

      expect(cubit.state.historyStatus, DietAsyncStatus.success);
      expect(cubit.state.history, <DietPlanHistoryItem>[item]);
      expect(cubit.state.historyMeta.total, 1);
    });

    test(
      'generateDietPlan emits loading then success and upserts history',
      () async {
        final request = _request();
        final item = _historyItem(id: 'generated-plan', request: request);
        repo.generatedPlanResult = right(item);
        cubit = DietCubit(repo);
        await _settle();

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(<Matcher>[
            isA<DietState>()
                .having(
                  (state) => state.submitStatus,
                  'submitStatus',
                  DietAsyncStatus.loading,
                )
                .having(
                  (state) => state.infoMessage,
                  'infoMessage',
                  'diet_generation_takes_time',
                ),
            isA<DietState>()
                .having(
                  (state) => state.submitStatus,
                  'submitStatus',
                  DietAsyncStatus.success,
                )
                .having(
                  (state) => state.planStatus,
                  'planStatus',
                  DietAsyncStatus.success,
                )
                .having(
                  (state) => state.currentPlanId,
                  'currentPlanId',
                  'generated-plan',
                )
                .having((state) => state.history.first, 'history.first', item),
          ]),
        );

        await cubit.generateDietPlan(request);
        await expectation;

        expect(repo.lastGenerateRequest, request);
      },
    );

    test(
      'exportCurrentPlanAsPdf emits missing-plan error before plan exists',
      () async {
        cubit = DietCubit(repo);
        await _settle();

        await cubit.exportCurrentPlanAsPdf();

        expect(cubit.state.exportStatus, DietAsyncStatus.error);
        expect(cubit.state.exportErrorMessage, 'diet_export_pdf_missing_plan');
      },
    );

    test(
      'exportCurrentPlanAsPdf emits success with generated file name',
      () async {
        final request = _request();
        final item = _historyItem(id: 'pdf-plan', request: request);
        repo.generatedPlanResult = right(item);
        repo.exportResult = right(Uint8List.fromList(<int>[1, 2, 3]));
        cubit = DietCubit(repo);
        await _settle();
        await cubit.generateDietPlan(request);

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder(<Matcher>[
            isA<DietState>().having(
              (state) => state.exportStatus,
              'exportStatus',
              DietAsyncStatus.loading,
            ),
            isA<DietState>()
                .having(
                  (state) => state.exportStatus,
                  'exportStatus',
                  DietAsyncStatus.success,
                )
                .having(
                  (state) => state.exportFileName,
                  'exportFileName',
                  'diet_plan_pdf-plan.pdf',
                )
                .having(
                  (state) => state.exportPdfBytes,
                  'exportPdfBytes',
                  Uint8List.fromList(<int>[1, 2, 3]),
                ),
          ]),
        );

        await cubit.exportCurrentPlanAsPdf();
        await expectation;
      },
    );
  });
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

DietRequestData _request() {
  return const DietRequestData(
    name: 'Patient',
    age: 32,
    gender: 'male',
    height: 178,
    weight: 82,
    jobNature: 'office',
    goal: 'lose_weight',
    chronicDiseases: 'none',
    medications: 'none',
    allergies: 'none',
    digestionIssues: 'none',
    mealsPerDay: 3,
    sweetsFrequency: 'low',
    sodaFrequency: 'low',
    eatingOutFrequency: 'weekly',
    exercise: 'moderate',
    sleepHours: 7,
    insomnia: 'no',
    emotionalEating: 'sometimes',
    eatingSpeed: 'normal',
    isSpecialist: false,
  );
}

DietPlanResponse _plan() {
  return const DietPlanResponse(
    summary: 'Balanced plan',
    dietTypeApplied: 'balanced',
    dailyCaloriesTarget: 1900,
    dailyWaterLiters: 2.5,
    dailyMacrosSummary: Macros(protein: '120g', carbs: '180g', fats: '55g'),
    weekPlan: <String, DayPlan>{},
  );
}

DietPlanHistoryItem _historyItem({
  required String id,
  DietRequestData? request,
}) {
  return DietPlanHistoryItem(
    id: id,
    createdAt: DateTime(2026, 5, 17),
    request: request ?? _request(),
    plan: _plan(),
  );
}

class _FakeDietRepository implements DietRepository {
  Either<Failure, DietPlanHistoryItem> generatedPlanResult = right(
    _historyItem(id: 'generated'),
  );
  Either<Failure, PaginatedDietPlansResult> dietPlansResult = right(
    const PaginatedDietPlansResult(
      items: <DietPlanHistoryItem>[],
      meta: DietPlansMeta(page: 1, limit: 10, total: 0),
    ),
  );
  Either<Failure, DietPlanHistoryItem> planByIdResult = right(
    _historyItem(id: 'saved'),
  );
  Either<Failure, DietPlanHistoryItem> latestPlanResult = right(
    _historyItem(id: 'latest'),
  );
  Either<Failure, Uint8List> exportResult = right(Uint8List(0));
  DietRequestData? lastGenerateRequest;

  @override
  Future<Either<Failure, Uint8List>> exportDietPlanAsPdf({
    required DietPlanResponse plan,
    required DietRequestData request,
    DateTime? createdAt,
  }) async {
    return exportResult;
  }

  @override
  Future<Either<Failure, DietPlanHistoryItem>> generateDietPlan(
    DietRequestData request,
  ) async {
    lastGenerateRequest = request;
    return generatedPlanResult;
  }

  @override
  Future<Either<Failure, DietPlanHistoryItem>> getDietPlanById(
    String id,
  ) async {
    return planByIdResult;
  }

  @override
  Future<Either<Failure, PaginatedDietPlansResult>> getDietPlans({
    int page = 1,
    int limit = 10,
  }) async {
    return dietPlansResult;
  }

  @override
  Future<Either<Failure, DietPlanHistoryItem>> getLatestDietPlan() async {
    return latestPlanResult;
  }
}
