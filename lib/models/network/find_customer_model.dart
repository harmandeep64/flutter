List<FindCustomerModel> findCustomerModelFromJson(String str) => List<FindCustomerModel>.from(json.decode(str).map((x) => FindCustomerModel.fromJson(x)));

String findCustomerModelToJson(List<FindCustomerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FindCustomerModel {
  FindCustomerModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.walletAmount,
    this.phoneNumber,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  double? walletAmount;
  String? phoneNumber;

  factory FindCustomerModel.fromJson(Map<String, dynamic> json) => FindCustomerModel(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    walletAmount: json["wallet_amount"].toDouble(),
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "wallet_amount": walletAmount,
    "phone_number": phoneNumber,
  };

  static response({String? search}) async{
    if(search != "") {
      var response = await BaseClient().get("/restaurant-pos/v1/customer/find?search="+search!).catchError((error) {
        HandleException().handleError(error);
      });

      return findCustomerModelFromJson(response);
    }else{
      return [];
    }
  }

  static saveCustomer(params) async{
    var response = await BaseClient().post("/restaurant-pos/v1/customer/new", params).catchError((error) {
      HandleException().handleError(error);
    });

    var customer = findCustomerModelFromJson(response).first;

    return customer;
  }
}
