class PlaceDetailsV1 {
  String? id;
  DisplayNameV1? displayName;
  LocationV1? location;
  String? formattedAddress;
  List<AddressComponentV1>? addressComponents;

  PlaceDetailsV1({
    this.id,
    this.displayName,
    this.location,
    this.formattedAddress,
    this.addressComponents,
  });

  PlaceDetailsV1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName =
        json['displayName'] != null
            ? DisplayNameV1.fromJson(json['displayName'])
            : null;
    location =
        json['location'] != null ? LocationV1.fromJson(json['location']) : null;
    formattedAddress = json['formattedAddress'];
    if (json['addressComponents'] != null) {
      addressComponents = <AddressComponentV1>[];
      json['addressComponents'].forEach((v) {
        addressComponents!.add(AddressComponentV1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (displayName != null) {
      data['displayName'] = displayName!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['formattedAddress'] = formattedAddress;
    if (addressComponents != null) {
      data['addressComponents'] =
          addressComponents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DisplayNameV1 {
  String? text;
  String? languageCode;

  DisplayNameV1({this.text, this.languageCode});

  DisplayNameV1.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['languageCode'] = languageCode;
    return data;
  }
}

class LocationV1 {
  double? latitude;
  double? longitude;

  LocationV1({this.latitude, this.longitude});

  LocationV1.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class AddressComponentV1 {
  String? longText;
  String? shortText;
  List<String>? types;
  String? languageCode;

  AddressComponentV1({
    this.longText,
    this.shortText,
    this.types,
    this.languageCode,
  });

  AddressComponentV1.fromJson(Map<String, dynamic> json) {
    longText = json['longText'];
    shortText = json['shortText'];
    types = json['types']?.cast<String>();
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longText'] = longText;
    data['shortText'] = shortText;
    data['types'] = types;
    data['languageCode'] = languageCode;
    return data;
  }
}
