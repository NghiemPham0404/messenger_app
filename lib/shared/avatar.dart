import 'package:flutter/material.dart';

CircleAvatar getAvatar(String? avatarLink, {String? seed}) {
  return CircleAvatar(
    backgroundImage: NetworkImage(
      avatarLink ??
          "https://api.dicebear.com/9.x/initials/png?seed=" +
              "$seed" +
              "&backgroundType=gradientLinear",
    ),
  );
}
