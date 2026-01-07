import '../../imports.dart';

Future<T> showPrimaryContextMenu<T>({
  required LongPressStartDetails details,
  required BuildContext context,
  required List<PrimaryContextMenu> items,
}) async {
  final position = details.globalPosition;
  return await showMenu(
    context: context,
    color: context.theme.bottomSheetTheme.backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.circular12),
    position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
    menuPadding: AppPadding.vertical(4),
    items: [for (var item in items) _menuItem(item, context)],
  );
}

PopupMenuItem _menuItem(PrimaryContextMenu item, BuildContext context) {
  return PopupMenuItem(
    height: 40.sp,
    onTap: item.onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.icon != null) ...[
          Icon(item.icon, color: item.color ?? context.font14.color!, size: 16.sp),
          SizedBox(width: 8.sp),
        ],
        Text(
          item.text,
          style: context.font14.copyWith(fontWeight: FontWeight.w500, color: item.color),
        ),
      ],
    ),
  );
}

class PrimaryContextMenu {
  final String text;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;

  PrimaryContextMenu({required this.text, required this.onTap, this.icon, this.color});
}
