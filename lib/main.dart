import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class AppColors {
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color textColor = Color(0xFF333333);
}

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Fields Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primaryColor, // Use the custom primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textColor), // Use the correct name
          titleMedium: TextStyle(color: AppColors.textColor), // Use the correct name
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white, // Set the text color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Use 'const'
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const DynamicFields(), // Use 'const'
    );
  }
}

class DynamicFields extends StatefulWidget {
  const DynamicFields({Key? key}) : super(key: key); // Use 'const'

  @override
  _DynamicFieldsState createState() => _DynamicFieldsState();
}

class _DynamicFieldsState extends State<DynamicFields> {
  List<Widget> inputFields = [];
  List<TextEditingController> controllers = [];
  int clickCount = 0;

  
  final List<String> fieldNames = [
  'Name',
  'Age',
  'Phone Number',
  'Email',
  'Address',
  'City',
  'State',
  'Country',
  ];

  void _addField() {
    setState(() {
      if (clickCount < fieldNames.length) {
        TextEditingController controller = TextEditingController();
        controllers.add(controller);  

        inputFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Use 'const'
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(fieldNames[clickCount], style: const TextStyle(fontWeight: FontWeight.bold)), // Use 'const'
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: controller,  // Set the controller to the text field
                    decoration: InputDecoration(
                      hintText: 'Enter ${fieldNames[clickCount]}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.blue.withOpacity(0.1), // Use the custom background color
                    ),
                    keyboardType: (fieldNames[clickCount] == 'Age' ||
                                   fieldNames[clickCount] == 'Zip Code')
                        ? TextInputType.number
                        : TextInputType.text,
                  ),
                ),
              ],
            ),
          ),
        );
        clickCount++;
      }
    });
  }

  // Generate a string with all the input data
  String _getInputData() {
    String data = '';
    for (int i = 0; i < controllers.length; i++) {
      data += '${fieldNames[i]}: ${controllers[i].text}\n';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Input Fields'), // Use 'const'
        centerTitle: true,
        backgroundColor: AppColors.primaryColor, // Use the custom primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Use 'const'
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addField,
              child: const Text('+ Add Field'), // Use 'const'
            ),
            const SizedBox(height: 20), // Use 'const'
            Expanded(
              child: ListView.builder(
                itemCount: inputFields.length,
                itemBuilder: (context, index) {
                  return inputFields[index];
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final data = _getInputData(); // Get the input data
                if (data.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('QR Code'), // Use 'const'
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: QrImageView(
                            data: data, // Pass the input data as a string
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Close'), // Use 'const'
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Generate QR Code'), // Use 'const'
            ),
          ],
        ),
     ),
);
}
}
