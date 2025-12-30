import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../center_details/presentation/view/center_details_screen.dart';
import '../../data/repos/centers_repo.dart';
import '../view_model/centers_cubit.dart';
import 'widgets/center_card.dart';

class AllCentersScreen extends StatefulWidget {
  static const String routeName = "/centers";

  const AllCentersScreen({super.key});

  @override
  State<AllCentersScreen> createState() => _AllCentersScreenState();
}

class _AllCentersScreenState extends State<AllCentersScreen> {
  final ScrollController _controller = ScrollController();
  late CentersCubit _centersCubit;

  @override
  void initState() {
    super.initState();
    _centersCubit = CentersCubit(getit.get<CentersRepo>());

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_centersCubit.isRefreshing) {
        _centersCubit.getCenters(loadMore: true);
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
                await context.read<CentersCubit>().refreshCenters();
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
                        itemCount: state.centers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),

                        itemBuilder: (context, index) {
                          final center = state.centers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CenterDetailsScreen(centerID: center.id!),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CenterCard(center: state.centers[index]),
                            ),
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
