import '../../imports.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Loading()],
    );
  }
}

class Loading extends StatelessWidget {
  final Color? color;
  final double? size;
  const Loading({this.color, this.size, super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: (size ?? 27).sp,
        width: (size ?? 27).sp,
        child: CircularProgressIndicator(color: color ?? primaryColor),
      ),
    );
  }
}
