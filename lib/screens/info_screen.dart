import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box box;

  // Add info to people box
  _addInfo() async {
    // Storing key-value pair
    box.put('name', 'John');
    box.put('country', 'Italy');

    print('Info added to box!');
  }

  // Get info from people box
  _getInfo() {
    var name = box.get('name');
    var country = box.get('country');

    print('Info retrieved from box: $name ($country)');
  }

  // Update info of people box
  _updateInfo() {
    box.put('name', 'Mike');
    box.put('country', 'United States');

    print('Info updated in box!');
  }

  // Delete info from people box
  _deleteInfo() {
    box.delete('name');
    box.delete('country');

    print('Info deleted from box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('peopleBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People Info'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addInfo,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _addInfo,
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: _getInfo,
              child: Text('Get'),
            ),
            ElevatedButton(
              onPressed: _updateInfo,
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: _deleteInfo,
              child: Text('Delete'),
            ),
          ],
        ),
      ),
      // body: ListView.builder(
      //   itemCount: 1,
      //   itemBuilder: (context, index) {
      //     return ListTile();
      //   },
      // ),
    );
  }
}
