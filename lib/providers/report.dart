import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ReportProvider with ChangeNotifier {
  Future sendEmail({
    String? name,
    String? username,
    String? reportedName,
    String? reportedUsername,
    String? reportBody,
  }) async {
    const serviceId = 'service_9hrmi0d';
    const templateId = 'template_dc34uw7';
    const userId = '7LDXVBthpp4qYQJ7q';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_name': name,
            'from_username': '@$username',
            'reported_name': reportedName,
            'reported_username': '@$reportedUsername',
            'message': reportBody,
          }
        }));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('reports')
        .doc()
        .set({
      'from_name': name,
      'from_username': '@$username',
      'reported_name': reportedName,
      'reported_username': '@$reportedUsername',
      'message': reportBody,
    });
  }
}
