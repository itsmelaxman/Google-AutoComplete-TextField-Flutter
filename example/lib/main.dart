import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Google Places API Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController newAPIController = TextEditingController();
  TextEditingController legacyAPIController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? "")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'New Google Places API (v1)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Uses POST requests with JSON body and API key in headers',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              newAPITextField(),
              SizedBox(height: 40),
              Text(
                'Legacy Google Places API',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Uses GET requests with query parameters (being deprecated)',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              legacyAPITextField(),
              SizedBox(height: 40),
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget newAPITextField() {
    return Container(
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: newAPIController,
        googleAPIKey: "your-google-api-key", // Replace with your actual API key
        useNewAPI: false, // Use the new Places API (v1)
        inputDecoration: InputDecoration(
          hintText: "Search with New API (v1)",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.new_releases, color: Colors.green),
        ),
        debounceTime: 400,
        countries: ["us", "in", "np"],
        isLatLngRequired: true,
        placeType: PlaceType.establishment,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("New API - Place Details: ${prediction.description}");
          print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
        },
        itemClick: (Prediction prediction) {
          newAPIController.text = prediction.description ?? "";
          newAPIController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        },
        seperatedBuilder: Divider(height: 1),
        containerHorizontalPadding: 10,
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.structuredFormatting?.mainText ??
                            prediction.description ??
                            "",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (prediction.structuredFormatting?.secondaryText !=
                          null)
                        Text(
                          prediction.structuredFormatting!.secondaryText!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.north_east, size: 16, color: Colors.grey),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }

  Widget legacyAPITextField() {
    return Container(
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: legacyAPIController,
        googleAPIKey: "YOUR_GOOGLE_API_KEY", // Replace with your actual API key
        useNewAPI: false, // Use the legacy Places API
        inputDecoration: InputDecoration(
          hintText: "Search with Legacy API",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.warning, color: Colors.orange),
        ),
        debounceTime: 400,
        countries: ["us", "in"],
        isLatLngRequired: true,
        placeType: PlaceType.establishment,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("Legacy API - Place Details: ${prediction.description}");
          print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
        },
        itemClick: (Prediction prediction) {
          legacyAPIController.text = prediction.description ?? "";
          legacyAPIController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        },
        seperatedBuilder: Divider(height: 1),
        containerHorizontalPadding: 10,
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.structuredFormatting?.mainText ??
                            prediction.description ??
                            "",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (prediction.structuredFormatting?.secondaryText !=
                          null)
                        Text(
                          prediction.structuredFormatting!.secondaryText!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.north_east, size: 16, color: Colors.grey),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildInfoRow(
              'New API (v1):',
              'Uses POST with JSON body and X-Goog-Api-Key header',
            ),
            _buildInfoRow(
              'Legacy API:',
              'Uses GET with query parameters (deprecated)',
            ),
            _buildInfoRow('Default:', 'useNewAPI: true (recommended)'),
            SizedBox(height: 10),
            Text(
              'Important: Replace "YOUR_GOOGLE_API_KEY" with your actual Google API key.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}
