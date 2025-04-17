int calculateReadingTime(String content) {
  final wordcount = content.split(RegExp(r'\s+')).length;

  final readingTime = (wordcount / 200).ceil();
  return readingTime; 
}
