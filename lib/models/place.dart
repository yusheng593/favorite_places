import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  // 如果沒有傳入 id，默認 = uuid.v4()
  Place({
    required this.title,
    required this.image,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
}
