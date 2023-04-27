import 'package:audioplayers/audioplayers.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/screens/chat/widgets/message_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatefulWidget {
  var isSwipe;
  final snap;
  final bool isMe;
  ChatBubble({super.key, required this.snap, required this.isMe, this.isSwipe});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  AudioPlayer? _audioPlayer = AudioPlayer();
  bool isPlay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLongPress = false;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _audioPlayer!.onPlayerStateChanged.listen((state) {
      if (this.mounted) {
        setState(() {
          isPlay = state == PlayerState.playing;
        });
      }
    });
    getDuration();
    _audioPlayer!.onDurationChanged.listen((newDuration) {
      if (this.mounted)
        setState(() {
          duration = newDuration;
        });
    });

    _audioPlayer!.onPositionChanged.listen((newPosition) {
      if (this.mounted)
        setState(() {
          position = newPosition;
        });
    });
  }

  updateSeenStatus() async {
    await Provider.of<Messages>(context, listen: false).IsSeen(
        widget.snap['receiverUid'],
        widget.snap['senderUid'],
        widget.snap['msgId']);
  }

  getDuration() async {
    duration = (await _audioPlayer!.getDuration())!;
  }

  _audioDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [minutes, seconds].join(':');
  }

  @override
  void dispose() {
    _audioPlayer!.dispose();
    super.dispose();
  }

  Widget buildTextContainer() {
    return Stack(
      children: [
        widget.snap['reply'].isEmpty
            ? Container(
                margin: widget.isMe
                    ? const EdgeInsets.fromLTRB(4, 4, 8, 4)
                    : const EdgeInsets.fromLTRB(8, 4, 4, 4),
                padding: EdgeInsets.fromLTRB(16, 10, widget.isMe ? 26 : 16, 10),
                decoration: BoxDecoration(
                    color: widget.isMe ? Color(0XFF303030) : Color(0XFF007AFE),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: widget.isMe
                            ? Radius.circular(0)
                            : Radius.circular(20),
                        topLeft: widget.isMe
                            ? Radius.circular(20)
                            : Radius.circular(0))),
                child: InkWell(
                  child: Text(
                    widget.snap['body'],
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              )
            : Container(
                margin: widget.isMe
                    ? const EdgeInsets.fromLTRB(4, 4, 8, 4)
                    : const EdgeInsets.fromLTRB(8, 4, 4, 4),
                padding: EdgeInsets.fromLTRB(12, 10, widget.isMe ? 26 : 16, 10),
                decoration: BoxDecoration(
                    color: widget.isMe ? Color(0XFF303030) : Color(0XFF007AFE),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: widget.isMe
                            ? Radius.circular(0)
                            : Radius.circular(20),
                        topLeft: widget.isMe
                            ? Radius.circular(20)
                            : Radius.circular(0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 10, 3),
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.isMe
                              ? Colors.black
                              : Color.fromARGB(255, 16, 66, 107)),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 40,
                            decoration: BoxDecoration(
                                color: widget.isMe
                                    ? Color(0XFF007AFE)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.snap['reply'].contains('Images')
                                ? '🖼️ Photo'
                                : widget.snap['reply'].contains('Audio')
                                    ? '🎤 Audio'
                                    : widget.snap['reply'],
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: InkWell(
                        onLongPress: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => MessagePopup(
                                    snap: widget.snap,
                                    isMe: widget.isMe,
                                  ));
                        },
                        child: Text(
                          widget.snap['body'],
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        if (widget.isMe)
          Positioned(
            bottom: 6,
            right: 15,
            child: Icon(
              Icons.done_all,
              color: widget.snap['isSeen'] ? Colors.blue : Colors.grey,
              size: 14,
            ),
          )
      ],
    );
  }

  Widget buildAudioContainer() {
    return InkWell(
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => MessagePopup(
                  snap: widget.snap,
                  isMe: widget.isMe,
                ));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.fromLTRB(16, 10, 18, 10),
          decoration: BoxDecoration(
              color: widget.isMe ? Color(0XFF303030) : Color(0XFF007AFE),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight:
                      widget.isMe ? Radius.circular(0) : Radius.circular(20),
                  topLeft:
                      widget.isMe ? Radius.circular(20) : Radius.circular(0))),
          child: Container(
            height: 40,
            width: 250,
            child: FittedBox(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        if (!isPlay) {
                          await _audioPlayer!
                              .play(UrlSource(widget.snap['body']));
                          setState(() {
                            isPlay = true;
                          });
                        } else {
                          await _audioPlayer!.pause();
                          setState(() {
                            isPlay = false;
                          });
                        }
                      },
                      icon: isPlay
                          ? widget.isMe
                              ? SvgPicture.asset(
                                  'images/icons/Audio Pause.svg',
                                  height: 30,
                                  width: 30,
                                )
                              : SvgPicture.asset(
                                  'images/icons/Audio Pause1.svg',
                                  height: 30,
                                  width: 30,
                                )
                          : widget.isMe
                              ? SvgPicture.asset(
                                  'images/icons/Audio Play.svg',
                                  height: 30,
                                  width: 30,
                                )
                              : SvgPicture.asset(
                                  'images/icons/Audio Play1.svg',
                                  height: 30,
                                  width: 30,
                                )),
                  isPlay
                      ? Container(
                          width: 200,
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Wave1(isMe: widget.isMe),
                        )
                      : Container(
                          width: 200,
                          child: Slider(
                            thumbColor:
                                widget.isMe ? Colors.blue : Colors.white,
                            activeColor:
                                widget.isMe ? Color(0XFF2F69FE) : Colors.white,
                            inactiveColor: widget.isMe
                                ? Colors.blue.withOpacity(0.7)
                                : Colors.white.withOpacity(0.7),
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await _audioPlayer!.seek(position);

                              await _audioPlayer!.resume();
                            },
                          ),
                        ),
                  Text(
                    _audioDuration(duration - position),
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => MessagePopup(
                    snap: widget.snap,
                    isMe: widget.isMe,
                  ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topRight: widget.isMe ? Radius.circular(0) : Radius.circular(12),
              topLeft: widget.isMe ? Radius.circular(12) : Radius.circular(0)),
          child: Image.network(
            widget.snap['body'],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap['isSeen'] == false) if (userUid ==
        widget.snap['receiverUid']) {
      updateSeenStatus();
    }
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (widget.isMe &&
            !widget.snap['body'].contains('Audio') &&
            !widget.snap['body'].contains('Images'))
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: Text(
              DateFormat('hh:mm a')
                  .format(widget.snap['dateTime'].toDate())
                  .toString()
                  .toLowerCase(),
              style: TextStyle(
                  color: Colors.grey, fontSize: 7, fontWeight: FontWeight.w600),
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Stack(
            children: [
              widget.snap['body'].contains('Audio')
                  ? buildAudioContainer()
                  : widget.snap['body'].contains('Images')
                      ? buildImageContainer()
                      : buildTextContainer(),
              widget.snap['body'].contains('Images')
                  ? Positioned(
                      bottom: 7,
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                DateFormat('hh:mm a')
                                    .format(widget.snap['dateTime'].toDate())
                                    .toString()
                                    .toLowerCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(width: 5),
                              if (widget.isMe)
                                Icon(
                                  Icons.done_all,
                                  color: widget.snap['isSeen']
                                      ? Colors.blue
                                      : Colors.white,
                                  size: 15,
                                ),
                              SizedBox(width: 5)
                            ],
                          ),
                        ),
                      ),
                    )
                  : widget.snap['body'].contains('Audio')
                      ? Positioned(
                          bottom: 7,
                          right: 17,
                          child: Row(
                            children: [
                              Text(
                                DateFormat('hh:mm a')
                                    .format(widget.snap['dateTime'].toDate())
                                    .toString()
                                    .toLowerCase(),
                                style: TextStyle(
                                    color: widget.isMe
                                        ? Colors.grey
                                        : Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5),
                              if (widget.isMe)
                                Icon(
                                  Icons.done_all,
                                  color: widget.snap['isSeen']
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 14,
                                ),
                              if (widget.isMe) SizedBox(width: 5)
                            ],
                          ),
                        )
                      : SizedBox(),
              // if (isLongPress)
              //   Align(
              //     alignment: Alignment.topLeft,
              //     child: Container(
              //       height: 150,
              //       width: 50,
              //       color: Colors.red,
              //     ),
              //   ),
            ],
          ),
        ),
        if (!widget.isMe &&
            !widget.snap['body'].contains('Audio') &&
            !widget.snap['body'].contains('Images'))
          Padding(
            padding: const EdgeInsets.only(top: 23),
            child: Text(
              DateFormat('hh:mm a')
                  .format(widget.snap['dateTime'].toDate())
                  .toString()
                  .toLowerCase(),
              style: TextStyle(
                  color: Colors.grey, fontSize: 7, fontWeight: FontWeight.w600),
            ),
          )
        //
      ],
    );
  }
}

class Wave1 extends StatelessWidget {
  final bool isMe;
  List<Color> colors = [
    Color(0XFF1F57E7),
    Color(0XFF1F57E7),
    Color(0XFF1F57E7),
    Color(0XFF1F57E7)
  ];
  List<int> duration = [400, 800, 600, 500, 900, 200, 700, 600, 400, 500];
  List<Color> colors1 = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];

  Wave1({super.key, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          25,
          (index) => WaveAnim1(
              duration: duration[index % 5],
              color: isMe ? colors[index % 4] : colors1[index % 4])),
    );
  }
}

class WaveAnim1 extends StatefulWidget {
  final int duration;
  final Color color;
  const WaveAnim1({super.key, required this.duration, required this.color});

  @override
  State<WaveAnim1> createState() => _WaveAnim1State();
}

class _WaveAnim1State extends State<WaveAnim1>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    final curvedAnimation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeInCirc);
    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController!.repeat(reverse: true, max: 1);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: 2.54,
      height: animation!.value,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color,
      ),
    );
  }
}
