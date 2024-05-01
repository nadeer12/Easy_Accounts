
import 'dart:async';
import 'dart:io';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



bool isNewButtonClicked = false;
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<String>> _data;
 
  
  void _viewDetails(String currencySymbol) async {
    // Construct the URL for fetching details
    String detailsUrl =
        // 'https://maraidemoapi.linkwayapps.com/api/currency/getcurrency?currencysymbol=$currencySymbol';
          'http://eademoapi.linkwayapps.com/api/currency/getcurrency?currencysymbol=$currencySymbol';
    // Fetch details data
    final detailsResponse = await http.get(Uri.parse(detailsUrl));

    if (detailsResponse.statusCode == 200) {
      // Parse the details data
      Map<String, dynamic> detailsData = json.decode(detailsResponse.body);

      // Navigate to the details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrencyDetailScreen(currencyDetail: detailsData),
        ),
      );
    } else {
      throw Exception('Failed to load details');
    }
  }

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<List<String>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://eademoapi.linkwayapps.com/api/currency'));

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteCurrency(int index) async {
    List<String> dataList = await _data;
    String currencyIdToDelete = dataList[index]; // Assuming currencyId is the item itself

    // Show confirmation dialog
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this currency?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked 'No'
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked 'Yes'
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    // Check if the user confirmed the deletion
    if (deleteConfirmed == true) {
      final response = await http.delete(
          Uri.parse('https://maraidemoapi.linkwayapps.com/api/currency/$currencyIdToDelete'));

      if (response.statusCode == 200) {
        // Reload data after deletion
        setState(() {
          _data = fetchData();
        });
      } else {
        throw Exception('Failed to delete currency');
      }
    }
  }

  void _refreshData() {
    setState(() {
      _data = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maraidemo Currency API Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(snapshot.hasError ? 'Error: ${snapshot.error}' : 'No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 20,
                  child: ListTile(
                    title: Text(
                      snapshot.data![index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    tileColor: Colors.blue[50],
                    contentPadding: EdgeInsets.all(16),
                    onTap: () {
                      // Handle list item click
                      _viewDetails(snapshot.data![index]);
                    },
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     IconButton(
                    //         onPressed: () {
                    //           deleteCurrency(index);
                    //         },
                    //         icon: Icon(Icons.delete, color: Colors.indigo)),
                           
                    //   ],
                    // ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
          isNewButtonClicked = true; // Set the flag when "New" button is clicked
        });
          // Navigator.pushNamed(context, '/add');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrencyDetailScreen(currencyDetail: {})
            )
          );
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}



class UtilityFunctions {
  static Future<void> _selectDateTime(BuildContext context) async {
    // ... (copy the _selectDateTime function code here)
    
    
  }

  static Future<void> postData(BuildContext context) async {
    late TextEditingController currencySymbolController;
    late TextEditingController currencyNameController;
    late TextEditingController decimalPlacesController;
    late TextEditingController decimalSymbolController;
    late TextEditingController priorityController;
    late TextEditingController fromdateController;
    late TextEditingController exchangeRateController;
  //dateTime
    DateTime selectedDateTime = DateTime.now();

     @override
    void initState() {
      

      // If currencyDetail is empty, initialize controllers with empty values
      currencySymbolController = TextEditingController();
      currencyNameController = TextEditingController();
      decimalPlacesController = TextEditingController();
      decimalSymbolController = TextEditingController();
      priorityController = TextEditingController();
      fromdateController = TextEditingController();
      exchangeRateController = TextEditingController();

      fromdateController = TextEditingController();


    }

    // ... (copy the postData function code here)
    final String apiUrl = 'https://maraidemoapi.linkwayapps.com/api/currency';

    final Map<String, dynamic> postData = {
      "CurrencySymbol": currencySymbolController.text,
      "CurrencyName": currencyNameController.text,
      "DecimalPlaces": int.parse(decimalPlacesController.text),
      "DecimalSymbol": decimalSymbolController.text,
      'Priority' : priorityController.text,
      // 'FromDate' : DateTime.parse(fromdateController.text),
      'ExchangeRate' :double.parse(exchangeRateController.text) ,
    }; 

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data posted successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to post data. Error: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  }




class postCurr extends StatefulWidget {
  final Map<String, dynamic> postcurrency;

  postCurr({required this.postcurrency});

  @override
  State<postCurr> createState() => _postCurrState();
}

class _postCurrState extends State<postCurr> {
  late TextEditingController currencySymbolController;
  late TextEditingController currencyNameController;
  late TextEditingController decimalPlacesController;
  late TextEditingController decimalSymbolController;
  late TextEditingController priorityController;
  late TextEditingController fromdateController;
  late TextEditingController exchangeRateController;
  //dateTime
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

  // If currencyDetail is empty, initialize controllers with empty values
    currencySymbolController = TextEditingController();
    currencyNameController = TextEditingController();
    decimalPlacesController = TextEditingController();
    decimalSymbolController = TextEditingController();
    priorityController = TextEditingController();
    fromdateController = TextEditingController();
    exchangeRateController = TextEditingController();

    fromdateController = TextEditingController();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currencySymbolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Symbol',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currencyNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: decimalPlacesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Decimal Places',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: decimalSymbolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Decimal Symbol',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priorityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Priority',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                
                controller: fromdateController,
                readOnly: true,
                // onTap: () => _selectDateTime(context),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'FromDate',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: exchangeRateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ExchangeRate',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                // Handle update button click
                  UtilityFunctions.postData(context);
                },
                child: Text('Save New Currency'),
              ),
            ),
          ],
         
        )
        
      )
    );
  }
}



class CurrencyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> currencyDetail;

  CurrencyDetailScreen({required this.currencyDetail});

  @override
  _CurrencyDetailScreenState createState() => _CurrencyDetailScreenState();
}

class _CurrencyDetailScreenState extends State<CurrencyDetailScreen> {
  late TextEditingController currencySymbolController;
  late TextEditingController currencyNameController;
  late TextEditingController decimalPlacesController;
  late TextEditingController decimalSymbolController;
  late TextEditingController priorityController;
  late TextEditingController fromdateController;
  late TextEditingController exchangeRateController;
  //dateTime
  DateTime selectedDateTime = DateTime.now();
  bool isNewButtonClicked = false;


  @override
  void initState() {
    super.initState();
    if (widget.currencyDetail.isNotEmpty) {
      currencySymbolController = TextEditingController(text: widget.currencyDetail['CurrencySymbol']);
      currencyNameController = TextEditingController(text: widget.currencyDetail['CurrencyName']);
      decimalPlacesController = TextEditingController(text: widget.currencyDetail['DecimalPlaces'].toString());
      decimalSymbolController = TextEditingController(text: widget.currencyDetail['DecimalSymbol']);
      priorityController = TextEditingController(text: widget.currencyDetail['Priority'] );
      fromdateController = TextEditingController(text : widget.currencyDetail['FromDate'].toString());
      exchangeRateController = TextEditingController(text: widget.currencyDetail['ExchangeRate'].toString());


      // fromdateController = TextEditingController(
      //   text: DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
      // );
    }
    else{
      // If currencyDetail is empty, initialize controllers with empty values
      currencySymbolController = TextEditingController();
      currencyNameController = TextEditingController();
      decimalPlacesController = TextEditingController();
      decimalSymbolController = TextEditingController();
      priorityController = TextEditingController();
      fromdateController = TextEditingController();
      exchangeRateController = TextEditingController();

      fromdateController = TextEditingController();
    }
  }

 


