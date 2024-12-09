class PaymentMethodModel {
  String? status;
  List<Data>? data;

  PaymentMethodModel({this.status, this.data});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? paymentId;
  String? nameEn;
  String? nameAr;
  String? redirect;
  String? logo;

  Data({this.paymentId, this.nameEn, this.nameAr, this.redirect, this.logo});

  Data.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    redirect = json['redirect'];
    logo = json['logo'];
  }
}
