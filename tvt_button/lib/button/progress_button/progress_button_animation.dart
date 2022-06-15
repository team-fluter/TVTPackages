part of tvt_button;

enum ButtonStatus { idle, loading, success, fail }

class ProgressButtonAnimation extends StatefulWidget {
  final Map<ButtonStatus, Widget>? stateWidgets;
  final Map<ButtonStatus, Color>? stateColors;
  final Widget? stateWidget;
  final Color? stateColor;
  final Function? onPressed;
  final Function? onAnimationEnd;
  final ButtonStatus? state;
  final double minWidth;
  final double maxWidth;
  final double radius;
  final double height;
  final ProgressIndicator? progressIndicator;
  final double progressIndicatorSize;
  final MainAxisAlignment progressIndicatorAlignment;
  final EdgeInsets padding;
  final List<ButtonStatus> minWidthStates;

  ProgressButtonAnimation(
      {Key? key,
      this.stateWidget,
      this.stateColor,
      this.stateWidgets,
      this.stateColors,
      this.state = ButtonStatus.idle,
      this.onPressed,
      this.onAnimationEnd,
      this.minWidth = 58,
      this.maxWidth = 400,
      this.radius = 100,
      this.height = 53,
      this.progressIndicatorSize = 35,
      this.progressIndicator,
      this.progressIndicatorAlignment = MainAxisAlignment.center,
      this.padding = EdgeInsets.zero,
      this.minWidthStates = const <ButtonStatus>[ButtonStatus.loading]})
      : super(key: key);

  @override
  _ProgressButtonAnimationState createState() =>
      _ProgressButtonAnimationState();

  factory ProgressButtonAnimation.icon({
    Map<ButtonStatus, ButtonWithIcon>? buttonWithIcons,
    ButtonWithIcon? buttonWithIcon,
    Function? onPressed,
    ButtonStatus? state = ButtonStatus.idle,
    Function? animationEnd,
    double maxWidth: 170.0,
    double minWidth: 58.0,
    double height: 53.0,
    double radius: 100.0,
    double progressIndicatorSize: 35.0,
    double iconPadding: 4.0,
    TextStyle? textStyle,
    CircularProgressIndicator? progressIndicator,
    MainAxisAlignment? progressIndicatorAlignment,
    EdgeInsets padding = EdgeInsets.zero,
    List<ButtonStatus> minWidthStates = const <ButtonStatus>[
      ButtonStatus.loading
    ],
  }) {
    if (textStyle == null) {
      textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);
    }
    Map<ButtonStatus, Widget>? _stateWidgets = {};
    Map<ButtonStatus, Color>? _stateColors = {};
    Widget? _stateWidget;
    Color? _stateColor;
    if (buttonWithIcon != null) {
      _stateWidget = buildChildWithIcon(buttonWithIcon, iconPadding, textStyle);
      _stateColor = buttonWithIcon.color;
    }
    if (buttonWithIcons != null) {
      _stateWidgets = {
        ButtonStatus.idle: buildChildWithIcon(
            buttonWithIcons[ButtonStatus.idle]!, iconPadding, textStyle),
        ButtonStatus.loading: buildChildWithIcon(
            buttonWithIcons[ButtonStatus.loading]!, iconPadding, textStyle),
        ButtonStatus.fail: buildChildWithIcon(
            buttonWithIcons[ButtonStatus.fail]!, iconPadding, textStyle),
        ButtonStatus.success: buildChildWithIcon(
            buttonWithIcons[ButtonStatus.success]!, iconPadding, textStyle)
      };
      _stateColors = {
        ButtonStatus.idle: buttonWithIcons[ButtonStatus.idle]!.color,
        ButtonStatus.loading: buttonWithIcons[ButtonStatus.loading]!.color,
        ButtonStatus.fail: buttonWithIcons[ButtonStatus.fail]!.color,
        ButtonStatus.success: buttonWithIcons[ButtonStatus.success]!.color,
      };
    }

    return ProgressButtonAnimation(
      stateWidgets: _stateWidgets,
      stateColors: _stateColors,
      stateColor: _stateColor,
      stateWidget: _stateWidget,
      state: state,
      onPressed: onPressed,
      onAnimationEnd: animationEnd,
      maxWidth: maxWidth,
      minWidth: minWidth,
      radius: radius,
      height: height,
      progressIndicatorSize: progressIndicatorSize,
      progressIndicatorAlignment: MainAxisAlignment.center,
      progressIndicator: progressIndicator,
      minWidthStates: minWidthStates,
    );
  }
}

