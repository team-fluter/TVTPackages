part of tvt_tab_bar;

class BottomNavStyle19 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;
  final NavBarDecoration? navBarDecoration;

  BottomNavStyle19({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
    this.navBarDecoration = const NavBarDecoration(),
  });

  Widget _buildItem(BuildContext context, PersistentBottomNavBarItem item,
      bool isSelected, double? height) {
    return this.navBarEssentials!.navBarHeight == 0
        ? SizedBox.shrink()
        : Container(
            width: 150.0,
            height: height,
            color: Colors.transparent,
            padding: EdgeInsets.only(
                top: this.navBarEssentials!.padding?.top ??
                    this.navBarEssentials!.navBarHeight! * 0.1,
                bottom: this.navBarEssentials!.padding?.bottom ??
                    this.navBarEssentials!.navBarHeight! * 0.1),
            child: Container(
              alignment: Alignment.center,
              height: height,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: height! * 0.5,
                        height: height * 0.5,
                        decoration: BoxDecoration(
                            color: isSelected?Color(0xFFA6C2E4).withOpacity(0.2):Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconTheme(
                              data: IconThemeData(
                                  size: item.iconSize,
                                  color: isSelected
                                      ? (item.activeColorSecondary == null
                                          ? item.activeColorPrimary
                                          : item.activeColorSecondary)
                                      : item.inactiveColorPrimary == null
                                          ? item.activeColorPrimary
                                          : item.inactiveColorPrimary),
                              child: isSelected
                                  ? item.icon
                                  : item.inactiveIcon ?? item.icon,
                            )
                          ],
                        ),
                      ),
                      item.title == null
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Material(
                                type: MaterialType.transparency,
                                child: FittedBox(
                                    child: Text(
                                  item.title!,
                                  style: item.textStyle != null
                                      ? (item.textStyle!.apply(
                                          color: isSelected
                                              ? (item.activeColorSecondary ==
                                                      null
                                                  ? item.activeColorPrimary
                                                  : item.activeColorSecondary)
                                              : item.inactiveColorPrimary))
                                      : TextStyle(
                                          color: isSelected
                                              ? (item.activeColorSecondary ==
                                                      null
                                                  ? item.activeColorPrimary
                                                  : item.activeColorSecondary)
                                              : item.inactiveColorPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0),
                                )),
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildMiddleItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
    return this.navBarEssentials!.navBarHeight == 0
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(
                top: this.navBarEssentials!.padding?.top ??
                    this.navBarEssentials!.navBarHeight! *0,
                bottom: this.navBarEssentials!.padding?.bottom ??
                    this.navBarEssentials!.navBarHeight! * 0.1),
            child: Container(
              alignment: Alignment.center,
              height: height,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: height! * 0.6,
                        height: height * 0.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.activeColorPrimary,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF26CBFF), // yellow sun
                              Color(0xFF6980FD), // blue sky
                            ],
                          ),
                          boxShadow: this.navBarDecoration!.boxShadow,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconTheme(
                              data: IconThemeData(
                                  size: item.iconSize,
                                  color: isSelected
                                      ? (item.activeColorSecondary == null
                                          ? item.activeColorPrimary
                                          : item.activeColorSecondary)
                                      : item.inactiveColorPrimary == null
                                          ? item.activeColorPrimary
                                          : item.inactiveColorPrimary),
                              child: isSelected
                                  ? item.icon
                                  : item.inactiveIcon ?? item.icon,
                            )
                          ],
                        ),
                      ),
                      item.title == null
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: FittedBox(
                                      child: Text(
                                        item.title!,
                                        style: item.textStyle != null
                                            ? (item.textStyle!.apply(
                                            color: isSelected
                                                ? (item.activeColorSecondary ==
                                                null
                                                ? item.activeColorPrimary
                                                : item.activeColorSecondary)
                                                : item.inactiveColorPrimary))
                                            : TextStyle(
                                            color: isSelected
                                                ? (item.activeColorSecondary ==
                                                null
                                                ? item.activeColorPrimary
                                                : item.activeColorSecondary)
                                                : item.inactiveColorPrimary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0),
                                  )),
                                ),
                              ),
                            )
                    ],
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarEssentials!.items!.length / 2).floor();
    return Container(
      width: double.infinity,
      height: this.navBarEssentials!.navBarHeight,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius:
                this.navBarDecoration!.borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: this
                      .navBarEssentials!
                      .items![this.navBarEssentials!.selectedIndex!]
                      .filter ??
                  ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarEssentials!.items!.map((item) {
                  int index = this.navBarEssentials!.items!.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (this.navBarEssentials!.items![index].onPressed !=
                            null) {
                          this.navBarEssentials!.items![index].onPressed!(this
                              .navBarEssentials!
                              .selectedScreenBuildContext);
                        } else {
                          this.navBarEssentials!.onItemSelected!(index);
                        }
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              context,
                              item,
                              this.navBarEssentials!.selectedIndex == index,
                              this.navBarEssentials!.navBarHeight),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          this.navBarEssentials!.navBarHeight == 0
              ? SizedBox.shrink()
              : Center(
                  child: GestureDetector(
                      onTap: () {
                        if (this.navBarEssentials!.items![midIndex].onPressed !=
                            null) {
                          this.navBarEssentials!.items![midIndex].onPressed!(
                              this
                                  .navBarEssentials!
                                  .selectedScreenBuildContext);
                        } else {
                          this.navBarEssentials!.onItemSelected!(midIndex);
                        }
                      },
                      child: _buildMiddleItem(
                          this.navBarEssentials!.items![midIndex],
                          this.navBarEssentials!.selectedIndex == midIndex,
                          this.navBarEssentials!.navBarHeight)),
                )
        ],
      ),
    );
  }
}
