// To parse this JSON data, do
//
//     final fileModel = fileModelFromJson(jsonString);

import 'dart:convert';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
    FileModel({
        required this.imagefile,
        required this.folderName,
    });

    List<String> imagefile;
    String folderName;

    factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        imagefile: List<String>.from(json["files"].map((x) => x)),
        folderName: json["folderName"],
    );

    Map<String, dynamic> toJson() => {
        "files": List<dynamic>.from(imagefile.map((x) => x)),
        "folderName": folderName,
    };
}
