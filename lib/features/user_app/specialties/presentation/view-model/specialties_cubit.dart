import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/specialties_model.dart';
import '../../data/repos/user_repo.dart';

part 'specialties_state.dart';

class SpecialtiesCubit extends Cubit<SpecialtiesState> {
  SpecialtiesCubit(this._specialtiesRepo) : super(SpecialtiesInitial());

  final SpecialtiesRepo _specialtiesRepo;

  Future getSpecialties() async {
    emit(SpecialtiesLoading());
    var data = await _specialtiesRepo.getSpecialties();
    data.fold((failure) => emit(SpecialtiesError(errorMsg: failure.message)), (
      specialties,
    ) {
      emit(SpecialtiesSuccess(specialties: specialties));
    });
  }
}
