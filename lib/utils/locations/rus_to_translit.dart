String transliterate(String text) {
  Map<String, String> translitMap = {
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'g',
    'д': 'd',
    'е': 'e',
    'ё': 'yo',
    'ж': 'zh',
    'з': 'z',
    'и': 'i',
    'й': 'y',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'h',
    'ц': 'ts',
    'ч': 'ch',
    'ш': 'sh',
    'щ': 'sch',
    'ъ': '',
    'ы': 'y',
    'ь': '',
    'э': 'e',
    'ю': 'yu',
    'я': 'ya'
  };

  String result = '';
  RegExp regexp = RegExp(r'[a-zA-Zа-яА-Я]');
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    if (regexp.hasMatch(char) && translitMap.containsKey(char.toLowerCase())) {
      if (char == char.toUpperCase()) {
        result += translitMap[char.toLowerCase()]!.toUpperCase();
      } else {
        result += translitMap[char.toLowerCase()]!;
      }
    } else {
      result += char;
    }
  }
  return result;
}