import 'dart:math';

class shap {
  shap() {
    print("Shap constructor called ");
  }

  double calculateArea() {
    return 0.0;
  }

  double CalculateCircumference() {
    return 0.0;
  }
}

class circle extends shap {
  double radius;

  circle(this.radius) : super() {}

  @override
  double calculateArea() {
    return pi * radius * radius;
  }

  @override
  double CalculateCircumference() {
    return 2 * pi * radius;
  }
}

void main() {
  circle c1 = circle(5);

  print("Radius: ${c1.radius}");
  print("Area: ${c1.calculateArea()}");
  print("Circumference: ${c1.CalculateCircumference()}");
}
