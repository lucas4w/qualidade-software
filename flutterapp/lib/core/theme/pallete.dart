import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPallete {
  static const Color backgroundColor = Color.fromARGB(255, 243, 244, 246);
  static const Color primary = Color.fromARGB(255, 32, 168, 154);
  static const Color danger = Color.fromARGB(242, 190, 32, 32);
  // static const Color secondary = Color.fromRGBO(251, 109, 169, 1);
  static const Color greyText = Color.fromARGB(255, 209, 213, 220);
  static const Color cardColor = Color.fromARGB(160, 236, 236, 236);
  // static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  // static const Color whiteColor = Colors.white;
  // static const Color greyColor = Colors.grey;
  // static const Color errorColor =s Colors.redAccent;
  // static const Color transparentColor = Colors.transparent;
}

RichText getLogo() {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: 'RN ',
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 26),
        ),
        TextSpan(
          text: 'SemFila',
          style: GoogleFonts.poppins(color: AppPallete.primary, fontSize: 26),
        ),
      ],
    ),
  );
}