  Future<void> updateCurrency() async {
    // Show confirmation dialog
    bool updateConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Update'),
          content: Text('Are you sure you want to update this currency?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked 'No'
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked 'Yes'
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (updateConfirmed == true) {
      // Construct the URL for updating currency
      String updateUrl =
          'https://maraidemoapi.linkwayapps.com/api/currency/updatecurrency?oldcurrency=${widget.currencyDetail['CurrencySymbol']}';

      // Prepare the updated data
      Map<String, dynamic> updatedData = {
        'CurrencySymbol': currencySymbolController.text,
        'CurrencyName': currencyNameController.text,
        'DecimalPlaces': int.parse(decimalPlacesController.text),
        'DecimalSymbol': decimalSymbolController.text,
        'Priority' : priorityController.text,
        // 'FromDate' : double.parse(fromdateController.text),
        'ExchangeRate' :double.parse(exchangeRateController.text) ,
      };

      // Make the update request
      final response = await http.post(
        Uri.parse(updateUrl),
        body: jsonEncode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );
      

      if (response.statusCode == 200) {
        // Handle successful update
        // You can show a success message or navigate back to the previous screen
        // Navigator.pop(context);
        Navigator.pushNamed(context, '/');
      } else {
        // Handle update failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Failed'),
              content: Text('Failed to update currency. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    
                    Navigator.pushNamed(context, '/'); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
  // delete currency
  Future<void> deleteCurrency() async {
  // Show confirmation dialog
  bool deleteConfirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this currency?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User clicked 'No'
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User clicked 'Yes'
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );

  if (deleteConfirmed == true) {
    // Construct the URL for deleting currency
    String deleteUrl =
        'https://maraidemoapi.linkwayapps.com/api/currency/${widget.currencyDetail['CurrencySymbol']}';

    // Make the delete request
    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Handle successful deletion
      //  success message or navigate back to the previous screen
      // Navigator.pop(context);
      Navigator.pushNamed(context, '/');
    } else {
      // Handle deletion failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Deletion Failed'),
            content: Text('Failed to delete currency. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

void resetFields(){
  currencySymbolController.clear();
  currencyNameController.clear();
  decimalPlacesController.clear();
  decimalSymbolController.clear();
  priorityController.clear();
  fromdateController.clear();
  exchangeRateController.clear();
  isNewButtonClicked = false;

}

 Future<void> postData() async {
    final String apiUrl = 'https://maraidemoapi.linkwayapps.com/api/currency';

    final Map<String, dynamic> postData = {
      "CurrencySymbol": currencySymbolController.text,
      "CurrencyName": currencyNameController.text,
      "DecimalPlaces": int.parse(decimalPlacesController.text),
      "DecimalSymbol": decimalSymbolController.text,
      'Priority' : priorityController.text,
      // 'FromDate' : DateTime.parse(fromdateController.text),
      'ExchangeRate' :double.parse(exchangeRateController.text) ,
    }; 

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data posted successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to post data. Error: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

 Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          fromdateController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }
  

  Future<List<int>> generateCurrencyTicket() async {
  List<int> bytes = [];

  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
//print design

  bytes += generator.text(
      'MARAI DEMO COMPANY',
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
        underline: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,

      )
  );
  bytes += generator.text('ABUDHABI, PBA No:36873,UAE', styles: PosStyles(align: PosAlign.center));
  bytes += generator.text('Phone:xxxxxxxx Mobile : 97234567', styles: PosStyles(align: PosAlign.center));
  bytes += generator.text('Email : testmarai@gmail.com', styles: PosStyles(align: PosAlign.center));
  bytes += generator.text('Authorized dealer of Almarai', styles: PosStyles(align: PosAlign.center));
  bytes += generator.text('.........................................................', styles: PosStyles(align: PosAlign.center,bold: true));
  bytes += generator.text('MARAI DEMO CURRENCY DETAILS', styles: PosStyles(align: PosAlign.center,bold: true));
  bytes += generator.text('.........................................................', styles: PosStyles(align: PosAlign.center,bold: true));
  bytes += generator.text('Currency Symbol:${currencySymbolController.text}');
  bytes += generator.text('Currency Name:${currencyNameController.text}');
  bytes += generator.text('Decimal Places:${decimalPlacesController.text}');
  bytes += generator.text('Decimal Symbol:${decimalSymbolController.text}');
  bytes += generator.text('Priority:${priorityController.text}');
  bytes += generator.text('From Date:${fromdateController.text}');
  bytes += generator.text('Exchange Rate:${exchangeRateController.text}');
  bytes += generator.text('..........................................................', styles: PosStyles(align: PosAlign.center,bold: true));
  // Add additional formatting or details as needed

  bytes += generator.feed(2);
  return bytes;
}

Future<void> showPairedDevicesDialog() async {
  List<BluetoothInfo> pairedDevices = await PrintBluetoothThermal.pairedBluetooths;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Paired Devices'),
        content: Container(
          height: 200,
          width: 300,
          child: ListView.builder(
            itemCount: pairedDevices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pairedDevices[index].name),
                subtitle: Text(pairedDevices[index].macAdress),
                onTap: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await connect(pairedDevices[index].macAdress);
                  await printCurrencyDetails();
                },
              );
            },
          ),
        ),
      );
    },
  );
}

