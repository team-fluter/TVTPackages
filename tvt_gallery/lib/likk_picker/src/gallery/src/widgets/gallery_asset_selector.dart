
import 'package:flutter/material.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:tvt_gallery/likk_picker/src/likk_entity.dart';

import '../entities/gallery_value.dart';
import '../gallery_view.dart';

///
class GalleryAssetSelector extends StatefulWidget {
  ///
  const GalleryAssetSelector({
    Key? key,
    required this.controller,
    required this.onSubmit,
    required this.onEdit,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final void Function(BuildContext context) onSubmit;

  ///
  final ValueSetter<LikkEntity> onEdit;

  @override
  GalleryAssetSelectorState createState() => GalleryAssetSelectorState();
}

///
class GalleryAssetSelectorState extends State<GalleryAssetSelector>
    with TickerProviderStateMixin {
  late AnimationController _editOpaController;
  late AnimationController _selectOpaController;
  late AnimationController _selectSizeController;
  late Animation<double> _editOpa;
  late Animation<double> _selectOpa;
  late Animation<double> _selectSize;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _editOpaController = AnimationController(vsync: this, duration: duration);
    _selectOpaController = AnimationController(vsync: this, duration: duration);
    _selectSizeController =
        AnimationController(vsync: this, duration: duration);

    final tween = Tween(begin: 0.0, end: 1.0);

    _editOpa = tween.animate(CurvedAnimation(
      parent: _editOpaController,
      curve: Curves.easeIn,
    ));

    _selectOpa = tween.animate(CurvedAnimation(
      parent: _selectOpaController,
      curve: Curves.easeIn,
    ));

    _selectSize = tween.animate(CurvedAnimation(
      parent: _selectSizeController,
      curve: Curves.easeIn,
    ));

    _checkShow();

    widget.controller.addListener(() {
      if (mounted) {
        _checkShow();
      }
    });
  }

  void _checkShow() {
    final entities = widget.controller.value.selectedEntities;

    if (widget.controller.value.selectedEntities.length <=
        widget.controller.setting.maximum) {
      if (entities.isEmpty && _selectOpaController.value == 1.0) {
        _editOpaController.reverse();
        _selectOpaController.reverse();
      }

      if (entities.isNotEmpty) {
        if (entities.length == 1) {
          _editOpaController.forward();
          _selectOpaController.forward();
          _selectSizeController.reverse();
        } else {
          _editOpaController.reverse();
          _selectSizeController.forward();
          if (_selectOpaController.value == 0.0) {
            _selectOpaController.forward();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _editOpaController.dispose();
    _selectOpaController.dispose();
    _selectSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const padding = 20.0 + 16.0 + 20.0;
    final buttonWidth = (size.width - padding) / 2;

    return ValueListenableBuilder<GalleryValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.controller.setting.actionButton != null
                ? AnimatedBuilder(
                    animation: _selectOpa,
                    builder: (context, child) {
                      final hide = (value.selectedEntities.isEmpty &&
                              !_selectOpaController.isAnimating) ||
                          _selectOpa.value == 0.0;

                      return hide
                          ? const SizedBox()
                          : Opacity(
                              opacity: _selectOpa.value,
                              child: child,
                            );
                    },
                    child: widget.controller.setting.actionButton,
                  )
                : Row(
                    children: [
                      // Edit button

                      AnimatedContainer(
                        width: value.selectedEntities.length == 1
                            ? (size.width / 2) - 24
                            : 0,
                        duration: const Duration(milliseconds: 250),
                        child: AnimatedBuilder(
                          animation: _editOpa,
                          builder: (context, child) {
                            final hide = (value.selectedEntities.isEmpty &&
                                    !_editOpaController.isAnimating) ||
                                _editOpa.value == 0.0;
                            return hide
                                ? const SizedBox()
                                : Opacity(
                                    opacity: _editOpa.value,
                                    child: child,
                                  );
                          },
                          child: SizedBox(
                            width: buttonWidth,
                            child: _TextButton(
                              onPressed: () =>
                                  widget.onEdit(value.selectedEntities.first),
                              label: 'EDIT',
                              background: Colors.white,
                              labelColor: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Margin
                      AnimatedContainer(
                        width: value.selectedEntities.length == 1 ? 16 : 0,
                        duration: const Duration(milliseconds: 250),
                      ),

                      // Select
                      AnimatedContainer(
                        width: value.selectedEntities.length == 1
                            ? (size.width / 2) - 24
                            : size.width - 32,
                        duration: const Duration(milliseconds: 250),
                        child: AnimatedBuilder(
                          animation: _selectOpa,
                          builder: (context, child) {
                            final hide = (value.selectedEntities.isEmpty &&
                                    !_selectOpaController.isAnimating) ||
                                _selectOpa.value == 0.0;

                            return hide
                                ? const SizedBox()
                                : Opacity(
                                    opacity: _selectOpa.value,
                                    child: child,
                                  );
                          },
                          child: AnimatedBuilder(
                            animation: _selectSize,
                            builder: (context, child) {
                              return SizedBox(
                                width: buttonWidth +
                                    _selectSize.value * (buttonWidth + 20.0),
                                child: child,
                              );
                            },
                            child: _TextButton(
                              onPressed: () => widget.onSubmit(context),
                              label: 'SELECT',
                            ),
                          ),
                        ),
                      ),

                      // Send Button
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({
    Key? key,
    this.label,
    this.background,
    this.labelColor,
    this.onPressed,
  }) : super(key: key);

  final String? label;
  final Color? background;
  final Color? labelColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
      ),
      child: Text(
        label ?? '',
        style: Theme.of(context).textTheme.button!.copyWith(
              color: labelColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
        maxLines: 1,
      ),
    );
  }
}
