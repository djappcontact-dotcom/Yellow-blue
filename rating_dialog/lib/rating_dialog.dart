library rating_dialog;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialog extends StatefulWidget {
  /// The dialog's title
  final Text title;

  /// The dialog's message/description text
  final Text? message;

  /// The dialog's message/description text
  final Text? subtitle;

  /// The top image used for the dialog to be displayed
  final Widget? image;

  /// The rating bar (star icon & glow) color
  final Color starColor;

  final Color backgroundColor;

  /// The size of the star
  final double starSize;

  /// Disables the cancel button and forces the user to leave a rating
  final bool force;

  /// Show or hide the close button
  final bool showCloseButton;

  final bool ignore;
  /// The initial rating of the rating bar
  final double initialRating;

  /// Display comment input area
  final bool enableComment;

  final bool secondButton;

  final String secondButtonText;

  final TextStyle secondButtonTextStyle;

  /// The comment's TextField hint text
  final String commentHint;

  /// The submit button's label/text
  final String submitButtonText;

  /// The submit button's label/text
  final TextStyle submitButtonTextStyle;

  /// Returns a RatingDialogResponse with user's rating and comment values
  final Function(RatingDialogResponse) onSubmitted;

  /// called when user cancels/closes the dialog
  final Function? onCancelled;

  const RatingDialog({
    required this.title,
    this.message,
    this.image,
    this.subtitle,
    required this.submitButtonText,
    this.submitButtonTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),

    this.secondButton = false,
    this.secondButtonText = 'Remind me later',

    this.secondButtonTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    required this.onSubmitted,
    this.starColor = Colors.amber,
    this.starSize = 40.0,
    this.onCancelled,
    this.showCloseButton = true,
    this.force = false,
    this.ignore = false,
    this.initialRating = 0,
    this.enableComment = true,
    this.commentHint = 'Write your comment, question or suggestion',
    this.backgroundColor = const Color(0xFF808080),
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final _commentController = TextEditingController();
  RatingDialogResponse? _response;

  @override
  void initState() {
    super.initState();
    _response = RatingDialogResponse(rating: widget.initialRating);
  }

  @override
  Widget build(BuildContext context) {
    final _content = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.only( topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
          child: Container (
            margin: const EdgeInsets.only(bottom: 0.0),
            width: MediaQuery.of(context).size.width,
            color: widget.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  widget.image != null
                      ? Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 25),
                    child: widget.image,
                  )
                      : Container(),
                  widget.title,
                  const SizedBox(height: 10),
                  Center(
                    child:widget.starSize != 0 ? Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: RatingBar.builder(
                        initialRating: widget.initialRating,
                        glowColor: widget.starColor,
                        unratedColor: const Color(0xFF808080),
                        minRating: 0,
                        itemSize: widget.starSize,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ignoreGestures: widget.ignore,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _response!.rating = rating;
                          });
                        },
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: widget.starColor,
                        ),
                      ),
                    ) : Container(),
                  ),
                  widget.subtitle ?? Container(),
                  const SizedBox(height: 10),
                  widget.message ?? Container(),
                  const SizedBox(height: 5),
                  widget.enableComment
                      ? TextField(
                    controller: _commentController,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(6.0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white12, width: 0.0),
                      ),
                      enabledBorder:  const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 0.0),
                      ),
                      hintText: widget.commentHint,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.white12,
                      ),
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _response!.rating == 0
                        ? null
                        : () {
                      if (!widget.force) Navigator.pop(context);
                      _response!.comment = _commentController.text;
                      widget.onSubmitted.call(_response!);
                    },
                    child: Container(
//width: MediaQuery.of(context).size.width*0.92,
                        decoration: boxDecoration(bgColor: const Color.fromARGB(255, 32, 78, 246), radius: 35),
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                widget.submitButtonText,
                                style: widget.submitButtonTextStyle,
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                  widget.secondButton ?
                  GestureDetector(
                    onTap: () {
                      if (!widget.force) Navigator.pop(context);
                      _response!.rating = 60.0;
                      widget.onSubmitted.call(_response!);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width*0.92,
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        decoration: boxDecoration(bgColor: const Color(0xff2050F6), radius: 16),
                        padding: const EdgeInsets.fromLTRB(2, 7, 2, 7),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                widget.secondButtonText,
                                style: widget.secondButtonTextStyle,
                              ),
                            ),
                          ],
                        )),
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
        if (!widget.force &&
            widget.onCancelled != null &&
            widget.showCloseButton) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              if(mounted) {
                Navigator.pop(context);
              }
              widget.onCancelled!.call();
            },
          )
        ]
      ],
    );

/*
    return AlertDialog(
		contentPadding: EdgeInsets.only(bottom: 0.0),
      backgroundColor: Colors.transparent,      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
*/
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/home");
      },
      child:Material(
        color: Colors.transparent, // <-- Add this, if needed
        child:Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, //This way is not going to afect  the inside widget
            child: SingleChildScrollView(
              child:Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child:_content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingDialogResponse {
  /// The user's comment response
  String comment;

  /// The user's rating response
  double rating;

  RatingDialogResponse({this.rating = 0.0, this.comment = ''});
}


BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color? bgColor, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: const [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}