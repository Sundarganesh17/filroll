import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForwardWidget extends StatefulWidget {
  final snap;
  const ForwardWidget({super.key, this.snap});

  @override
  State<ForwardWidget> createState() => _ForwardWidgetState();
}

class _ForwardWidgetState extends State<ForwardWidget> {
  String dpUrl = '';
  String dpUrl1 = '';
  String userName = '';
  bool isLoading = true;
  bool isSelect = false;
  List<String> sendList = [];

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');

    setState(() {
      dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      dpUrl1 = dp;
      userName = (snap.data() as Map<String, dynamic>)['username'];
      isLoading = false;
    });
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgrssIndicatorPage()
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  color: Colors.black,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSelect = !isSelect;
                      });
                      Provider.of<Messages>(context, listen: false)
                          .forwardList(widget.snap['uid']);
                    },
                    child: Row(
                      children: [
                        dpUrl.contains('http')
                            ? CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 39, 38, 38),
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 39, 38, 38),
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  dpUrl1,
                                ),
                              ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.snap['lastMsg'],
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (isSelect)
                          Icon(
                            Icons.check,
                            size: 26,
                            color: Colors.blue,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
