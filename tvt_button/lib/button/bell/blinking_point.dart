part of tvt_button;
class BlinkingPoint extends StatefulWidget {
  final double? xCoor;
  final double? yCoor;
  final Color? pointColor;
  final double? pointSize;

  BlinkingPoint({
    this.xCoor,
    this.yCoor,
    this.pointColor,
    this.pointSize,
  });

  @override
  BlinkingPointState createState() => new BlinkingPointState();
}

class BlinkingPointState extends State<BlinkingPoint>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: widget.pointSize! * 4)
        .animate(animationController);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LogoAnimation(
      xCoor: widget.xCoor!,
      yCoor: widget.yCoor!,
      pointColor: widget.pointColor!,
      pointSize: widget.pointSize!,
      animation: animation,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class LogoAnimation extends AnimatedWidget {
  final double xCoor;
  final double yCoor;
  final Color pointColor;
  final double pointSize;
  LogoAnimation({
    Key? key,
    Animation? animation,
    required this.xCoor,
    required this.yCoor,
    required this.pointColor,
    required this.pointSize,
  }) : super(key: key, listenable: animation!);

  @override
  Widget build(BuildContext context) {
    late Animation animation = this.listenable as Animation;
    return new CustomPaint(
      foregroundPainter: Circle(
        xCoor: xCoor,
        yCoor: yCoor,
        color: pointColor,
        pointSize: pointSize,
        blinkRadius: animation.value,
      ),
    );
  }
}