import 'package:vester/Assistants/request_assistant.dart';
import 'package:flutter/material.dart';
import "../../model/predicted_places.dart";
import "package:vester/global/map_key.dart";
import "../../widget/place_prediction_pickup.dart";

class SearchPlacesScreenPickUp extends StatefulWidget {
  const SearchPlacesScreenPickUp({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreenPickUp> createState() =>
      _SearchPlacesScreenPickUpState();
}

class _SearchPlacesScreenPickUpState extends State<SearchPlacesScreenPickUp> {
  List<PredictedPlaces> placesPredictedList = [];
  TextEditingController? searchInput;
  bool searching = false;

  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapkey&components=country:NG";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      print(responseAutoCompleteSearch);

      if (responseAutoCompleteSearch == "Error Occured: Failed, No response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            // backgroundColor: darkTheme ? Colors.black : Color(0xFFFF5A5A),
            appBar: AppBar(
              // backgroundColor: darkTheme ? Colors.amber.shade400 : Color(0xFFFF5A5A),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Text(
                "Search & Set PickUp Location",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.white54,
                        blurRadius: 8,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.adjust_sharp,
                                color: darkTheme ? Colors.black : Colors.white),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                        controller: searchInput,
                                        onChanged: (value) {
                                          findPlaceAutoCompleteSearch(value);
                                          setState(() {
                                            searching = true;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Search location here...",
                                            // fillColor: darkTheme
                                            //     ? Color(0xFFFF5A5A)
                                            //     : Colors.white54,
                                            filled: true,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                              left: 11,
                                              top: 8,
                                              bottom: 8,
                                            )))))
                          ],
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                      ],
                    ),
                  ),
                ),

                //diplay place prediction result
                (placesPredictedList.length > 0)
                    ? Expanded(
                        child: ListView.separated(
                        itemBuilder: (context, index) {
                          return PlacePredictionTileDesignPickUp(
                            predictedPlaces: placesPredictedList[index],
                          );
                        },
                        itemCount: placesPredictedList.length,
                        physics: ClampingScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            thickness: 0,
                          );
                        },
                      ))
                    : Center(
                        child: Container(
                          child: !searching
                              ? null
                              : const CircularProgressIndicator(),
                        ),
                      ),
              ],
            )));
  }
}
