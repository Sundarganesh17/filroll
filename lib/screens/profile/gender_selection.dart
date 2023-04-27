import 'package:filroll_app/providers/profile/extra_user_detail.dart';
import 'package:filroll_app/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GenderSelection extends StatefulWidget {
  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? _value;
  String? gender;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await Provider.of<ExtraUserDetail>(context, listen: false)
          .submitGender(gender);
      setState(() {
        isLoading = false;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EditProfile()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          iconSize: 20,
          onPressed: (() {
            Navigator.of(context).pop();
          }),
        ),
        title: Center(
          child: Text(
            'Gender',
            style: GoogleFonts.mPlusRounded1c(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(_value);
              }),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Done',
                      style: GoogleFonts.mPlusRounded1c(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Male',
                      style: GoogleFonts.mPlusRounded1c(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        value: 'Male',
                        groupValue: _value,
                        onChanged: (String? value) {
                          setState(() {
                            _value = value!;
                            gender = 'Male';
                            Provider.of<ExtraUserDetail>(context, listen: false)
                                .submitGender(gender);
                          });
                        }),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Female',
                      style: GoogleFonts.mPlusRounded1c(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        value: 'Female',
                        groupValue: _value,
                        onChanged: (String? value) {
                          setState(() {
                            _value = value!;
                            gender = 'Female';
                            Provider.of<ExtraUserDetail>(context, listen: false)
                                .submitGender(gender);
                          });
                        }),
                  ],
                ),
                TextFormField(
                  onSaved: ((value) {
                    gender = value;
                  }),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Custom',
                    hintStyle: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Prefer not to say',
                      style: GoogleFonts.mPlusRounded1c(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue),
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        value: 'Prefer not to say',
                        groupValue: _value,
                        onChanged: (String? value) {
                          setState(() {
                            _value = value!;
                            gender = 'Prefer not to say';
                            Provider.of<ExtraUserDetail>(context, listen: false)
                                .submitGender(gender);
                          });
                        }),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
