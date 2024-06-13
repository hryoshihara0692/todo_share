import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double maxFontSize;
  final double minFontSize;
  final int maxLines;

  ResponsiveText({
    required this.text,
    required this.maxFontSize,
    required this.minFontSize,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fontSize = maxFontSize;
        TextPainter painter = TextPainter(
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );

        // フォントサイズを調整
        while (fontSize > minFontSize) {
          painter.text = TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: GoogleFonts.notoSansJp(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ).fontFamily,
            ),
          );

          painter.layout(maxWidth: constraints.maxWidth);

          if (!painter.didExceedMaxLines) {
            break;
          }

          fontSize--;
        }

        // 2行表示かつ3点リーダー対応
        return Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: GoogleFonts.notoSansJp(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ).fontFamily,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 195, 195, 195),
                blurRadius: 0,
                offset: Offset(0, 2.5),
              ),
            ],
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
