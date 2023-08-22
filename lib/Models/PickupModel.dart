// ignore_for_file: file_names

class PickupModel {
  HeaderInfo? headerInfo;
  List<PickupVMs>? pickupVMs;

  PickupModel({this.headerInfo, this.pickupVMs});

  PickupModel.fromJson(Map<String, dynamic> json) {
    headerInfo = json['headerInfo'] != null
        ? HeaderInfo.fromJson(json['headerInfo'])
        : null;
    if (json['pickupVMs'] != null) {
      pickupVMs = <PickupVMs>[];
      json['pickupVMs'].forEach((v) {
        pickupVMs!.add(PickupVMs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headerInfo != null) {
      data['headerInfo'] = headerInfo!.toJson();
    }
    if (pickupVMs != null) {
      data['pickupVMs'] = pickupVMs!.map((v) => v.toJson()).toList();
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

class PickupVMs {
  String? shipperMobileNumber;
  String? shipperAddress;
  String? shipperName;
  String? awb;
  int? scheduleID;
  String? oOrderNumber;
  List<OrderDetails>? orderDetails;

  PickupVMs(
      {this.shipperMobileNumber,
      this.shipperAddress,
      this.shipperName,
      this.awb,
      this.scheduleID,
      this.oOrderNumber,
      this.orderDetails});

  PickupVMs.fromJson(Map<String, dynamic> json) {
    shipperMobileNumber = json['shipper_MobileNumber'];
    shipperAddress = json['shipperAddress'];
    shipperName = json['shipper_Name'];
    awb = json['awb'];
    scheduleID = json['scheduleID'];
    oOrderNumber = json['o_OrderNumber'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipper_MobileNumber'] = shipperMobileNumber;
    data['shipperAddress'] = shipperAddress;
    data['shipper_Name'] = shipperName;
    data['awb'] = awb;
    data['scheduleID'] = scheduleID;
    data['o_OrderNumber'] = oOrderNumber;
    if (orderDetails != null) {
      data['orderDetails'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int? id;
  int? ohOrderId;
  int? oraInventoryItemId;
  String? oraItemCode;
  double? oraUnitLength;
  double? oraUnitWidth;
  double? oraUnitHeight;
  double? oraUnitWeight;
  int? oraNumUnits;
  String? subinventory;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? serviceTime;

  OrderDetails(
      {this.id,
      this.ohOrderId,
      this.oraInventoryItemId,
      this.oraItemCode,
      this.oraUnitLength,
      this.oraUnitWidth,
      this.oraUnitHeight,
      this.oraUnitWeight,
      this.oraNumUnits,
      this.subinventory,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.serviceTime});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ohOrderId = json['ohOrderId'];
    oraInventoryItemId = json['oraInventoryItemId'];
    oraItemCode = json['oraItemCode'];
    oraUnitLength = json['oraUnitLength'];
    oraUnitWidth = json['oraUnitWidth'];
    oraUnitHeight = json['oraUnitHeight'];
    oraUnitWeight = json['oraUnitWeight'];
    oraNumUnits = json['oraNumUnits'];
    subinventory = json['subinventory'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    serviceTime = json['serviceTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ohOrderId'] = ohOrderId;
    data['oraInventoryItemId'] = oraInventoryItemId;
    data['oraItemCode'] = oraItemCode;
    data['oraUnitLength'] = oraUnitLength;
    data['oraUnitWidth'] = oraUnitWidth;
    data['oraUnitHeight'] = oraUnitHeight;
    data['oraUnitWeight'] = oraUnitWeight;
    data['oraNumUnits'] = oraNumUnits;
    data['subinventory'] = subinventory;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['modifiedBy'] = modifiedBy;
    data['modifiedDate'] = modifiedDate;
    data['serviceTime'] = serviceTime;
    return data;
  }
}
