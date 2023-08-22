// ignore_for_file: file_names

class ReleasesModel {
  HeaderInfo? headerInfo;
  List<ReleaseRequests>? releaseRequests;

  ReleasesModel({this.headerInfo, this.releaseRequests});

  ReleasesModel.fromJson(Map<String, dynamic> json) {
    headerInfo = json['headerInfo'] != null
        ? HeaderInfo.fromJson(json['headerInfo'])
        : null;
    if (json['releaseRequests'] != null) {
      releaseRequests = <ReleaseRequests>[];
      json['releaseRequests'].forEach((v) {
        releaseRequests!.add(ReleaseRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headerInfo != null) {
      data['headerInfo'] = headerInfo!.toJson();
    }
    if (releaseRequests != null) {
      data['releaseRequests'] =
          releaseRequests!.map((v) => v.toJson()).toList();
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
  int? rShipmentId;
  int? otpLogId;
  String? rAttachedFile;
  String? rRejectionReason;
  String? oAwbUniqueNumber;
  bool? isCanceled;
  bool? isDelivered;
  int? shipmentTypeId;
  String? oModifiedDate;
  int? paymentStatusID;
  int? oSystemStatusID;
  int? rOrderID;
  String? paymentMethod;

  ReleaseRequests(
      {this.releaseId,
      this.orderId,
      this.cName,
      this.cAddress,
      this.cMobileNumber1,
      this.dNameAr,
      this.oCreatedDate,
      this.rShipmentId,
      this.otpLogId,
      this.rAttachedFile,
      this.rRejectionReason,
      this.oAwbUniqueNumber,
      this.isCanceled,
      this.isDelivered,
      this.shipmentTypeId,
      this.oModifiedDate,
      this.paymentStatusID,
      this.oSystemStatusID,
      this.rOrderID,
      this.paymentMethod});

  ReleaseRequests.fromJson(Map<String, dynamic> json) {
    releaseId = json['releaseId'];
    orderId = json['orderId'];
    cName = json['cName'];
    cAddress = json['cAddress'];
    cMobileNumber1 = json['cMobileNumber1'];
    dNameAr = json['dNameAr'];
    oCreatedDate = json['oCreatedDate'];
    rShipmentId = json['rShipmentId'];
    otpLogId = json['otpLogId'];
    rAttachedFile = json['rAttachedFile'];
    rRejectionReason = json['rRejectionReason'];
    oAwbUniqueNumber = json['oAwbUniqueNumber'];
    isCanceled = json['isCanceled'];
    isDelivered = json['isDelivered'];
    shipmentTypeId = json['shipmentTypeId'];
    oModifiedDate = json['oModifiedDate'];
    paymentStatusID = json['paymentStatusId'];
    oSystemStatusID = json['oSystemStatusId'];
    rOrderID = json['rOrderId'];
    paymentMethod = json['paymentMethod'];
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
    data['rShipmentId'] = rShipmentId;
    data['otpLogId'] = otpLogId;
    data['rAttachedFile'] = rAttachedFile;
    data['rRejectionReason'] = rRejectionReason;
    data['oAwbUniqueNumber'] = oAwbUniqueNumber;
    data['isCanceled'] = isCanceled;
    data['isDelivered'] = isDelivered;
    data['shipmentTypeId'] = shipmentTypeId;
    data['oModifiedDate'] = oModifiedDate;
    data['paymentStatusId'] = paymentStatusID;
    data['oSystemStatusId'] = oSystemStatusID;
    data['rOrderId'] = rOrderID;
    data['paymentMethod'] = paymentMethod;
    return data;
  }
}
