import 'package:effective_test_work/src/features/characters/data/dto/characters_dto.dart';
import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/shared/request_operation.dart';

abstract interface class ICharacterRepository {
  RequestOperation<CharactersDto> getCharacters([int page = 0]);
  void insertCharacters(Iterable<CharacterEntity> data);
  Stream<Iterable<CharacterEntity>> getCharactersStream();
}
