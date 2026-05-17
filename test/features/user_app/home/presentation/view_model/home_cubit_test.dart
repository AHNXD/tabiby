import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabiby/core/errors/failuer.dart';
import 'package:tabiby/features/user_app/home/data/models/home_model.dart';
import 'package:tabiby/features/user_app/home/data/repo/home_repo.dart';
import 'package:tabiby/features/user_app/home/presentation/view-model/home_cubit.dart';

void main() {
  group('HomeCubit', () {
    late _FakeHomeRepo repo;
    late HomeCubit cubit;

    setUp(() {
      repo = _FakeHomeRepo();
      cubit = HomeCubit(repo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('getHome emits loading then success', () async {
      final home = HomeModel();
      repo.result = right(home);

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<HomeLoading>(),
          isA<HomeSuccess>().having((state) => state.home, 'home', home),
        ]),
      );

      await cubit.getHome();
      await expectation;
    });

    test('getHome emits loading then error', () async {
      repo.result = left(const ServerFailure('home_error'));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder(<Matcher>[
          isA<HomeLoading>(),
          isA<HomeError>().having(
            (state) => state.errorMsg,
            'errorMsg',
            'home_error',
          ),
        ]),
      );

      await cubit.getHome();
      await expectation;
    });
  });
}

class _FakeHomeRepo implements HomeRepo {
  Either<Failure, HomeModel> result = right(HomeModel());

  @override
  Future<Either<Failure, HomeModel>> getHome() async {
    return result;
  }
}
