class GetDriverModel {
  int? id;
  String? dName;
  String? dLicenseNumber;
  String? dNationalId;
  String? hrid;
  String? aspNetUSer;

  GetDriverModel(
      {this.id,
      this.dName,
      this.dLicenseNumber,
      this.dNationalId,
      this.hrid,
      this.aspNetUSer});

  GetDriverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dName = json['dName'];
    dLicenseNumber = json['dLicenseNumber'];
    dNationalId = json['dNationalId'];
    hrid = json['hrid'];
    aspNetUSer = json['aspNetUSer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dName'] = dName;
    data['dLicenseNumber'] = dLicenseNumber;
    data['dNationalId'] = dNationalId;
    data['hrid'] = hrid;
    data['aspNetUSer'] = aspNetUSer;
    return data;
  }
}
