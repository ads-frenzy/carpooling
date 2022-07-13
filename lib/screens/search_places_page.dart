import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  final _searchFieldController = TextEditingController();
  DetailsResult? selectedLocation;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  late String apiKey;

  @override
  void initState() {
    super.initState();
    apiKey = 'AIzaSyCZ_vHda4OAfuaV_9E81pjZb9XqJPphEDg';
    googlePlace = GooglePlace(apiKey);
  }

  void autoCompleteSearch(String value) async {
    var placePredictions = await googlePlace.autocomplete.get(value);
    if (placePredictions != null && placePredictions.predictions != null) {
      setState(() {
        predictions = placePredictions.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchFieldController,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 24
              ),
              decoration: InputDecoration(
                  hintText: 'Search location',
                  hintStyle: const TextStyle(fontSize: 20),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchFieldController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              predictions = [];
                              _searchFieldController.clear();
                            });
                          },
                          icon: const Icon(Icons.clear_outlined),
                        )
                      : null
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                  }
                  else {
                    setState(() {
                      predictions = [];
                    });
                  }
                });
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      predictions[index].description.toString(),
                    ),
                    onTap: () async {
                      final placeId = predictions[index].placeId!;
                      final locationDetails = await googlePlace.details.get(placeId);
                      if (locationDetails != null && locationDetails.result != null && mounted) {
                        selectedLocation = locationDetails.result;
                        Navigator.pop(context, selectedLocation);
                      }
                    }
                  );
                })
          ],
        ),
      ),
    );
  }
}