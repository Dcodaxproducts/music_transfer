import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../utils/style.dart';

class MenuItem extends StatelessWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  final Function()? onTap;
  final bool notification;
  const MenuItem(
      {required this.text,
      this.subtile,
      required this.icon,
      required this.onTap,
      this.notification = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      leading: Icon(
        icon,
        size: 18.sp,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      title: Text(
        text.tr,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: subtile != null
          ? Padding(
              padding: EdgeInsets.only(top: 5.sp),
              child: Text(
                subtile!.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
            )
          : null,
      trailing: notification
          ? GetBuilder<SettingsController>(builder: (setting) {
              bool notification = setting.configModel.notificationsEnabled;
              return Switch(
                value: notification,
                onChanged: (value) {
                  setting.configModel =
                      setting.configModel.copyWith(notificationsEnabled: value);
                },
                activeColor: Theme.of(context).primaryColor,
              );
            })
          : Icon(
              Iconsax.arrow_right_3,
              size: 16.sp,
              color: Theme.of(context).hintColor,
            ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  const NotificationTile(
      {required this.text, this.subtile, required this.icon, super.key});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile>
    with WidgetsBindingObserver {
  //
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  //
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // rebuild the widget
      setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseMessaging.instance.getNotificationSettings(),
        builder: (context, snapshot) {
          bool authorized = false;
          if (snapshot.data != null) {
            authorized = snapshot.data?.authorizationStatus ==
                AuthorizationStatus.authorized;
          }
          return ListTile(
            onTap: () => _onTap(authorized),
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            leading: Icon(
              widget.icon,
              size: 18.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            title: Text(
              widget.text.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: widget.subtile != null
                ? Padding(
                    padding: EdgeInsets.only(top: 5.sp),
                    child: Text(
                      widget.subtile!.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  )
                : null,
            trailing: Switch(
              value: authorized,
              onChanged: (value) => _onTap(authorized),
              activeColor: Theme.of(context).primaryColor,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
          );
        });
  }

  _onTap(bool authorized) {
    AppSettings.openAppSettings(
        type: AppSettingsType.notification, asAnotherTask: true);
  }
}
