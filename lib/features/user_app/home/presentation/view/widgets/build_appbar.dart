import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/shared/settings/view/settings_screen.dart';
import 'package:tabiby/features/user_app/notification_history/presentation/view-model/notification_history_cubit.dart';
import 'package:tabiby/features/user_app/notification_history/presentation/view/notification_history_screen.dart';
import 'package:tabiby/features/user_app/user/presentation/view-model/user_cubit/user_cubit.dart';
import 'package:tabiby/features/user_app/user/presentation/view/user_profile.dart';

import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';

class BuildAppbar extends StatefulWidget implements PreferredSizeWidget {
  const BuildAppbar({
    super.key,
    this.isDoctor = false,
    this.toolbarHeight = kToolbarHeight + 30.0,
  });

  final double toolbarHeight;
  final bool isDoctor;

  @override
  State<BuildAppbar> createState() => _BuildAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

class _BuildAppbarState extends State<BuildAppbar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.isDoctor) {
        return;
      }

      context.read<NotificationHistoryCubit>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top * 0.75;

    final double totalContainerHeight = widget.toolbarHeight + topPadding;

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
                AppColors.primaryColors.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColors.withValues(alpha: 0.3),
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
            Colors.white.withValues(alpha: 0.8),
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
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: widget.isDoctor
                  ? null
                  : () {
                      Navigator.pushNamed(context, UserProfileScreen.routeName);
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: user?.image,
                          placeholderAsset: widget.isDoctor
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
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.isDoctor ? "dr".tr(context) : ""} ${user?.firstName} ${user?.lastName ?? ""}',
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
                  ],
                ),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                BlocBuilder<NotificationHistoryCubit, NotificationHistoryState>(
                  builder: (context, notificationState) {
                    final int unreadCount = notificationState.unreadCount;
                    final String unreadCountLabel = unreadCount > 99
                        ? '99+'
                        : unreadCount.toString();

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: widget.isDoctor
                              ? () => Navigator.pushNamed(
                                  context,
                                  SettingsScreen.routeName,
                                )
                              : () => Navigator.pushNamed(
                                  context,
                                  NotificationHistoryScreen.routeName,
                                ),
                          icon: Icon(
                            widget.isDoctor
                                ? Icons.settings
                                : Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        ),
                        if (!widget.isDoctor && unreadCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              constraints: const BoxConstraints(minWidth: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2574C),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.4,
                                ),
                              ),
                              child: Text(
                                unreadCountLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
