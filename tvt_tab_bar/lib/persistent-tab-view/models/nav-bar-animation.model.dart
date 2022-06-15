part of tvt_tab_bar;

class ScreenTransitionAnimation {
  final bool animateTabTransition;
  final Duration duration;
  final Curve curve;

  const ScreenTransitionAnimation({
    this.animateTabTransition = false,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });
}

class ItemAnimationProperties {
  final Duration? duration;
  final Curve? curve;

  const ItemAnimationProperties({this.duration, this.curve});
}
