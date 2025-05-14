import 'package:effective_test_work/src/app/mwwm/effective_mobile_element.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_state.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_widget_model.dart';
import 'package:effective_test_work/src/shared/extensions/hardcoded.dart';
import 'package:effective_test_work/src/shared/widgets/person_widget.dart';
import 'package:flutter/material.dart';

class CharactersWidget<T extends CharactersWidgetModel> extends Widget
    implements Buildable<T> {
  final T wm;

  const CharactersWidget({
    super.key,
    required this.wm,
  });

  @override
  Element createElement() => EffectiveMobileElement(
        this,
        wm: wm,
      );

  @override
  Widget build(T _) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All characters'.hardcoded),
      ),
      body: ValueListenableBuilder(
        valueListenable: wm.stateNotifier,
        builder: (context, value, child) {
          return switch (value) {
            LoadingCharactersState() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ErrorCharactersState(:final failure) => Text(
                failure.description.toString(),
              ),
            LoadedCharactersState(:final data) => ListView.separated(
                controller: wm.scrollController,
                itemBuilder: (context, index) => GestureDetector(
                  onDoubleTap: () => wm.addFavorite(data[index]),
                  child: PersonWidget(
                    data: data[index],
                    favoriteValueNotifier: wm.favoritesListenable,
                  ),
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

abstract interface class Buildable<T> {
  Widget build(T wm);
}
