import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({super.key});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Durations.extralong1, vsync: this)
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        /// log(_controller.value.toString(), name: 'cvalue');
        return _FavoriteIconWidget(_controller.value);
      },
    );
  }
}

@immutable
class _FavoriteIconWidget extends LeafRenderObjectWidget {
  const _FavoriteIconWidget(this.dimension, {super.key});
  final double dimension;
  @override
  RenderObject createRenderObject(BuildContext context) {
    /// log(dimension.toString(), name: 'dimension');
    return _FavoriteRenderObject();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _FavoriteRenderObject renderObject) {
    ///renderObject..dimension = dimension;
  }
}

final class _FavoriteRenderObject extends RenderBox {
  final ValueNotifier<double> animation = ValueNotifier<double>(1);
  _FavoriteRenderObject();
  late final double _kIconSize = 25;

  late Timer timer;

  @override
  void attach(PipelineOwner owner) {
    timer = _startTimer();
    animation.addListener(markNeedsPaint);
    super.attach(owner);
  }

  Timer _startTimer() {
    return Timer.periodic(
      const Duration(milliseconds: 200),
      (t) => animation.value = animation.value +
          (t.tick % 10 > 5 ? -0.1 * (t.tick % 5) : 0.1 * (t.tick % 5)),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    animation.dispose();
    super.dispose();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return Size(constraints.minWidth, constraints.minHeight);
  }

  @override
  void performLayout() {
    size = Size(
      _kIconSize,
      _kIconSize,
    );
  }

  @override
  bool hitTestSelf(Offset position) {
    return super.hitTestSelf(position);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (timer.isActive) {
      timer.cancel();
    } else {
      timer = _startTimer();
    }
    return super.hitTest(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final computedSize = size;
    final shaderOffset =
        offset + Offset(computedSize.width / 2, computedSize.height / 2);
    final Shader gradientShader = RadialGradient(
            colors: [Colors.pink.withOpacity(0.3), Colors.pink.shade50])
        .createShader(
      Rect.fromCircle(
        center: shaderOffset,
        radius: animation.value * computedSize.width / 2,
      ),
    );
    final paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 3.3;
    final gradientPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradientShader;

    final upd = context.canvas
      ..drawCircle(shaderOffset, computedSize.width, gradientPaint)
      ..drawArc(
          Rect.fromLTRB(
              offset.dx,
              offset.dy + 5,
              offset.dx + computedSize.width / 2,
              5 + offset.dy + computedSize.width / 2),
          math.pi * 3 / 4,
          math.pi * 3 / 2,
          false,
          paint)
      ..drawRRect(
          RRect.fromLTRBR(
            offset.dx,
            offset.dy + computedSize.width / 2,
            offset.dx + computedSize.width / 2,
            offset.dy + computedSize.width,
            const Radius.circular(1),
          ),
          paint)
      ..drawArc(
          Rect.fromLTRB(
              offset.dx + computedSize.width / 2 - 5,
              offset.dy + computedSize.width / 2,
              offset.dx + computedSize.width - 5,
              offset.dy + computedSize.width),
          math.pi * 3 / 4,
          -math.pi * 3 / 2,
          false,
          paint);
    upd.rotate(math.pi / 4);
    upd.save();
    super.paint(context, offset);
  }
}
