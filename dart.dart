import 'dart:io';

void main() {
  int num;
  print("Enter a number: ");
  num = int.parse(stdin.readLineSync()!);

  if (num % 2 == 0) {
    print("The number is divisible by 2.");
    num *= -1;
  } else {
    print("The number is not divisible by 2.");
    num *= 2;
  }
  print("The num is $num");
}
