import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:photo_manager/photo_manager.dart';

// ignore: always_use_package_imports
import '../controllers/gallery_repository.dart';
// ignore: always_use_package_imports
import '../gallery_view.dart';
// ignore: always_use_package_imports
import 'gallery_builder.dart';

///
class GalleryHeader extends StatefulWidget {
  ///
  const GalleryHeader({
    Key? key,
    required this.controller,
    required this.onClose,
    required this.onAlbumToggle,
    required this.albumVisibility,
    required this.albumNotifier,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final void Function() onClose;

  ///
  final void Function(bool visible) onAlbumToggle;

  ///
  final ValueNotifier<bool> albumVisibility;

  ///
  final ValueNotifier<AlbumType> albumNotifier;

  @override
  _GalleryHeaderState createState() => _GalleryHeaderState();
}

class _GalleryHeaderState extends State<GalleryHeader> {
  late final GalleryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final headerSetting = _controller.headerSetting;

    return ClipRRect(
      borderRadius: headerSetting.borderRadius,
      child: Container(
        constraints: BoxConstraints(
          minHeight: headerSetting.headerMinHeight,
          maxHeight: headerSetting.headerMaxHeight +
              (_controller.fullScreenMode
                  ? MediaQuery.of(context).padding.top
                  : 0),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: headerSetting.headerBackground,
            ),
            Column(
              children: [
                // Handler
                _Handler(controller: _controller),

                // Details and controls
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close icon
                      _IconButton(
                        icon: _controller.headerSetting.headerLeftWidget,
                        onPressed: widget.onClose,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AnimatedDropdown(
                            controller: _controller,
                            onPressed: widget.onAlbumToggle,
                            albumVisibility: widget.albumVisibility,
                            albumNotifier: widget.albumNotifier,
                            builder: _controller.headerSetting.albumBuilder,
                          ),
                          _controller.headerSetting.headerCenterWidget,
                        ],
                      ),
                      _controller.headerSetting.headerRightWidget,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDropdown extends StatelessWidget {
  const _AnimatedDropdown({
    Key? key,
    required this.controller,
    required this.onPressed,
    required this.albumVisibility,
    required this.albumNotifier,
    this.builder,
  }) : super(key: key);

  final GalleryController controller;

  ///
  final void Function(bool visible) onPressed;

  ///
  final ValueNotifier<bool> albumVisibility;

  ///
  final ValueNotifier<AlbumType> albumNotifier;

  ///
  final Widget Function(BuildContext, BaseState<AssetPathEntity>, Widget?)?
      builder;

  Widget _child(bool visible) {
    return ValueListenableBuilder<AlbumType>(
      valueListenable: albumNotifier,
      builder: builder ??
          (context, album, child) {
            return Row(
              children: [
                Text(
                  album.data?.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                // TweenAnimationBuilder<double>(
                //   tween: Tween(
                //     begin: visible ? 0.0 : 1.0,
                //     end: visible ? 1.0 : 0.0,
                //   ),
                //   duration: const Duration(milliseconds: 300),
                //   builder: (context, factor, child) {
                //     return Transform.rotate(
                //       angle: pi * factor,
                //       child: child,
                //     );
                //   },
                //   child: const _IconButton(
                //     icon: Icons.keyboard_arrow_down,
                //     size: 34,
                //   ),
                // )
              ],
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalleryBuilder(
      controller: controller,
      builder: (value, child) => child!,
      child: ValueListenableBuilder<bool>(
        valueListenable: albumVisibility,
        builder: (context, visible, child) {
          return Platform.isAndroid
              ? InkWell(
                  onTap: () => onPressed(visible),
                  child: _child(visible),
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => onPressed(visible),
                  child: _child(visible),
                );
        },
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.size,
  }) : super(key: key);

  /// IconData or Widget
  final dynamic icon;
  final void Function()? onPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = const SizedBox();
    if (icon == null) iconWidget = const SizedBox();
    if (icon is IconData) {
      final _icon = icon as IconData;
      iconWidget = Icon(
        _icon,
        color: Colors.lightBlue.shade300,
        size: size ?? 26.0,
      );
    }
    if (icon is Widget) {
      iconWidget = icon as Widget;
    }
    return Platform.isAndroid
        ? Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(size ?? 40.0),
            color: Colors.transparent,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: iconWidget,
              iconSize: size ?? 26.0,
              onPressed: onPressed,
            ),
          )
        : CupertinoButton(
            borderRadius: BorderRadius.circular(size ?? 40.0),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            child: iconWidget,
          );
  }
}

class _Handler extends StatelessWidget {
  const _Handler({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.fullScreenMode) {
      return SizedBox(height: MediaQuery.of(context).padding.top);
    }

    return SizedBox(
      height: controller.headerSetting.headerMinHeight,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: controller.headerSetting.barSize.width,
            height: controller.headerSetting.barSize.height,
            color: controller.headerSetting.barColor,
          ),
        ),
      ),
    );
  }
}
