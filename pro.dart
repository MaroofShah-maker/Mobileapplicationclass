import 'dart:io';

void main() {
  print("Enter a first number: ");
  int num1 = int.parse(stdin.readLineSync()!);

  print("Enter a second number: ");
  int num2 = int.parse(stdin.readLineSync()!);

  if (num1 > num2) {
    print("$num1 is greater than $num2");
  } else if (num1 < num2) {
    print("$num2 is greater than $num1");
  } else {
    print("Both numbers are equal.");
  }
}
