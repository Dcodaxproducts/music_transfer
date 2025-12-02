import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../../imports.dart';

class MenuItem extends StatelessWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  final Function()? onTap;
  const MenuItem({required this.text, this.subtile, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: AppRadius.circular16Shape,
      leading: Icon(icon, size: 18.sp, color: context.font14.color),
      title: Text(text.tr, style: context.font14),
      subtitle: subtile != null
          ? Padding(
              padding: EdgeInsets.only(top: 5.sp),
              child: Text(subtile!.tr, style: context.font12.copyWith(color: Theme.of(context).hintColor)),
            )
          : null,
      trailing: Icon(Iconsax.arrow_right_3, size: 16.sp, color: Theme.of(context).hintColor),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  const NotificationTile({required this.text, this.subtile, required this.icon, super.key});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> with WidgetsBindingObserver {
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
          authorized = snapshot.data?.authorizationStatus == AuthorizationStatus.authorized;
        }
        return ListTile(
          onTap: () => _onTap(authorized),
          shape: AppRadius.circular16Shape,
          leading: Icon(widget.icon, size: 18.sp, color: context.font14.color),
          title: Text(widget.text.tr, style: context.font14),
          subtitle: widget.subtile != null
              ? Padding(
                  padding: EdgeInsets.only(top: 5.sp),
                  child: Text(
                    widget.subtile!.tr,
                    style: context.font12.copyWith(color: Theme.of(context).hintColor),
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
      },
    );
  }

  void _onTap(bool authorized) {
    AppSettings.openAppSettings(type: AppSettingsType.notification, asAnotherTask: true);
  }
}
