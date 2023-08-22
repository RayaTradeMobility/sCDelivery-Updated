// ignore_for_file: file_names

class TasksModel {
  ResponseHeader? responseHeader;
  List<TasksDriverVMs>? tasksDriverVMs;

  TasksModel({this.responseHeader, this.tasksDriverVMs});

  TasksModel.fromJson(Map<String, dynamic> json) {
    responseHeader = json['responseHeader'] != null
        ? ResponseHeader.fromJson(json['responseHeader'])
        : null;
    if (json['tasksDriverVMs'] != null) {
      tasksDriverVMs = <TasksDriverVMs>[];
      json['tasksDriverVMs'].forEach((v) {
        tasksDriverVMs!.add(TasksDriverVMs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responseHeader != null) {
      data['responseHeader'] = responseHeader!.toJson();
    }
    if (tasksDriverVMs != null) {
      data['tasksDriverVMs'] = tasksDriverVMs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseHeader {
  String? code;
  String? message;

  ResponseHeader({this.code, this.message});

  ResponseHeader.fromJson(Map<String, dynamic> json) {
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

class TasksDriverVMs {
  String? oOracleNumber;
  String? oAWBUnique;

  TasksDriverVMs({this.oOracleNumber, this.oAWBUnique});

  TasksDriverVMs.fromJson(Map<String, dynamic> json) {
    oOracleNumber = json['o_OracleNumber'];
    oAWBUnique = json['o_AWB_Unique'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['o_OracleNumber'] = oOracleNumber;
    data['o_AWB_Unique'] = oAWBUnique;
    return data;
  }
}
