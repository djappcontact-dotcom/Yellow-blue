import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(

    imageUrl: 'assets/images/img_maskgroup.png',
    title: 'Need to borrow\nmoney urgently ',
    description: 'We can help!',
  ),
  Slide(
    imageUrl: 'assets/images/second_back_img.png',
    title: 'Get a loan\nanywhere with\nyour phone',
    description: 'Just submit a form, get a loan\noffer, accept it and get money',
  ),
  Slide(
    imageUrl: 'assets/images/three_image.png',
    title: 'Apply for a loan\nevery time you\nneed it',
    description: 'With our app, you can borrow\ncash easier than ever before',
  ),
  Slide(
    imageUrl: 'assets/images/three_image.png',
    title: '',
    description: '',
  ),
];