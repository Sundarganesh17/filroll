import 'package:filroll_app/widgets/report_reason.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Report extends StatelessWidget {
  final uid;
  final postId;
  final commentId;
  const Report(
      {Key? key,
      required this.uid,
      required this.postId,
      required this.commentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.15,
      width: size.width * 0.8,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 51, 50, 50),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => ReportReasonForComments(
                      uid: uid, postId: postId, commentId: commentId),
                );
              },
              child: Text('Report',
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 14.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 15),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
              ),
              child: Text('Block',
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
