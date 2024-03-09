import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/detailCar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tìm kiếm xe',
            style: TextStyle(color: Colors.teal),
          ),
        ),
        body: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return Column(
              children: [
                _searchBar(),
                _cardTimeWidget(sizingInformation),
                _searchListWidget(),
              ],
            );
          },
        ));
  }

  Widget _searchListWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            splashColor: Colors.teal,
            leading: Icon(Icons.directions_car),
            title: Text('Car ${index + 1}'),
            subtitle: Text('Description of Car ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailCar(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm xe...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.teal),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
    );
  }

  Widget _cardTimeWidget(SizingInformation sizingInformation) {
    return Container(
      height: 101,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle onTap for the first card
                },
                splashColor: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 101,
                  width: sizingInformation.localWidgetSize.width * 0.45,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "10",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sunday, May 25",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Time: 10:00",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle onTap for the second card
                },
                splashColor: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 101,
                  width: sizingInformation.localWidgetSize.width * 0.45,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "11",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sunday, Nov 26",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Time: 10:00",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 24,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CarDetailsPage extends StatelessWidget {
  final int index;

  const CarDetailsPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: Center(
        child: Text('Details of Car ${index + 1}'),
      ),
    );
  }
}
