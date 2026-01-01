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
    this.toolbarHeight = kToolbarHeight + 30.0,
  });

  final double toolbarHeight;
  final bool isDoctor;

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top * 0.75;

    final double totalContainerHeight = toolbarHeight + topPadding;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Container(
          height: totalContainerHeight,

          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
            top: topPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColors,
                AppColors.primaryColors.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColors.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, UserState state) {
    if (state is UserLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.8),
          ),
        ),
      );
    }

    if (state is UserError) {
      return Center(
        child: Text(
          state.errorMsg.tr(context),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (state is UserSuccess) {
      final user = state.user.mainData;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: user?.image,
                placeholderAsset: isDoctor
                    ? AssetsData.defaultDoctorProfile
                    : AssetsData.defaultProfileImage,
                height: 55,
                width: 55,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'welcome_back'.tr(context),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isDoctor ? "dr".tr(context) : ""} ${user?.firstName} ${user?.lastName ?? ""}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: isDoctor
                  ? () => Navigator.pushNamed(context, SettingsScreen.routeName)
                  : () {},
              icon: Icon(
                isDoctor ? Icons.settings : Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
