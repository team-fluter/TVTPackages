part of tvt_input_keyboard;



enum KeyboardStyle { STYLE1, STYLE2 }

typedef KeyboardTapCallback = void Function(String text);

class Keyboard extends StatefulWidget {
  final TextStyle? textStyle;

  /// Display a custom right icon
  final Icon? rightIcon;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  /// Display a custom left icon
  final Icon? leftIcon;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  final double? numWidth;

  final double? numHeight;

  //final TextEditingController controller;
  final KeyboardStyle style;

  const Keyboard(
      {Key? key,
      // required this.controller,
      this.style = KeyboardStyle.STYLE1,
      required this.onKeyboardTap,
      this.textStyle,
      this.rightButtonFn,
      this.rightIcon,
      this.leftButtonFn,
      this.leftIcon,
      this.numWidth,
      this.numHeight,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly})
      : super(key: key);

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('1',null),
              _calcButton('2','ABC'),
              _calcButton('3','DEF'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('4','GHI'),
              _calcButton('5','JKL'),
              _calcButton('6','MNO'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('7','PQRS'),
              _calcButton('8','TUV'),
              _calcButton('9','WXYZ'),
            ],
          ),
          ButtonBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: widget.leftButtonFn,
                  child: Container(
                      alignment: Alignment.center,
                      width: widget.numWidth ?? 100,
                      height: widget.numHeight ?? 50,
                      child: widget.leftIcon)),
              _calcButton('0',null),
              InkWell(
                  borderRadius: BorderRadius.circular(45),
                  onTap: widget.rightButtonFn,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      width: widget.numWidth ?? 100,
                      height: widget.numHeight ?? 50,
                      child: widget.rightIcon))
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String value1, String? value2) {
    return InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () {
          widget.onKeyboardTap(value1);
        },
        child: Container(
          alignment: Alignment.center,
          width: widget.numWidth ?? 100,
          height: widget.numHeight ?? 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value1,
                style: widget.textStyle,
              ),
              if (value2 != null)
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    value2,
                    style: widget.textStyle!.copyWith(fontSize: widget.textStyle!.fontSize!/2),
                  ),
                )
            ],
          ),
        ));
  }
}
