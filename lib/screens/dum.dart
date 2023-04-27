import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:image_picker/image_picker.dart';

class Dum extends StatefulWidget {
  const Dum({super.key});

  @override
  State<Dum> createState() => _DumState();
}

class _DumState extends State<Dum> {
  XFile? fileImage;
  String url = '';
  List dummy = ['1', '2'];

  Future<void> getTodo() async {
    try {
      const options = RestOptions(
          path:
              'https://wcjcnz1d6a.execute-api.ap-south-1.amazonaws.com/v1/filroll-storage-114584815-staging.s3.ap-south-1.amazonaws.com/public?key=test.jpeg');
      final restOperation = Amplify.API.get(restOptions: options);
      final response = await restOperation.response;
      print('GET call succeeded: ${response.body}');
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
  }

  Future<String> createAndUploadFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(fileImage!.path),
        key: 'test.jpeg',
        options: S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );
      return result.key;
    } on StorageException catch (e) {
      print('Error uploading file: $e');
      throw e;
    }
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _takePicture() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      fileImage = file;
    });
  }

  Widget buildPictureContainer() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 250,
          width: 180,
          // ignore: sort_child_properties_last
          child: fileImage == null
              ? const SizedBox()
              : Image.file(File(fileImage!.path)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 62, 62, 62)),
        ),
        Positioned(
            bottom: 15,
            right: 15,
            child: IconButton(
                onPressed: _takePicture, icon: const Icon(Icons.add_a_photo)))
      ],
    );
  }

  Widget buildUploadButton() {
    return ElevatedButton(
      onPressed: () async {
        var hashtag = await FirebaseFirestore.instance
            .collection('Hashtag')
            .orderBy('hashtag', descending: true)
            .get();
        print(hashtag.docs[0].data());
      },
      // onPressed: () async {
      //   var imageKey = await createAndUploadFile();
      //   await FirebaseFirestore.instance.collection('test').doc().set({
      //     'imgKey': imageKey,
      //     'dateTime': DateTime.now(),
      //   });
      // },
      // ignore: sort_child_properties_last
      child: const Text(
        'Upload Image',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }

  Widget buildFetchButton() {
    return TextButton(
        onPressed: () => fetch(),
        // onPressed: () async {
        //   var snap = await FirebaseFirestore.instance
        //       .collection('test')
        //       .orderBy('dateTime', descending: true)
        //       .get();
        //   var imgUrl = await getUrl(snap.docs[0].data()['imgKey']);
        //   setState(() {
        //     url = imgUrl;
        //   });
        // },
        // onPressed: () async {
        //   var snap = await FirebaseFirestore.instance
        //       .collection('test')
        //       .orderBy('dateTime', descending: true)
        //       .get();
        //   print(snap.docs[0].data()['imgUrl']);
        //   setState(() {
        //     url = snap.docs[0].data()['imgUrl'];
        //   });
        // },
        child: const Text(
          'Fetch From Storage',
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget buildFetchPic() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 250,
      width: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                url.isEmpty
                    ? 'https://amdmediccentar.rs/wp-content/plugins/uix-page-builder/includes/uixpbform/images/default-cover-4.jpg'
                    : url,
                scale: 1.0),
          ),
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 62, 62, 62)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    print(dummy.map((e) => e).toString());
    var snap = await FirebaseFirestore.instance
        .collection('test')
        .where('1', isEqualTo: dummy.map((e) => e).toString())
        .get();
    print(snap.docs[0].data());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Center(child: Text('AWS Testing App'))),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildPictureContainer(),
              const SizedBox(
                height: 10,
              ),
              buildUploadButton(),
              buildFetchButton(),
              buildFetchPic(),
            ],
          ),
        ),
      ),
    );
  }
}





// {
//     "openapi": "3.0.0",
//     "info": {
//        "version": "2016-10-21T17:26:28Z",
//        "title": "ApiName"
//     },
//     "paths": {
//        "/s3": {
//           "get": {
//              "parameters": [
//                 {
//                    "name": "key",
//                    "in": "query",
//                    "required": false,
//                    "schema": {
//                       "type": "string"
//                    }
//                 }
//              ],
//              "responses": {
//                 "200": {
//                    "description": "200 response",
//                    "content": {
//                       "application/json": {
//                          "schema": {
//                             "$ref": "#/components/schemas/Empty"
//                          }
//                       }
//                    }
//                 },
//                 "500": {
//                    "description": "500 response"
//                 }
//              },
//              "x-amazon-apigateway-integration": {
//                 "credentials": "arn:aws:iam::104003936294:role/apis3filesrole",
//                 "responses": {
//                    "default": {
//                       "statusCode": "500"
//                    },
//                    "2\\d{2}": {
//                       "statusCode": "200"
//                    }
//                 },
//                 "requestParameters": {
//                    "integration.request.path.key": "method.request.querystring.key"
//                 },
//                 "uri": "arn:aws:apigateway:us-west-2:s3:path/{key}",
//                 "passthroughBehavior": "when_no_match",
//                 "httpMethod": "GET",
//                 "type": "aws"
//              }
//           },
//           "put": {
//              "parameters": [
//                 {
//                    "name": "key",
//                    "in": "query",
//                    "required": false,
//                    "schema": {
//                       "type": "string"
//                    }
//                 }
//              ],
//              "responses": {
//                 "200": {
//                    "description": "200 response",
//                    "content": {
//                       "application/json": {
//                          "schema": {
//                             "$ref": "#/components/schemas/Empty"
//                          }
//                       },
//                       "application/octet-stream": {
//                          "schema": {
//                             "$ref": "#/components/schemas/Empty"
//                          }
//                       }
//                    }
//                 },
//                 "500": {
//                    "description": "500 response"
//                 }
//              },
//              "x-amazon-apigateway-integration": {
//                 "credentials": "arn:aws:iam::104003936294:role/apis3filesrole",
//                 "responses": {
//                    "default": {
//                       "statusCode": "500"
//                    },
//                    "2\\d{2}": {
//                       "statusCode": "200"
//                    }
//                 },
//                 "requestParameters": {
//                    "integration.request.path.key": "method.request.querystring.key"
//                 },
//                 "uri": "arn:aws:apigateway:us-west-2:s3:path/{key}",
//                 "passthroughBehavior": "when_no_match",
//                 "httpMethod": "PUT",
//                 "type": "aws",
//                 "contentHandling": "CONVERT_TO_BINARY"
//              }
//           }
//        }
//     },
//     "x-amazon-apigateway-binary-media-types": [
//        "application/octet-stream",
//        "image/jpeg"
//     ],
//     "components": {
//        "schemas": {
//           "Empty": {
//              "type": "object",
//              "title": "Empty Schema"
//           }
//        }
//     }
//  }
 