class _ProgressButtonAnimationState extends State<ProgressButtonAnimation>
    with TickerProviderStateMixin {
  AnimationController? colorAnimationController;
  Animation<Color?>? colorAnimation;
  double? width;
  Duration animationDuration = Duration(milliseconds: 300);
  Widget? progressIndicator;
  Map<ButtonStatus, Widget> _stateWidgets = {
    ButtonStatus.idle: Text(
      "Idle",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonStatus.loading: Text(
      "Loading",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonStatus.fail: Text(
      "Fail",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    ButtonStatus.success: Text(
      "Success",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    )
  };
  Map<ButtonStatus, Color>? _stateColors = {
    ButtonStatus.idle: Colors.blueGrey.shade400,
    ButtonStatus.loading: Colors.blue.shade300,
    ButtonStatus.fail: Colors.red.shade300,
    ButtonStatus.success: Colors.green.shade400,
  };
  ButtonStatus _state = ButtonStatus.idle;

  void startAnimations(ButtonStatus? oldState, ButtonStatus? newState) {
    Color? begin = _stateColors![oldState!];
    Color? end = _stateColors![newState!];
    if (widget.minWidthStates.contains(newState)) {
      setState(() {
        width = widget.minWidth;
      });
    } else {
      width = widget.maxWidth;
    }
    colorAnimation = ColorTween(begin: begin, end: end).animate(CurvedAnimation(
      parent: colorAnimationController!,
      curve: Interval(
        0,
        1,
        curve: Curves.easeIn,
      ),
    ));
    colorAnimationController!.forward();
  }

  Color? get backgroundColor => colorAnimation == null
      ? _stateColors![_state]
      : colorAnimation!.value ?? _stateColors![_state];

  @override
  void initState() {
    super.initState();

    width = widget.maxWidth;

    if (widget.state != null) {
      setState(() {
        _state = widget.state!;
      });
    }
    if (widget.stateWidgets != null) {
      setState(() {
        _stateWidgets = widget.stateWidgets!;
      });
    }
    if (widget.stateWidget != null) {
      _stateWidgets = {
        ButtonStatus.idle: widget.stateWidget!,
        ButtonStatus.loading: Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      };
    }
    if (widget.stateColors != null) {
      setState(() {
        _stateColors = widget.stateColors!;
      });
    }
    if (widget.stateColor != null) {
      _stateColors = {
        ButtonStatus.idle: widget.stateColor!,
        ButtonStatus.loading: widget.stateColor!,
      };
    }
    colorAnimationController =
        AnimationController(duration: animationDuration, vsync: this);

    colorAnimationController!.addStatusListener((status) {
      if (widget.onAnimationEnd != null) {
        widget.onAnimationEnd!(status, _state);
      }
    });

    progressIndicator = widget.progressIndicator ??
        CircularProgressIndicator(
            backgroundColor: _stateColors![_state],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
  }

  @override
  void dispose() {
    colorAnimationController!.dispose();
    super.dispose();
  }

  void onPressedCustomButton() {
    if (widget.onPressed == null) {
      colorAnimationController?.reset();
      startAnimations(ButtonStatus.idle, ButtonStatus.loading);
      setState(() {
        _state = ButtonStatus.loading;
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          _state = ButtonStatus.idle;
        });
        colorAnimationController?.reset();
        startAnimations(ButtonStatus.loading, ButtonStatus.idle);
      });
    } else {
      widget.onPressed!();
    }
  }

  @override
  void didUpdateWidget(ProgressButtonAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != null) {
      setState(() {
        _state = widget.state!;
      });
    }
    if (oldWidget.state != _state) {
      colorAnimationController?.reset();
      startAnimations(oldWidget.state, _state);
    }
  }

  Widget getButtonChild(bool visibility) {
    Widget? buttonChild = _stateWidgets[_state];
    if (_state == ButtonStatus.loading) {
      return Row(
        mainAxisAlignment: widget.progressIndicatorAlignment,
        children: <Widget>[
          SizedBox(
            child: progressIndicator,
            width: widget.progressIndicatorSize,
            height: widget.progressIndicatorSize,
          ),
          if (width! > 60)
            SizedBox(
              width: 10,
            ),
          if (width! > 60) buttonChild ?? Container(),
        ],
      );
    }
    return AnimatedOpacity(
        opacity: visibility ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: buttonChild);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimationController!,
      builder: (context, child) {
        return AnimatedContainer(
            width: width,
            height: widget.height,
            duration: animationDuration,
            child: MaterialButton(
              padding: widget.padding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                  side: BorderSide(color: Colors.transparent, width: 0)),
              color: backgroundColor,
              onPressed: onPressedCustomButton,
              child: getButtonChild(
                  colorAnimation == null ? true : colorAnimation!.isCompleted),
            ));
      },
    );
  }
}
