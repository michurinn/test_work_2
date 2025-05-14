import 'package:effective_test_work/src/features/characters/presentation/characters_widget.dart';
import 'package:effective_test_work/src/shared/wm.dart';
import 'package:flutter/widgets.dart';

class EffectiveMobileElement extends ComponentElement {
  EffectiveMobileElement(super.widget, {required this.wm});
  final Wm wm;
  bool isPerformed = false;

  @override
  void performRebuild() {
    if (!isPerformed) {
      wm.initWm();
    }
    super.performRebuild();
  }

  @override
  void unmount() {
    super.unmount();

    wm.disposeWm();
  }

  @override
  void deactivate() {
    super.deactivate();
    wm.deactivate();
  }

  @override
  void reassemble() {
    super.reassemble();
    wm.reassemble();
  }

  @override
  Widget build() {
    return (widget as Buildable).build(wm);
  }
}
