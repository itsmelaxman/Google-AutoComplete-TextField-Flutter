class AutocompleteResponseV1 {
  List<SuggestionV1>? suggestions;

  AutocompleteResponseV1({this.suggestions});

  AutocompleteResponseV1.fromJson(Map<String, dynamic> json) {
    if (json['suggestions'] != null) {
      suggestions = <SuggestionV1>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(SuggestionV1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (suggestions != null) {
      data['suggestions'] = suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestionV1 {
  PlacePredictionV1? placePrediction;

  SuggestionV1({this.placePrediction});

  SuggestionV1.fromJson(Map<String, dynamic> json) {
    placePrediction =
        json['placePrediction'] != null
            ? PlacePredictionV1.fromJson(json['placePrediction'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (placePrediction != null) {
      data['placePrediction'] = placePrediction!.toJson();
    }
    return data;
  }
}

class PlacePredictionV1 {
  String? place;
  String? placeId;
  TextV1? text;
  StructuredFormatV1? structuredFormat;
  List<String>? types;

  PlacePredictionV1({
    this.place,
    this.placeId,
    this.text,
    this.structuredFormat,
    this.types,
  });

  PlacePredictionV1.fromJson(Map<String, dynamic> json) {
    place = json['place'];
    placeId = json['placeId'];
    text = json['text'] != null ? TextV1.fromJson(json['text']) : null;
    structuredFormat =
        json['structuredFormat'] != null
            ? StructuredFormatV1.fromJson(json['structuredFormat'])
            : null;
    types = json['types']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place'] = place;
    data['placeId'] = placeId;
    if (text != null) {
      data['text'] = text!.toJson();
    }
    if (structuredFormat != null) {
      data['structuredFormat'] = structuredFormat!.toJson();
    }
    data['types'] = types;
    return data;
  }
}

class TextV1 {
  String? text;
  List<MatchesV1>? matches;

  TextV1({this.text, this.matches});

  TextV1.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['matches'] != null) {
      matches = <MatchesV1>[];
      json['matches'].forEach((v) {
        matches!.add(MatchesV1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchesV1 {
  int? endOffset;

  MatchesV1({this.endOffset});

  MatchesV1.fromJson(Map<String, dynamic> json) {
    endOffset = json['endOffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endOffset'] = endOffset;
    return data;
  }
}

class StructuredFormatV1 {
  TextV1? mainText;
  TextV1? secondaryText;

  StructuredFormatV1({this.mainText, this.secondaryText});

  StructuredFormatV1.fromJson(Map<String, dynamic> json) {
    mainText =
        json['mainText'] != null ? TextV1.fromJson(json['mainText']) : null;
    secondaryText =
        json['secondaryText'] != null
            ? TextV1.fromJson(json['secondaryText'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainText != null) {
      data['mainText'] = mainText!.toJson();
    }
    if (secondaryText != null) {
      data['secondaryText'] = secondaryText!.toJson();
    }
    return data;
  }
}
