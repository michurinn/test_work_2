import 'package:effective_test_work/src/app/mwwm/effective_mobile_element.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_widget.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favorite_state.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favotite_widget_model.dart';
import 'package:effective_test_work/src/shared/extensions/hardcoded.dart';
import 'package:effective_test_work/src/shared/widgets/person_widget.dart';
import 'package:effective_test_work/src/shared/wm.dart';
import 'package:flutter/material.dart';

class FavoriteWidget extends Widget implements Buildable<Wm> {
  final FavoriteWidgetModel wm;

  const FavoriteWidget({
    super.key,
    required this.wm,
  });
  @override
  Element createElement() => EffectiveMobileElement(
        this,
        wm: wm,
      );

  @override
  Widget build(Wm _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite characters'.hardcoded,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: wm.stateNotifier,
        builder: (_, value, child) {
          return switch (value) {
            LoadingFavoriteState() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ErrorFavoriteState(:final failure) => Text(
                failure.toString(),
              ),
            LoadedFavoriteState(:final data) => ListView.separated(
                itemBuilder: (_, index) => PersonWidget(
                  data: data[index],
                ),
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemCount: data.length,
              ),
          };
        },
      ),
    );
  }
}
