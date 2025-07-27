library google_places_flutter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/place_details_v1.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'DioErrorHandler.dart';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  final InputDecoration inputDecoration;
  final ItemClick? itemClick;
  final GetPlaceDetailswWithLatLng? getPlaceDetailWithLatLng;
  final bool isLatLngRequired;

  final TextStyle textStyle;
  final String googleAPIKey;
  final int debounceTime;
  final List<String>? countries;
  final TextEditingController textEditingController;
  final ListItemBuilder? itemBuilder;
  final Widget? seperatedBuilder;
  final VoidCallback? clearData;
  final BoxDecoration? boxDecoration;
  final bool isCrossBtnShown;
  final bool showError;
  final double? containerHorizontalPadding;
  final double? containerVerticalPadding;
  final FocusNode? focusNode;
  final PlaceType? placeType;
  final String? language;
  final TextInputAction? textInputAction;
  final VoidCallback? formSubmitCallback;
  final String? Function(String?, BuildContext)? validator;
  final double? latitude;
  final double? longitude;

  /// This is expressed in **meters**
  final int? radius;

  /// Use the new Google Places API (v1) - defaults to true for new API
  final bool useNewAPI;

  const GooglePlaceAutoCompleteTextField({
    Key? key,
    required this.textEditingController,
    required this.googleAPIKey,
    this.debounceTime = 600,
    this.inputDecoration = const InputDecoration(),
    this.itemClick,
    this.isLatLngRequired = true,
    this.textStyle = const TextStyle(),
    this.countries,
    this.getPlaceDetailWithLatLng,
    this.itemBuilder,
    this.boxDecoration,
    this.isCrossBtnShown = true,
    this.seperatedBuilder,
    this.showError = true,
    this.containerHorizontalPadding,
    this.containerVerticalPadding,
    this.focusNode,
    this.placeType,
    this.language = 'en',
    this.validator,
    this.latitude,
    this.longitude,
    this.radius,
    this.formSubmitCallback,
    this.textInputAction,
    this.clearData,
    this.useNewAPI = true,
  }) : super(key: key);

  @override
  _GooglePlaceAutoCompleteTextFieldState createState() =>
      _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState
    extends State<GooglePlaceAutoCompleteTextField> {
  final subject = new PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> alPredictions = [];

  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  bool isCrossBtn = true;
  late var _dio;

  CancelToken? _cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.containerHorizontalPadding ?? 0,
          vertical: widget.containerVerticalPadding ?? 0,
        ),
        alignment: Alignment.centerLeft,
        decoration:
            widget.boxDecoration ??
            BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey, width: 0.6),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                decoration: widget.inputDecoration,
                style: widget.textStyle,
                controller: widget.textEditingController,
                focusNode: widget.focusNode ?? FocusNode(),
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                onFieldSubmitted: (value) {
                  if (widget.formSubmitCallback != null) {
                    widget.formSubmitCallback!();
                  }
                },
                validator: (inputString) {
                  return widget.validator?.call(inputString, context);
                },
                onChanged: (string) {
                  subject.add(string);
                  if (widget.isCrossBtnShown) {
                    isCrossBtn = string.isNotEmpty ? true : false;
                    setState(() {});
                  }
                },
              ),
            ),
            (!widget.isCrossBtnShown)
                ? SizedBox()
                : isCrossBtn && _showCrossIconWidget()
                ? IconButton(
                  onPressed: () => clearData(),
                  icon: Icon(Icons.close),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  getLocation(String text) async {
    if (widget.useNewAPI) {
      await _getLocationNewAPI(text);
    } else {
      await _getLocationLegacyAPI(text);
    }
  }

  _getLocationNewAPI(String text) async {
    const String apiURL =
        "https://places.googleapis.com/v1/places:autocomplete";

    // Build request body with proper parameters
    Map<String, dynamic> requestBody = {"input": text};

    // Add language code if specified
    if (widget.language != null && widget.language!.isNotEmpty) {
      requestBody["languageCode"] = widget.language;
    }

    // Add region code if countries are specified
    if (widget.countries != null && widget.countries!.isNotEmpty) {
      requestBody["regionCode"] = widget.countries!.first.toUpperCase();
    }

    // Add location bias if provided
    if (widget.latitude != null && widget.longitude != null) {
      if (widget.radius != null) {
        requestBody["locationBias"] = {
          "circle": {
            "center": {
              "latitude": widget.latitude,
              "longitude": widget.longitude,
            },
            "radius": widget.radius!.toDouble(),
          },
        };
      } else {
        // Use a small rectangular area around the point
        requestBody["locationBias"] = {
          "rectangle": {
            "low": {
              "latitude": widget.latitude! - 0.01,
              "longitude": widget.longitude! - 0.01,
            },
            "high": {
              "latitude": widget.latitude! + 0.01,
              "longitude": widget.longitude! + 0.01,
            },
          },
        };
      }
    }

    // Add place types if specified
    if (widget.placeType != null) {
      String apiType = widget.placeType!.apiString;
      // Map some common legacy types to new API types or skip for broader results
      if (apiType != "establishment" &&
          apiType != "geocode" &&
          apiType != "address") {
        requestBody["includedPrimaryTypes"] = [apiType];
      }
    }

    // Cancel previous request and create new token
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken?.cancel();
    }
    _cancelToken = CancelToken();

    try {
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': widget.googleAPIKey,
        },
      );

      Response response = await _dio.post(
        apiURL,
        data: requestBody,
        options: options,
        cancelToken: _cancelToken,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (text.length == 0) {
        alPredictions.clear();
        this._overlayEntry?.remove();
        return;
      }

      isSearched = false;
      alPredictions.clear();

      // Handle the new API response format
      Map<String, dynamic> responseData = response.data;

      if (responseData.containsKey('error')) {
        throw Exception(responseData['error']['message'] ?? 'API Error');
      }

      // Parse the response directly instead of using the model class for now
      if (responseData.containsKey('suggestions')) {
        List<dynamic> suggestions = responseData['suggestions'];

        for (var suggestion in suggestions) {
          if (suggestion.containsKey('placePrediction')) {
            var placePrediction = suggestion['placePrediction'];

            String? description;
            String? mainText;
            String? secondaryText;
            String? placeId = placePrediction['placeId'];

            // Get the text
            if (placePrediction.containsKey('text') &&
                placePrediction['text'].containsKey('text')) {
              description = placePrediction['text']['text'];
            }

            // Get structured formatting
            if (placePrediction.containsKey('structuredFormat')) {
              var structuredFormat = placePrediction['structuredFormat'];
              if (structuredFormat.containsKey('mainText') &&
                  structuredFormat['mainText'].containsKey('text')) {
                mainText = structuredFormat['mainText']['text'];
              }
              if (structuredFormat.containsKey('secondaryText') &&
                  structuredFormat['secondaryText'].containsKey('text')) {
                secondaryText = structuredFormat['secondaryText']['text'];
              }
            }

            var prediction = Prediction(
              description: description,
              placeId: placeId,
              structuredFormatting:
                  (mainText != null || secondaryText != null)
                      ? StructuredFormatting(
                        mainText: mainText,
                        secondaryText: secondaryText,
                      )
                      : null,
              types: placePrediction['types']?.cast<String>(),
            );
            alPredictions.add(prediction);
          }
        }
      }

      this._overlayEntry = null;
      this._overlayEntry = this._createOverlayEntry();
      if (this._overlayEntry != null) {
        Overlay.of(context).insert(this._overlayEntry!);
      }
    } catch (e) {
      // Don't show error for cancelled requests
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return; // Silently ignore cancelled requests
      }

      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  _getLocationLegacyAPI(String text) async {
    String apiURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}&language=${widget.language}";

    if (widget.countries != null) {
      for (int i = 0; i < widget.countries!.length; i++) {
        String country = widget.countries![i];
        if (i == 0) {
          apiURL = apiURL + "&components=country:$country";
        } else {
          apiURL = apiURL + "|" + "country:" + country;
        }
      }
    }
    if (widget.placeType != null) {
      apiURL += "&types=${widget.placeType?.apiString}";
    }

    if (widget.latitude != null &&
        widget.longitude != null &&
        widget.radius != null) {
      apiURL =
          apiURL +
          "&location=${widget.latitude},${widget.longitude}&radius=${widget.radius}";
    }

    // Cancel previous request and create new token
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken?.cancel();
    }
    _cancelToken = CancelToken();

    try {
      String proxyURL = "https://cors-anywhere.herokuapp.com/";
      String url = kIsWeb ? proxyURL + apiURL : apiURL;

      Response response = await _dio.get(url);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Map map = response.data;
      if (map.containsKey("error_message")) {
        throw response.data;
      }

      PlacesAutocompleteResponse subscriptionResponse =
          PlacesAutocompleteResponse.fromJson(response.data);

      if (text.length == 0) {
        alPredictions.clear();
        this._overlayEntry?.remove();
        return;
      }

      isSearched = false;
      alPredictions.clear();
      if (subscriptionResponse.predictions!.length > 0 &&
          (widget.textEditingController.text.toString().trim()).isNotEmpty) {
        alPredictions.addAll(subscriptionResponse.predictions!);
      }

      this._overlayEntry = null;
      this._overlayEntry = this._createOverlayEntry();
      if (this._overlayEntry != null) {
        Overlay.of(context).insert(this._overlayEntry!);
      }
    } catch (e) {
      // Don't show error for cancelled requests
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return; // Silently ignore cancelled requests
      }
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);
  }

  textChanged(String text) async {
    if (text.isNotEmpty) {
      getLocation(text);
    } else {
      alPredictions.clear();
      if (this._overlayEntry != null) {
        try {
          this._overlayEntry?.remove();
        } catch (e) {}
      }
    }
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
        builder:
            (context) => Positioned(
              left: offset.dx,
              top: size.height + offset.dy,
              width: size.width,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                link: this._layerLink,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: alPredictions.length,
                    separatorBuilder:
                        (context, pos) => widget.seperatedBuilder ?? SizedBox(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          var selectedData = alPredictions[index];
                          if (index < alPredictions.length) {
                            widget.itemClick?.call(selectedData);

                            if (widget.isLatLngRequired) {
                              await getPlaceDetailsFromPlaceId(selectedData);
                            }
                            removeOverlay();
                          }
                        },
                        child:
                            widget.itemBuilder != null
                                ? widget.itemBuilder!(
                                  context,
                                  index,
                                  alPredictions[index],
                                )
                                : Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    alPredictions[index].description ?? "",
                                  ),
                                ),
                      );
                    },
                  ),
                ),
              ),
            ),
      );
    }
    return null;
  }

  removeOverlay() {
    alPredictions.clear();
    if (this._overlayEntry != null) {
      try {
        this._overlayEntry?.remove();
      } catch (e) {}
    }
  }

  Future<void> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    if (widget.useNewAPI) {
      await _getPlaceDetailsNewAPI(prediction);
    } else {
      await _getPlaceDetailsLegacyAPI(prediction);
    }
  }

  Future<void> _getPlaceDetailsNewAPI(Prediction prediction) async {
    if (prediction.placeId == null) return;

    var url = "https://places.googleapis.com/v1/places/${prediction.placeId}";

    try {
      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': widget.googleAPIKey,
          'X-Goog-FieldMask': 'id,displayName,location,formattedAddress',
        },
      );

      Response response = await _dio.get(url, options: options);

      PlaceDetailsV1 placeDetails = PlaceDetailsV1.fromJson(response.data);

      if (placeDetails.location != null) {
        prediction.lat = placeDetails.location!.latitude.toString();
        prediction.lng = placeDetails.location!.longitude.toString();
      }

      widget.getPlaceDetailWithLatLng?.call(prediction);
    } catch (e) {
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  Future<void> _getPlaceDetailsLegacyAPI(Prediction prediction) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${widget.googleAPIKey}";
    try {
      Response response = await _dio.get(url);

      PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

      if (placeDetails.result?.geometry?.location != null) {
        prediction.lat =
            placeDetails.result!.geometry!.location!.lat.toString();
        prediction.lng =
            placeDetails.result!.geometry!.location!.lng.toString();
      }

      widget.getPlaceDetailWithLatLng?.call(prediction);
    } catch (e) {
      var errorHandler = ErrorHandler.internal().handleError(e);
      _showSnackBar("${errorHandler.message}");
    }
  }

  void clearData() {
    widget.textEditingController.clear();
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken?.cancel();
    }

    setState(() {
      alPredictions.clear();
      isCrossBtn = false;
    });

    if (this._overlayEntry != null) {
      try {
        this._overlayEntry?.remove();
      } catch (e) {}
    }
  }

  _showCrossIconWidget() {
    return (widget.textEditingController.text.isNotEmpty);
  }

  _showSnackBar(String errorData) {
    if (widget.showError) {
      final snackBar = SnackBar(content: Text("$errorData"));

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) {
  return PlacesAutocompleteResponse.fromJson(
    responseBody as Map<String, dynamic>,
  );
}

PlaceDetails parsePlaceDetailMap(Map responseBody) {
  return PlaceDetails.fromJson(responseBody as Map<String, dynamic>);
}

typedef ItemClick = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailswWithLatLng =
    void Function(Prediction postalCodeResponse);

typedef ListItemBuilder =
    Widget Function(BuildContext context, int index, Prediction prediction);
