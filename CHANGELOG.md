## 3.0.0

🚀 **Major Update: Google Places API (v1) Support**

### Added
- ✅ **NEW**: Google Places API (v1) support with POST requests and JSON body
- ✅ **NEW**: `useNewAPI` parameter to choose between new API (v1) and legacy API
- ✅ **NEW**: Enhanced place types support for new API
- ✅ **NEW**: Improved location biasing with new API
- ✅ **NEW**: Better error handling and API key validation
- ✅ **NEW**: Support for X-Goog-Api-Key header authentication
- ✅ **NEW**: Updated example with side-by-side comparison of both APIs

### Changed
- 🔄 **BREAKING**: Widget constructor now requires `const` and proper final fields
- 🔄 **BREAKING**: Default API is now the new Places API (v1) (`useNewAPI: true`)
- 🔄 **IMPROVED**: Better performance with new API
- 🔄 **IMPROVED**: Enhanced null safety throughout the codebase
- 🔄 **IMPROVED**: Updated documentation with migration guide

### Deprecated
- ⚠️ Legacy Google Places API support (still available with `useNewAPI: false`)

### Migration Guide
- For existing users: Add `useNewAPI: false` to maintain legacy behavior
- For new users: Use default settings to get new API (v1) benefits
- Update your Google Cloud Console to enable "Places API (New)"

## 2.0.3

* Remove place-type field and improve the accuracy of search result

## 2.0.2

* Get LatLng from Place detail

## 2.0.1

* Support multiple countries

## 2.0.0

* Support country code

## 1.0.0

* Initial commit.

## 2.0.4

* Support Null Safety

## 2.0.5

* Support Null Safety and code improvement

## 2.0.6

* Support custom list item builder, error handled and minor fixes

## 2.0.7

* Update dio dependency and minor improvements 

## 2.0.8

* Bug fixes and improvements

## 2.0.9

* Filter added by PlaceType and language


## 2.1.0

* Added Near By Search and Some Bug fixes and improvements


