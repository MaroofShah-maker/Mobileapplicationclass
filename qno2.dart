import 'dart:io';

void main() {
  print("Enter first integer:");
  int num1 = int.parse(stdin.readLineSync()!);

  print("Enter second integer:");
  int num2 = int.parse(stdin.readLineSync()!);

  print("\nSelect an operation:");
  print("1. + Addition");
  print("2. - Subtraction");
  print("3. * Multiplication");
  print("4. / Division");
  print("5. % Modulus");

  int choice = int.parse(stdin.readLineSync()!);

  switch (choice) {
    case 1:
      print("Result = ${num1 + num2}");
      break;

    case 2:
      print("Result = ${num1 - num2}");
      break;

    case 3:
      print("Result = ${num1 * num2}");
      break;

    case 4:
      print("Result = ${num1 / num2}");
      break;

    case 5:
      print("Result = ${num1 % num2}");
      break;

    default:
      print("Invalid choice!");
  }
}
