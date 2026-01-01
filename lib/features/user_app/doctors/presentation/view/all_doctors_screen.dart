import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../data/repos/doctors_repo.dart';
import '../view_model/doctor_cubit.dart';
import 'widgets/doctor_card.dart';

class AllDoctorsScreen extends StatefulWidget {
  static const String routeName = "/doctors";

  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final ScrollController _controller = ScrollController();
  int? centerID;
  int? specialtyID;
  late DoctorsCubit _doctorsCubit;

  @override
  void initState() {
    super.initState();
    _doctorsCubit = DoctorsCubit(getit.get<DoctorsRepo>());

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_doctorsCubit.isRefreshing) {
        _doctorsCubit.getDoctors(centerID, specialtyID, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> args =
        (arguments != null && arguments is Map<String, dynamic>)
        ? arguments
        : {};

    centerID = args['centerID'];
    specialtyID = args['specialtyID'];
    return Scaffold(
      appBar: CustomAppbar(title: "all_popular_doctors".tr(context)),
      body: BlocProvider(
        create: (BuildContext context) {
          return _doctorsCubit..getDoctors(centerID, specialtyID);
        },
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsSuccess) {
              Future<void> onRefresh() async {
                await context.read<DoctorsCubit>().refreshDoctors(
                  centerID,
                  specialtyID,
                );
              }

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      child: GridView.builder(
                        controller: _controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.doctors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DoctorCard(doctor: state.doctors[index]),
                          );
                        },
                      ),
                    ),
                  ),

                  if (state.isLoadingMore)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: BottomLoader(),
                    ),
                ],
              );
            } else if (state is DoctorsError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<DoctorsCubit>().getDoctors(
                    centerID,
                    specialtyID,
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
