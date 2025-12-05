import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/home_model.dart';
import '../../data/repo/home_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(HomeInitial());
  final HomeRepo _homeRepo;

  Future getHome() async {
    emit(HomeLoading());
    var data = await _homeRepo.getHome();
    data.fold((failure) => emit(HomeError(errorMsg: failure.message)), (home) {
      emit(HomeSuccess(home: home));
    });
  }
}
