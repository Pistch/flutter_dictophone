import 'dart:math';

const SECOND = 1000;
const MINUTE = SECOND * 60;
const HOUR = MINUTE * 60;

String randomString(int length) {
  final Random rng = Random();
  return [
    for (var i = 0; i < length; i++) String.fromCharCode(rng.nextInt(25) + 65)
  ].join('');
}

String getFileSelfName(String fullFilePath) {
  final filePathParts = fullFilePath.split('/');
  final fileNameParts = filePathParts[filePathParts.length - 1].split('.');

  return fileNameParts[0];
}

String leadingZero(int number) {
  final int intNumber = number.toInt();

  return intNumber <= 9 ? '0$intNumber': intNumber.toString();
}

String getFormattedDurationString(int ms) {
  int restOfMs = ms;

  return [HOUR, MINUTE, SECOND]
    .map((unit) {
      final thisUnitAmount = restOfMs ~/ unit;
      restOfMs = restOfMs - thisUnitAmount * unit;

      return leadingZero(thisUnitAmount);
    })
    .join(':');
}