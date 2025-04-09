import 'package:flutter/material.dart';

class StyleableTextFieldController extends TextEditingController {
  StyleableTextFieldController({
    required this.styles,
  }) : combinedPattern = styles.createCombinedPatternBasedOnStyleMap();

  final TextPartStyleDefinitions styles;
  final Pattern combinedPattern;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> textSpanChildren = <InlineSpan>[];

    text.splitMapJoin(
      combinedPattern,
      onMatch: (Match match) {
        final String? textPart = match.group(0);

        if (textPart == null) return '';

        final TextPartStyleDefinition? styleDefinition = styles.getStyleOfTextPart(
          textPart,
          text,
        );

        if (styleDefinition == null) return '';

        _addTextSpan(
          textSpanChildren,
          textPart,
          style?.merge(styleDefinition.style),
        );

        return '';
      },
      onNonMatch: (String text) {
        _addTextSpan(textSpanChildren, text, style);

        return '';
      },
    );

    return TextSpan(style: style, children: textSpanChildren);
  }

  void _addTextSpan(
    List<InlineSpan> textSpanChildren,
    String? textToBeStyled,
    TextStyle? style,
  ) {
    textSpanChildren.add(
      TextSpan(
        text: textToBeStyled,
        style: style,
      ),
    );
  }
}

class TextPartStyleDefinitions {
  TextPartStyleDefinitions({required this.definitionList, required this.adultWords})
      : adultWordStyle = const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        );

  final List<TextPartStyleDefinition> definitionList;
  final List<String> adultWords;
  final TextStyle adultWordStyle;

  RegExp createCombinedPatternBasedOnStyleMap() {
    final adultWordsPattern = adultWords.join('|');
    final combinedPatternString =
        [...definitionList.map<String>((definition) => definition.pattern), adultWordsPattern].join('|');
    return RegExp(combinedPatternString, multiLine: true, caseSensitive: false);
  }

  TextPartStyleDefinition? getStyleOfTextPart(
    String textPart,
    String text,
  ) {
    // Check if the textPart is an adult word
    if (adultWords.contains(removePunctuation(textPart.toLowerCase()))) {
      return TextPartStyleDefinition(pattern: textPart, style: adultWordStyle);
    }

    return List<TextPartStyleDefinition?>.from(definitionList).firstWhere(
      (TextPartStyleDefinition? styleDefinition) {
        if (styleDefinition == null) return false;

        bool hasMatch = false;

        RegExp(styleDefinition.pattern, caseSensitive: false).allMatches(text).forEach(
          (RegExpMatch currentMatch) {
            if (hasMatch) return;

            if (currentMatch.group(0) == textPart) {
              hasMatch = true;
            }
          },
        );

        return hasMatch;
      },
      orElse: () => null,
    );
  }
}

class TextPartStyleDefinition {
  TextPartStyleDefinition({
    required this.pattern,
    required this.style,
  });

  final String pattern;
  final TextStyle style;
}

String removePunctuation(String text) {
  // Define a regular expression pattern that matches punctuation characters
  final pattern = RegExp(r'[.,!?;:]');
  // Replace every instance of the pattern with an empty string
  return text.replaceAll(pattern, '');
}
