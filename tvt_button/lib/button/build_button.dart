
part of tvt_button;




class ButtonWithIcon {
  final String? text;
  final Widget? icon;
  final Color color;

  const ButtonWithIcon({
    this.text,
    this.icon,
    required this.color,
  });
}

Widget buildChildWithIcon(
    ButtonWithIcon stateButton, double iconPadding, TextStyle textStyle) {
  return buildChildWithIC(
      stateButton.text, stateButton.icon, iconPadding, textStyle);
}

Widget buildChildWithIC(
    String? text, Widget? icon, double gap, TextStyle textStyle) {
  var children = <Widget>[];
  children.add(icon ?? Container());
  if (text != null) {
    children.add(Padding(padding: EdgeInsets.all(gap)));
    children.add(buildText(text, textStyle));
  }

  return Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}

Widget buildText(String text, TextStyle style) {
  return Text(text, style: style);
}