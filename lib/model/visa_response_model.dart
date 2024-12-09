class VisaResponseModel {
  String? status;
  Data? data;

  VisaResponseModel({this.status, this.data});

  VisaResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? invoiceId;
  String? invoiceKey;
  PaymentData? paymentData;

  Data({this.invoiceId, this.invoiceKey, this.paymentData});

  Data.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    invoiceKey = json['invoice_key'];
    paymentData = json['payment_data'] != null
        ? PaymentData.fromJson(json['payment_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_id'] = invoiceId;
    data['invoice_key'] = invoiceKey;
    if (paymentData != null) {
      data['payment_data'] = paymentData!.toJson();
    }
    return data;
  }
}

class PaymentData {
  String? redirectTo;

  PaymentData({this.redirectTo});

  PaymentData.fromJson(Map<String, dynamic> json) {
    redirectTo = json['redirectTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['redirectTo'] = redirectTo;
    return data;
  }
}