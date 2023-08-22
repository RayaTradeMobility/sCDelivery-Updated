// ignore_for_file: file_names

class ReleaseDetailsModel {
  HeaderInfo? headerInfo;
  ReleaseRequests? releaseRequests;

  ReleaseDetailsModel({this.headerInfo, this.releaseRequests});

  ReleaseDetailsModel.fromJson(Map<String, dynamic> json) {
    headerInfo = json['headerInfo'] != null
        ? HeaderInfo.fromJson(json['headerInfo'])
        : null;
    releaseRequests = json['releaseRequests'] != null
        ? ReleaseRequests.fromJson(json['releaseRequests'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headerInfo != null) {
      data['headerInfo'] = headerInfo!.toJson();
    }
    if (releaseRequests != null) {
      data['releaseRequests'] = releaseRequests!.toJson();
    }
    return data;
  }
}

class HeaderInfo {
  String? code;
  String? message;

  HeaderInfo({this.code, this.message});

  HeaderInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class ReleaseRequests {
  int? releaseId;
  String? orderId;
  String? cName;
  String? cAddress;
  String? cMobileNumber1;
  String? dNameAr;
  String? oCreatedDate;
  String? cMobileNumber2;
  int? sShipmentNo;
  int? rShipmentId;
  String? wName;
  String? oAwbUniqueNumber;
  String? paymentMethod;
  double? oOrderPod;
  List<ItemsDriverVMs>? itemsDriverVMs;

  ReleaseRequests(
      {this.releaseId,
      this.orderId,
      this.cName,
      this.cAddress,
      this.cMobileNumber1,
      this.dNameAr,
      this.oCreatedDate,
      this.cMobileNumber2,
      this.sShipmentNo,
      this.rShipmentId,
      this.wName,
      this.oAwbUniqueNumber,
      this.paymentMethod,
      this.oOrderPod,
      this.itemsDriverVMs});

  ReleaseRequests.fromJson(Map<String, dynamic> json) {
    releaseId = json['releaseId'];
    orderId = json['orderId'];
    cName = json['cName'];
    cAddress = json['cAddress'];
    cMobileNumber1 = json['cMobileNumber1'];
    dNameAr = json['dNameAr'];
    oCreatedDate = json['oCreatedDate'];
    cMobileNumber2 = json['cMobileNumber2'];
    sShipmentNo = json['sShipmentNo'];
    rShipmentId = json['rShipmentId'];
    wName = json['wName'];
    oAwbUniqueNumber = json['oAwbUniqueNumber'];
    paymentMethod = json['paymentMethod'];
    oOrderPod = json['oOrderPod'];
    if (json['itemsDriverVMs'] != null) {
      itemsDriverVMs = <ItemsDriverVMs>[];
      json['itemsDriverVMs'].forEach((v) {
        itemsDriverVMs!.add(ItemsDriverVMs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['releaseId'] = releaseId;
    data['orderId'] = orderId;
    data['cName'] = cName;
    data['cAddress'] = cAddress;
    data['cMobileNumber1'] = cMobileNumber1;
    data['dNameAr'] = dNameAr;
    data['oCreatedDate'] = oCreatedDate;
    data['cMobileNumber2'] = cMobileNumber2;
    data['sShipmentNo'] = sShipmentNo;
    data['rShipmentId'] = rShipmentId;
    data['wName'] = wName;
    data['oAwbUniqueNumber'] = oAwbUniqueNumber;
    data['paymentMethod'] = paymentMethod;
    data['oOrderPod'] = oOrderPod;
    if (itemsDriverVMs != null) {
      data['itemsDriverVMs'] = itemsDriverVMs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsDriverVMs {
  String? oraItemCode;
  int? rQuantity;

  ItemsDriverVMs({this.oraItemCode, this.rQuantity});

  ItemsDriverVMs.fromJson(Map<String, dynamic> json) {
    oraItemCode = json['oraItemCode'];
    rQuantity = json['rQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oraItemCode'] = oraItemCode;
    data['rQuantity'] = rQuantity;
    return data;
  }
}
