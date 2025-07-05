extension StringExtension on String {
  /// Обрезает строку до указанного количества слов
  /// Если строка содержит меньше слов, возвращается исходная строка
  String truncateToWords(int maxWords) {
    // Удаляем лишние пробелы и разбиваем на слова
    final words = trim().split(RegExp(r'\s+'));

    // Если слов меньше или равно требуемому количеству, возвращаем исходную строку
    if (words.length <= maxWords) return this;

    // Берем первые maxWords слов и соединяем обратно в строку
    return words.take(maxWords).join(' ');
  }
}
