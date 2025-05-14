
mixin CharactersPaginator {
  int nextPage = 0;

  void incrementNextPage() {
    ++nextPage;
  }

  void resetNextPage() {
    nextPage = 0;
  }
}
