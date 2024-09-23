import 'package:agriculture/Screen/disply_specific_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataDisplayScreen extends StatefulWidget {
  const DataDisplayScreen({super.key});

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  String? search = '';
  List<Map<String, dynamic>> searchResults = [];
  Box? agricultureBox;

  @override
  void initState() {
    super.initState();
    _openBox(); // Ensure the box is opened once
    _dataFuture = _checkAndFetchData();
  }

  Future<void> _openBox() async {
    agricultureBox = await Hive.openBox('agricultureData');
  }

  Future<List<Map<String, dynamic>>> _checkAndFetchData() async {
    if (agricultureBox == null) {
      await _openBox(); // Wait for the box to open if it's null
    }
    final box = agricultureBox!;

    if (box.isEmpty) {
      // Fetch data from Firebase Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('dataEntries').get();

      List<Map<String, dynamic>> firebaseData = snapshot.docs
          .map((doc) =>
              Map<String, dynamic>.from(doc.data() as Map<String, dynamic>))
          .toList();

      // Store fetched data in Hive
      for (var data in firebaseData) {
        await box.add(data);
      }

      return firebaseData;
    } else {
      return _fetchDataFromHive();
    }
  }

  // Search method with null check
  List<Map<String, dynamic>> searchAndReturnList(String searchTerm) {
    if (agricultureBox == null) {
      print("Box is not open yet.");
      return [];
    }

    var box = agricultureBox!;
    print("Searching for: $searchTerm");

    var results = box.values
        .where((entry) {
          print("Checking entry: $entry");
          return entry['ZamendarName'] != null &&
              entry['ZamendarName']
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase());
        })
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();

    print("Search results: $results");
    return results;
  }

  Future<List<Map<String, dynamic>>> _fetchDataFromHive() async {
    if (agricultureBox == null) {
      await _openBox(); // Wait for the box to open if it's null
    }
    final box = agricultureBox!;
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < box.length; i++) {
      final rawData = box.getAt(i);
      if (rawData is Map<dynamic, dynamic>) {
        final castedData =
            rawData.map((key, value) => MapEntry(key.toString(), value));
        data.add(castedData);
      }
    }

    return data;
  }

  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: isSearch
            ? TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name, Email, ...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                autofocus: true,
                onChanged: (val) {
                  setState(() {
                    search = val;
                    searchResults = searchAndReturnList(search!);
                  });
                },
              )
            : const Text(
                'All Data',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: search != null && search!.isNotEmpty
          ? _buildSearchResults()
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available.'));
                } else {
                  final data = snapshot.data!;
                  return _buildDataTable(data);
                }
              },
            ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _buildDataTable(searchResults),
    );
  }

  Widget _buildDataTable(List<Map<String, dynamic>> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Zamendar Name')),
            DataColumn(label: Text('Current Rate')),
            DataColumn(label: Text('Product Weight')),
            DataColumn(label: Text('Total Chundae')),
            DataColumn(label: Text('Total Fare')),
            DataColumn(label: Text('Total Labour Wage')),
            DataColumn(label: Text('Final Weight')),
            DataColumn(label: Text('Total Amount')),
            DataColumn(label: Text('Jaman Amount')),
            DataColumn(label: Text('1/4 Amount')),
            DataColumn(label: Text('Balance Amount')),
          ],
          rows: data.map((entry) {
            return DataRow(
              cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplySpecificPerson(
                            datauser: entry,
                            onUpdate: () {
                              setState(() {
                                _dataFuture =
                                    _fetchDataFromHive(); // Refresh data
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(entry['ZamendarName'] ?? 'N/A'),
                  ),
                ),
                DataCell(Text(entry['currentRate'].toString())),
                DataCell(Text(entry['productWeight'].toString())),
                DataCell(Text(entry['totalChundae'].toString())),
                DataCell(Text(entry['totalFare'].toString())),
                DataCell(Text(entry['totalLabourWage'].toString())),
                DataCell(Text(entry['finalWeight'].toString())),
                DataCell(Text(entry['totalAmount'].toString())),
                DataCell(Text(entry['jamanAmount'].toString())),
                DataCell(Text(entry['1/4 Amount'].toString())),
                DataCell(Text(entry['balanceAmount'].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
