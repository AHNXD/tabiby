import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/shared/settings/view/settings_screen.dart';
import 'package:tabiby/features/user_app/user/presentation/view-model/user_cubit/user_cubit.dart';

import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';

class BuildAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppbar({
    super.key,
    this.isDoctor = false,
    this.toolbarHeight = kToolbarHeight + 16.0,
  });
  final double toolbarHeight;
  final bool isDoctor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: toolbarHeight.toDouble(),
              decoration: BoxDecoration(
                color: AppColors.primaryColors,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: state is UserSuccess
                  ? ListTile(
                      leading: ClipOval(
            child: CustomImageWidget(
              imageUrl: state.user.mainData?.image,
              placeholderAsset:isDoctor ?AssetsData.defaultDoctorProfile:  AssetsData.defaultProfileImage,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
                      title: Text(
                        'welcome_back'.tr(context),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      subtitle: Text(
                        '${isDoctor ? "dr".tr(context) : ""} ${state.user.mainData!.firstName} ${state.user.mainData!.lastName??""}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      trailing:isDoctor
                          ? IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                SettingsScreen.routeName,
                              ),
                              icon: Icon(Icons.settings),
                              color: Colors.white,
                            )
                          : Icon(Icons.notifications, color: Colors.white),
                    )
                  : state is UserError
                  ? Text(
                      state.errorMsg.tr(context),
                      style: TextStyle(color: Colors.white),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: LinearProgressIndicator(),
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight.toDouble());
}
