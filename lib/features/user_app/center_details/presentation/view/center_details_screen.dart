import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/center_details/data/models/centers_model.dart';
import 'package:tabiby/features/user_app/center_details/presentation/view_model/center_cubit.dart';
import 'package:tabiby/features/user_app/centers/data/repos/centers_repo.dart';
import '../../../../../core/utils/services_locater.dart';
import 'sections/appbar_section.dart';
import 'sections/about_section.dart';
import 'sections/clinics_section.dart';
import 'widgets/clinic_header.dart';

class CenterDetailsScreen extends StatelessWidget {
  static const String routeName = "/center_details";
  final int centerID;
  const CenterDetailsScreen({super.key, required this.centerID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBarSection(),
      body: BlocProvider(
        create: (context) =>
            CenterCubit(getit.get<CentersRepo>())..getCenter(centerID),
        child: BlocBuilder<CenterCubit, CenterState>(
          builder: (context, state) {
            if (state is CenterSuccess) {
              Centers center = state.center;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ClinicHeader(
                          name: center.name ?? "",
                          address: center.address ?? "",
                          imageUrl: center.img,
                          clinicCount: center.clinics?.length ?? 0,
                        ),
                        const SizedBox(height: 20),
                        AboutSection(
                          description:
                              center.bio ??
                              'default_center_description'.tr(context),
                        ),
                        const SizedBox(height: 20),
                        ClinicsSection(
                          centerID: center.id ?? 0,
                          clinics: center.clinics ?? const [],
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            } else if (state is CenterError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<CenterCubit>().getCenter(centerID);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColors,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
