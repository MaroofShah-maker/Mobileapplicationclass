import 'dart:io';

class Calculator {
  late int _result;
  late int _num;

  Calculator() {
    this._result = 1;
    this._num = 0;
  }

  set setnum(int num) {
    this._num = num;
  }

  void factorial() {
    int result = 1;
    for (int i = 1; i <= _num; i++) {
      result = result * i;
    }
    //return result;
  }

  int get getresult {
    return _result;
  }
}

void main() {
  print("Enter a number");
  int num = int.parse(stdin.readLineSync()!);

  Calculator cal = new Calculator();

  cal.setnum = num;
  cal.factorial();
  print(cal.getresult);
  print("Factorial of $num : ${cal.getresult}");
  print("factorial $num = ${factorial(num)}");
}
