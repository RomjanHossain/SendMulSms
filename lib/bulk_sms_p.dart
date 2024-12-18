import 'package:flutter/material.dart';

import 'package:school_sms/send_sms.dart';

class BulkSmsPage extends StatefulWidget {
  @override
  _BulkSmsPageState createState() => _BulkSmsPageState();
}

class _BulkSmsPageState extends State<BulkSmsPage> {
  List<TextEditingController> phoneControllers = [TextEditingController()];

  TextEditingController messageController = TextEditingController();

  void addPhoneNumberField() {
    setState(() {
      phoneControllers.add(TextEditingController());
    });
  }

  void removePhoneNumberField(int index) {
    setState(() {
      phoneControllers.removeAt(index);
    });
  }

  void sendSMS() async {
    List<String> phoneNumbers = phoneControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toList();

    String message = messageController.text;

    if (phoneNumbers.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter phone numbers and a message')),
      );
      return;
    }

    final isSuccess = await sendRealSMS(message, phoneNumbers);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bulk SMS Sender'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Phone Numbers:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: phoneControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneControllers[index],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number ${index + 1}',
                            hintText: 'Enter phone number',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => removePhoneNumberField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: addPhoneNumberField,
                child: Text('Add Number'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Enter Message:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your message here',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: sendSMS,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Send Message',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
