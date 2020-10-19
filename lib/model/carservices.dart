class CarServices{

  final String carId;
   String carService;
   int carRate;
   String carDirection;
   String carCustomer;
  String PaymentMethod;
  String time_request;
  String OrderNumber;


  CarServices({this.carId,this.carService,this.carRate,this.carCustomer,this.PaymentMethod,this.time_request,this.OrderNumber});
  factory CarServices.fromJson(Map<String, dynamic> json) {
    return CarServices(
      carId: json['car_id'] as String,
      carService: json['car_service'] as String,
      carRate: json['car_rate'] as int,
      carCustomer : json['carCustomer'] as String,
        PaymentMethod:json['PaymentMethod'] as String,
      time_request: json['time_request'] as String,
        OrderNumber: json['OrderNumber'] as String

    );
  }
}