import 'package:flutter/material.dart';
import 'grouped_buttons_orientation.dart';

class RadioButtonGroup extends StatefulWidget {
  /// A list of strings that describes each Radio button. Each label must be distinct.
  final List<String> labels;

  /// Specifies which Radio button to automatically pick.
  /// Every element must match a label.
  /// This is useful for clearing what is picked (set it to "").
  /// If this is non-null, then the user must handle updating this; otherwise, the state of the RadioButtonGroup won't change.
  final String? picked;

  /// Specifies which buttons should be disabled.
  /// If this is non-null, no buttons will be disabled.
  /// The strings passed to this must match the labels.
  final List<String>? disabled;

  /// Called when the value of the RadioButtonGroup changes.
  final void Function(String label, int index)? onChange;

  /// Called when the user makes a selection.
  final void Function(String selected)? onSelected;

  /// The style to use for the labels.
  final TextStyle? labelStyle;

  /// Specifies the orientation to display elements.
  final GroupedButtonsOrientation? orientation;

  /// Called when needed to build a RadioButtonGroup element.
  final Widget Function(Radio radioButton, InkWell label, int index)?
      itemBuilder;

  //RADIO BUTTON FIELDS
  /// The color to use when a Radio button is checked.
  final Color? activeColor;

  //SPACING STUFF
  /// Empty space in which to inset the RadioButtonGroup.
  final EdgeInsetsGeometry? padding;

  /// Empty space surrounding the RadioButtonGroup.
  final EdgeInsetsGeometry? margin;

  final MainAxisAlignment? alignment;

  final double? distance;

  RadioButtonGroup(
      {Key? key,
      required this.labels,
      this.picked,
      this.disabled,
      this.onChange,
      this.onSelected,
      this.labelStyle = const TextStyle(),
      this.activeColor, //defaults to toggleableActiveColor,
      this.orientation = GroupedButtonsOrientation.HORIZONTAL_ROW,
      this.itemBuilder,
      this.padding = const EdgeInsets.all(0.0),
      this.margin = const EdgeInsets.all(0.0),
      this.alignment = MainAxisAlignment.start,
      this.distance})
      : super(key: key);

  @override
  _RadioButtonGroupState createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  late String _selected;

  @override
  void initState() {
    super.initState();

    //set the selected to the picked (if not null)
    _selected = widget.picked ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //set the selected to the picked (if not null)
    _selected = widget.picked ?? _selected;

    List<Widget> content = [];
    for (int i = 0; i < widget.labels.length; i++) {
      Radio rb = Radio(
        activeColor:
            widget.activeColor ?? Theme.of(context).toggleableActiveColor,
        groupValue: widget.labels.indexOf(_selected),
        value: i,

        //just changed the selected filter to current selection
        //since these are radio buttons, and you can only pick
        //one at a time
        onChanged: (widget.disabled != null &&
                widget.disabled!.contains(widget.labels.elementAt(i)))
            ? (_) {}
            : (var index) => setState(() {
                  _selected = widget.labels.elementAt(i);

                  if (widget.onChange != null)
                    widget.onChange!(widget.labels.elementAt(i), i);
                  if (widget.onSelected != null)
                    widget.onSelected!(widget.labels.elementAt(i));
                }),
      );

      InkWell t = InkWell(
        onTap: (widget.disabled != null &&
                widget.disabled!.contains(widget.labels.elementAt(i)))
            ? () {}
            : () => setState(() {
                  _selected = widget.labels.elementAt(i);

                  if (widget.onChange != null)
                    widget.onChange!(widget.labels.elementAt(i), i);
                  if (widget.onSelected != null)
                    widget.onSelected!(widget.labels.elementAt(i));
                }),
        child: Text(widget.labels.elementAt(i),
            style: (widget.disabled != null &&
                    widget.disabled!.contains(widget.labels.elementAt(i)))
                ? widget.labelStyle!.apply(color: Colors.black)
                : widget.labelStyle),
      );

      if (widget.itemBuilder != null)
        content.add(widget.itemBuilder!(rb, t, i));
      else {
        if (widget.orientation == GroupedButtonsOrientation.VERTICAL) {
          content.add(Row(children: <Widget>[
            SizedBox(width: 12.0),
            Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: rb),
            SizedBox(width: 12.0),
            t,
          ]));
        } else {
          if (widget.orientation ==
              GroupedButtonsOrientation.HORIZONTAL_COLUMN) {
            content.add(Column(children: <Widget>[
              t,
              SizedBox(height: 20.0),
              Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: rb),
            ]));
          } else {
            content.add(Row(children: <Widget>[
              Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: rb),
              SizedBox(width: 10.0),
              t,
              SizedBox(width: widget.distance ?? 20),
            ]));
          }
        }
      }
    }

    return Container(
      padding: widget.padding ?? EdgeInsets.all(8),
      margin: widget.margin ?? EdgeInsets.all(0),
      child: widget.orientation == GroupedButtonsOrientation.VERTICAL
          ? Column(children: content)
          : Row(
              mainAxisAlignment: widget.alignment ?? MainAxisAlignment.start,
              children: content),
    );
  }
}
