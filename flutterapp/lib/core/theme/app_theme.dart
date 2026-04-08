import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final theme = ThemeData(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    textTheme: GoogleFonts.montserratTextTheme(),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppPallete.primary,
      selectionColor: Colors.grey.withValues(alpha: 0.4),
      selectionHandleColor: Colors.grey,
    ),
  );
}

InputDecoration inputTheme(String hint) => InputDecoration(
  constraints: BoxConstraints(maxHeight: 45), // Mantém a altura máxima fixa
  hint: Text(hint, style: TextStyle(color: Color.fromARGB(255, 123, 123, 123))),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppPallete.greyText, width: 1.3),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppPallete.greyText, width: 1.3),
  ),
  errorBorder: OutlineInputBorder(
    // Adicione isso para definir a borda de erro
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: AppPallete.greyText,
      width: 1.3,
    ), // Cor padrão, mude se quiser
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppPallete.greyText, width: 1.3),
  ),
  errorStyle: TextStyle(
    height:
        double.minPositive, // Altura mínima positiva: esconde o espaço do erro
    fontSize: 0.01, // Tamanho mínimo para não afetar a altura
  ),
);
