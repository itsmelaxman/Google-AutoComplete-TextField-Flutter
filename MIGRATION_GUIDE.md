# Migration Guide: Google Places API (v1) Support

## Summary

This package has been updated to support Google's new Places API (v1) while maintaining backward compatibility with the legacy API. The new API is now the default for better performance and future-proofing.

## What's New

### 🚀 Google Places API (v1) Support
- **POST requests** with JSON body instead of GET with query parameters
- **Header-based authentication** using `X-Goog-Api-Key`
- **Better performance** and enhanced features
- **Future-proof** (legacy API is being deprecated)

### 🔧 New Features
1. **`useNewAPI` parameter**: Choose between new API (v1) and legacy API
2. **Enhanced place types**: More comprehensive place type support
3. **Improved location biasing**: Better location-based filtering
4. **Better error handling**: Enhanced API error management
5. **Updated example**: Side-by-side comparison of both APIs

## Breaking Changes

### Constructor Updates
The widget constructor now requires `const` and proper final fields:

```dart
// Before (will still work but with warnings)
GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_API_KEY",
  // ... other parameters
)

// After (recommended)
const GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_API_KEY",
  // ... other parameters
)
```

### Default API Change
- **Old default**: Legacy Google Places API
- **New default**: Google Places API (v1) with `useNewAPI: true`

## Migration Steps

### For Existing Users (Backward Compatibility)

If you want to keep using the legacy API (not recommended for new projects):

```dart
GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_API_KEY",
  useNewAPI: false, // Explicitly use legacy API
  // ... your existing parameters
)
```

### For New Projects (Recommended)

Use the new API (default behavior):

```dart
GooglePlaceAutoCompleteTextField(
  textEditingController: controller,
  googleAPIKey: "YOUR_API_KEY",
  // useNewAPI: true is the default
  // ... your parameters
)
```

## Google Cloud Console Setup

### For New API (v1)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **"Places API (New)"**
3. Create API credentials
4. Use the API key in your app

### For Legacy API
1. Enable **"Places API"** (the old one)
2. This will be deprecated soon by Google

## API Comparison

| Feature | New API (v1) | Legacy API |
|---------|-------------|------------|
| Request Method | POST | GET |
| Authentication | `X-Goog-Api-Key` header | Query parameter |
| Request Format | JSON body | Query parameters |
| Performance | ⚡ Better | Standard |
| Future Support | ✅ Supported | ⚠️ Being deprecated |
| Billing | More efficient | Standard |

## Updated Example

The example now shows both APIs side by side:

```dart
// New API usage
GooglePlaceAutoCompleteTextField(
  useNewAPI: true, // or omit (default)
  // ... other parameters
)

// Legacy API usage
GooglePlaceAutoCompleteTextField(
  useNewAPI: false,
  // ... other parameters
)
```

## Testing

Run the included tests to verify everything works:

```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **API Key Issues**
   - Make sure you've enabled the correct API in Google Cloud Console
   - For new API: Enable "Places API (New)"
   - For legacy API: Enable "Places API"

2. **CORS Issues (Web)**
   - The new API handles CORS better
   - Consider migrating to the new API for web apps

3. **Request Quota**
   - New API typically has better quota management
   - Check your billing account setup

### Getting Help

- Check the [example](example/) folder for complete implementation
- Review the updated documentation in README.md
- Open an issue on GitHub if you encounter problems

## Recommendation

🌟 **We strongly recommend migrating to the new API (v1)** for:
- Better performance
- Future compatibility
- Enhanced features
- More efficient billing

The legacy API support is maintained for backward compatibility but will be removed in a future major version when Google fully deprecates it.
