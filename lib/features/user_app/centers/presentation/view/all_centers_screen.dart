import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/center_details/data/models/centers_model.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../center_details/presentation/view/center_details_screen.dart';
import '../../data/repos/centers_repo.dart';
import '../view_model/centers_cubit.dart';
import 'widgets/center_card.dart';

class AllCentersScreen extends StatelessWidget {
  static const String routeName = "/centers";

  const AllCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "all_popular_centers".tr(context)),
      body: BlocProvider(
        create: (BuildContext context) {
          return CentersCubit(getit.get<CentersRepo>())..getCenters();
        },
        child: BlocBuilder<CentersCubit, CentersState>(
          builder: (context, state) {
            if (state is CentersSuccess) {
              Future<void> onRefresh() async {
                await context.read<CentersCubit>().getCenters();
              }

              return RefreshIndicator(
                onRefresh: onRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: state.centers.centers?.length ?? 0,
                    itemBuilder: (context, index) {
                      final center = state.centers.centers?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CenterDetailsScreen(centerID: center!.id!),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CenterCard(
                            center: state.centers.centers?[index] ?? Centers(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (state is CentersError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<CentersCubit>().getCenters();
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
