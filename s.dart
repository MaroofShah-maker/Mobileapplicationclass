import 'dart:io';

void main() {
  double AC = 0.5, Light = 0.001, Fan = 0.2;
  double consUnit = 0, TotalUnit = 0;

  print("Enter # of Hour AV use: ");
  consUnit = double.parse(stdin.readLineSync()!);

  TotalUnit = TotalUnit + consUnit * AC;

  print("Enter # of Hour Light use: ");
  consUnit = double.parse(stdin.readLineSync()!);

  TotalUnit = TotalUnit + consUnit * Light;

  print("Enter # of Hour Fan use: ");
  consUnit = double.parse(stdin.readLineSync()!);

  TotalUnit = TotalUnit + consUnit * Fan;

  print("Total Unit per day : $TotalUnit");
  TotalUnit * = 30;
  print("Total Unit per Month: $TotalUnit");

  if(TotalUnit<=100 && TotalUnit ){
  TotalBill = (TotalUnit * 15) + 0.17;
  }

  else if (TotalUnit > 100 && TotalUnit <=200){
    TotalBill = (TotalUnit * 25)+ 0.17;
  }

  else if (TotalUnit > 200 && TotalUnit <=300){
    TotalBill = (TotalUnit * 35)+ 0.17;
  }

  else  {
    TotalBill = (TotalUnit * 45)+ 0.17;
  }

for(int i=0;i<10;i++){
  print("Total Bill : $TotalBill");
}

}
