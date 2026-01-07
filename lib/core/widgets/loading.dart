import '../../imports.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 75.sp,
          height: 75.sp,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: const Loading(),
        ),
      ],
    );
  }
}

class Loading extends StatelessWidget {
  final double size;
  const Loading({super.key, this.size = 27});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.sp,
      height: size.sp,
      child: const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(primaryColor)),
    );
  }
}
