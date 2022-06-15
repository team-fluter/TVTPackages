
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:tvt_gallery/likk_picker/src/likk_entity.dart';

import '../camera_view.dart';

///
/// Widget to pick media using camera
class CameraViewField extends StatelessWidget {
  ///
  const CameraViewField({
    Key? key,
    this.onCapture,
    this.child,
    this.videoDuration,
    this.imageFormatGroup,
    this.resolutionPreset,
  }) : super(key: key);

  ///
  /// Triggered when picker capture media
  ///
  final void Function(LikkEntity entity)? onCapture;

  /// Video duration. Default is 10 seconds
  final Duration? videoDuration;

  ///
  /// Camera resolution. Default to [ResolutionPreset.medium]
  ///
  final ResolutionPreset? resolutionPreset;

  ///
  /// Camera image format. Default to [ImageFormatGroup.jpeg]
  ///
  final ImageFormatGroup? imageFormatGroup;

  ///
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CameraView.pick(
          context,
          videoDuration: videoDuration,
          resolutionPreset: resolutionPreset,
          imageFormatGroup: imageFormatGroup,
        ).then((value) {
          if (value != null) {
            onCapture?.call(value);
          }
        });
      },
      child: child,
    );
  }
}