// Modify printCurrencyDetails function to remove the connection check
Future<void> printCurrencyDetails() async {
  try {
    List<int> ticket = await generateCurrencyTicket();
    final result = await PrintBluetoothThermal.writeBytes(ticket);
    print("Print result: $result");

    setState(() {
      var _msj = "Currency details printed successfully.";
    });
  } catch (e) {
    print("Print error: $e");

    setState(() {
     var _msj = "Failed to print currency details. Please try again.";
    });
  }
}

// Modify the existing connect function
Future<void> connect(String mac) async {
  setState(() {
   var _progress = true;
    var _msjprogress = "Connecting...";
    var connected = false;
  });

  final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);

  if (result) {
    var connected = true;
    setState(() {
     var _msj = "Connected to $mac";
    });
  } else {
    setState(() {
     var _msj = "Failed to connect to $mac";
    });
  }

  setState(() {
   var _progress = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Currency Details',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currencySymbolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Symbol',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: currencyNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: decimalPlacesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Decimal Places',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: decimalSymbolController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Decimal Symbol',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priorityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Priority',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                
                controller: fromdateController,
                readOnly: true,
                onTap: () => _selectDateTime(context),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'FromDate',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: exchangeRateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ExchangeRate',
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if(!isNewButtonClicked)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //       // Handle update button click
                //         updateCurrency();
                //       },
                //       child: Text('Update'),
                //     ),
                //   ),
                // if(!isNewButtonClicked)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //        // Handle update button click
                //         deleteCurrency();
                //       },
                //       child: Text('Delete'),
                //     ),
                //   ),
                // if(!isNewButtonClicked)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         // Handle update button click
                //         resetFields();
                //         setState(() {
                //           isNewButtonClicked = true; // Set the flag when "New" button is clicked
                //         });
                      

                //       },
                //       child: Text('New'),
                //     ),
                //   ),
                // if (isNewButtonClicked)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //       // Handle update button click
                //         postData();
                //       },
                //       child: Text('Save New Currency'),
                //     ) ,
                //   ),
              ],
            ),
            // Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ElevatedButton(
            //         onPressed: () {
            //           // Handle update button click
            //            postData();
            //         },
            //         child: Text('Save New Currency'),
            //       ),
            //     ),
            if(!isNewButtonClicked)
              Padding(
                padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle update button click
                      // Navigator.pushNamed(context, '/print');
                      showPairedDevicesDialog();
                       
                    },
                    child: Text('Print data'),
                  ),
                ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Reset fields and switch to "New" mode
      //     resetFields();
      //     setState(() {
      //       isNewButtonClicked = true;
      //     });
      //   },
      //   backgroundColor: Colors.indigo,
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}



