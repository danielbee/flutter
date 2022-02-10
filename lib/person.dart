


import 'package:flutter/material.dart';

class PersonWidget extends StatefulWidget {
  const PersonWidget({ Key? key, required this.getName, required this.updateName }) : super(key: key);
  final Function getName;
  final Function updateName;

  @override
  _PersonWidgetState createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  //late Widget _personNameWidget; // changes to TextField or dropdown after long press
  final nameController = TextEditingController();
  String name = "Fencer";
  @override 
  void initState(){ 
    super.initState();
    nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child : Row(
        
        children: [
            SizedBox( width:name.length.toDouble() < 10 ? 200 : name.length.toDouble()*10.0, 
              child:
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: name,
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    // icon: Icon(Icons.mail),
                    suffixIcon: nameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => nameController.clear(),
                          ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) { setState(() {
                    name = text;
                  });},
                  onSubmitted: (text){ print("Name is $text");},
                  
                )
              )
          //GestureDetector(
          //  child: _personNameWidget, 
          //  onLongPress: convertToEditField, //potentially a Typeahead Autocomplete Text Field (where the typeahead dropdown somes from local/cached json list of previously People or from polython database call. )
          //  
          //)
        ],
      )
      
    );
  }
}