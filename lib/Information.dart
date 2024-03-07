import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Information'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Add your logic for handling the tap on the CircleAvatar
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('File Picker'),
                          content: Text('Implement your file picker logic here'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/icons/user.png'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show a dialog or navigate to another screen for editing personal information
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Chỉnh sửa trang cá nhân'),
                          content: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Add your logic for handling the tap on the CircleAvatar
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('File Picker'),
                                        content: Text('Implement your file picker logic here'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage('assets/images/icons/user.png'),
                                ),
                              ),
                              SizedBox(height: 5,),
                              // Add form fields or widgets for editing information
                              TextField(
                                // controller: ,
                                decoration: InputDecoration(
                                    hintText: "name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                                // Add appropriate properties for editing name
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                // controller: ,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                // controller: ,
                                decoration: InputDecoration(
                                  hintText: "Phone",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Add logic for saving the edited information
                                Navigator.of(context).pop();
                              },
                              child: Text('Save'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Chỉnh Sửa'),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Name: Kim Trường',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Email: ABC@example.com',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Phone: +1 555-1234',
                  style: TextStyle(fontSize: 16.0),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
