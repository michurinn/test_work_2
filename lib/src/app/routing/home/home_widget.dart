import 'package:dio/dio.dart';
import 'package:effective_test_work/src/database/sqlite_database.dart';
import 'package:effective_test_work/src/features/characters/data/repositories/characters_repository.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_model.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_widget.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_widget_model.dart';
import 'package:effective_test_work/src/features/favorites/data/repositories/favorite_repository.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favorite_model.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favorite_widget.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favotite_widget_model.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.db});
  final SqliteDatabase db;
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
    useLocalData = ValueNotifier(false);
    bottomBarNotifier = ValueNotifier(
      CharactersWidget(
        wm: CharactersWidgetModel(
          useLocalData: useLocalData,
          model: CharactersModel(
            favoriteRepository: FavoriteRepository(db: widget.db),
            repository: CharactersRepository(
                db: widget.db,
                dio: Dio()
                  ..options.baseUrl = 'https://rickandmortyapi.com/api/'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bottomBarNotifier.dispose();
    useLocalData.dispose();
    super.dispose();
  }

  late final ValueNotifier<Widget> bottomBarNotifier;
  late final ValueNotifier<bool> useLocalData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Use local data'),
              ValueListenableBuilder(
                valueListenable: useLocalData,
                builder: (context, value, child) => Switch(
                    value: useLocalData.value,
                    onChanged: (v) => useLocalData.value = v),
              ),
            ],
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: bottomBarNotifier,
          builder: (context, value, child) => value,
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: bottomBarNotifier,
          builder: (context, value, child) => BottomNavigationBar(
              currentIndex: value is CharactersWidget ? 0 : 1,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              onTap: (value) => bottomBarNotifier.value = value == 0
                  ? CharactersWidget(
                      wm: CharactersWidgetModel(
                        useLocalData: useLocalData,
                        model: CharactersModel(
                          favoriteRepository: FavoriteRepository(db: widget.db),
                          repository: CharactersRepository(
                              db: widget.db,
                              dio: Dio()
                                ..options.baseUrl =
                                    'https://rickandmortyapi.com/api/'),
                        ),
                      ),
                    )
                  : FavoriteWidget(
                      wm: FavoriteWidgetModel(
                        model: FavoriteModel(
                          FavoriteRepository(db: widget.db),
                        ),
                      ),
                    ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: 'Common',
                  activeIcon: Icon(
                    Icons.face,
                    color: Colors.green,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.heart_broken_sharp),
                  label: 'Favorites',
                  activeIcon: Icon(
                    Icons.heart_broken,
                    color: Colors.green,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
