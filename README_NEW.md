# google_places_flutter

**🚀 Now supports Google's New Places API (v1)!**

A Flutter package that provides Google Places autocomplete widgets with support for both the new Google Places API (v1) and legacy API.

## ⚠️ Important Notice

Google is deprecating the legacy Places API. This package now supports the **new Google Places API (v1)** which:
- Uses POST requests with JSON body
- Requires API key in headers (`X-Goog-Api-Key`)
- Provides better performance and more features

## Features

- ✅ **New Google Places API (v1)** support (default)
- ✅ Legacy API support for backward compatibility
- ✅ Customizable UI components
- ✅ Debounced API calls
- ✅ Country filtering
- ✅ Place type filtering
- ✅ Location biasing
- ✅ Latitude/Longitude extraction

## Installation

Add dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_places_flutter: <latest-version>
```

## Quick Start

### Using New API (v1) - Recommended

```dart
GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_GOOGLE_API_KEY",
  useNewAPI: true, // Use new API (default)
  inputDecoration: InputDecoration(
    hintText: "Search places...",
    border: OutlineInputBorder(),
  ),
  debounceTime: 800,
  countries: ["us", "in"], // Optional country filtering
  isLatLngRequired: true,
  getPlaceDetailWithLatLng: (Prediction prediction) {
    // Get coordinates with place details
    print("Place: ${prediction.description}");
    print("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
  },
  itemClick: (Prediction prediction) {
    controller.text = prediction.description ?? "";
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: prediction.description?.length ?? 0)
    );
  },
)
```

### Using Legacy API (for backward compatibility)

```dart
GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_GOOGLE_API_KEY",
  useNewAPI: false, // Use legacy API
  // ... other parameters remain the same
)
```

## Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `useNewAPI` | `bool` | `true` | Use new API (v1) or legacy API |
| `googleAPIKey` | `String` | required | Your Google API key |
| `textEditingController` | `TextEditingController` | required | Text field controller |
| `inputDecoration` | `InputDecoration` | `InputDecoration()` | Text field decoration |
| `debounceTime` | `int` | `600` | Delay in milliseconds before API call |
| `countries` | `List<String>?` | `null` | Country codes for filtering (e.g., ["us", "in"]) |
| `isLatLngRequired` | `bool` | `true` | Whether to fetch coordinates |
| `placeType` | `PlaceType?` | `null` | Filter by place type |
| `language` | `String?` | `'en'` | Language for results |
| `latitude` | `double?` | `null` | Latitude for location biasing |
| `longitude` | `double?` | `null` | Longitude for location biasing |
| `radius` | `int?` | `null` | Search radius in meters |

## Advanced Customization

### Custom Item Builder

```dart
GooglePlaceAutoCompleteTextField(
  // ... other parameters
  itemBuilder: (context, index, Prediction prediction) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.location_on),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.structuredFormatting?.mainText ?? 
                  prediction.description ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (prediction.structuredFormatting?.secondaryText != null)
                  Text(
                    prediction.structuredFormatting!.secondaryText!,
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  },
  seperatedBuilder: Divider(),
  isCrossBtnShown: true,
  containerHorizontalPadding: 10,
)
```

### Place Types

The package supports various place types:

```dart
// New API place types (recommended)
PlaceType.restaurant
PlaceType.hospital
PlaceType.airport
PlaceType.bank
// ... and many more

// Legacy API place types
PlaceType.geocode
PlaceType.address
PlaceType.establishment
PlaceType.region
PlaceType.cities
```

## API Key Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Places API (New)** for new API or **Places API** for legacy
3. Create credentials and get your API key
4. Replace `"YOUR_GOOGLE_API_KEY"` with your actual key

## Migration from Legacy API

If you're currently using the legacy API, migrating is simple:

```dart
// Old way (legacy API)
GooglePlaceAutoCompleteTextField(
  // ... your existing parameters
)

// New way (recommended)
GooglePlaceAutoCompleteTextField(
  useNewAPI: true, // Add this line (or omit as it's default)
  // ... your existing parameters
)
```

## Example

See the [example](example/) folder for a complete implementation comparing both APIs.

## API Differences

| Feature | New API (v1) | Legacy API |
|---------|-------------|------------|
| Request Method | POST | GET |
| API Key Header | `X-Goog-Api-Key` | Query parameter |
| Request Body | JSON | Query parameters |
| Performance | Better | Standard |
| Future Support | ✅ Supported | ⚠️ Being deprecated |

## Screenshots

<img src="sample.jpg" height="400">

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
