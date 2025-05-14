extension GetNextPageNumner on String {
  int? getNextPageNumber() {
    return int.tryParse(split('=')[1]);
  }
}
