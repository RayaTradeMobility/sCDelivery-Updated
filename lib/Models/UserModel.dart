// ignore_for_file: file_names

class UserModel {
  HeaderInfo? headerInfo;
  bool? isAuthorized;
  List<String>? permissions;
  String? name;
  String? dLicenseNumber;
  String? dNationalID;
  String? dUserID;
  String? dHRID;
  String? mobileNumber;
  int? driverID;

  UserModel(
      {required this.headerInfo,
      required this.isAuthorized,
      this.permissions,
      required this.name,
      required this.dLicenseNumber,
      required this.dNationalID,
      required this.dUserID,
      required this.dHRID,
      required this.mobileNumber,
      required this.driverID});

  UserModel.fromJson(Map<String, dynamic> json) {
    headerInfo = (json['headerInfo'] != null
        ? HeaderInfo.fromJson(json['headerInfo'])
        : null)!;
    isAuthorized = json['isAuthorized'];
    permissions = json['permissions'];
    name = json['name'];
    dLicenseNumber = json['d_LicenseNumber'];
    dNationalID = json['d_NationalID'];
    dUserID = json['d_UserID'];
    dHRID = json['d_HRID'];
    mobileNumber = json['mobileNumber'];
    driverID = json['driverID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headerInfo != null) {
      data['headerInfo'] = headerInfo!.toJson();
    }
    data['isAuthorized'] = isAuthorized;
    data['permissions'] = permissions;
    data['name'] = name;
    data['d_LicenseNumber'] = dLicenseNumber;
    data['d_NationalID'] = dNationalID;
    data['d_UserID'] = dUserID;
    data['d_HRID'] = dHRID;
    data['mobileNumber'] = mobileNumber;
    data['driverID'] = driverID;
    return data;
  }
}

class HeaderInfo {
  String? code;
  String? message;

  HeaderInfo({required this.code, required this.message});

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
