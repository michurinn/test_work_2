import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/presentation/widget/favorite_icon_widget.dart';
import 'package:flutter/material.dart';

class PersonWidget extends StatelessWidget {
  const PersonWidget({
    super.key,
    required this.data,
    this.favoriteValueNotifier,
  });

  final CharacterEntity data;
  final ValueNotifier<Iterable<int>>? favoriteValueNotifier;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 48,
            foregroundImage: Image.network(
              data.photoUrl,
              fit: BoxFit.cover,
            ).image,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              const Size(100, 40),
            ),
            child: Text(data.name),
          ),
          if (favoriteValueNotifier != null)
            ValueListenableBuilder(
              valueListenable: favoriteValueNotifier!,
              builder: (context, value, child) => value.contains(data.id)
                  ? ConstrainedBox(
                      constraints: BoxConstraints.tight(
                        const Size(25, 25),
                      ),
                      child: const FavoriteIcon(),
                    )
                  : const SizedBox(
                      width: 25,
                    ),
            ),
        ],
      ),
    );
  }
}
