


import 'package:flutter/material.dart';

class PersonWidget extends StatefulWidget {
  const PersonWidget({ Key? key, required this.defaultName, required this.getName, required this.updateName }) : super(key: key);
  final String defaultName;
  final Function getName;
  final Function updateName;

  @override
  _PersonWidgetState createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  //late Widget _personNameWidget; // changes to TextField or dropdown after long press
  final nameController = TextEditingController();
  bool _focussed = false;
  bool _hover = false;
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
            SizedBox(width: 200, 
              child:
              MouseRegion(
                onEnter: (event){
                  print("hover $event"); 
                  setState(() {_hover = true; });
                   },
                onExit: (event){
                  print("leave hover $event"); 
                  setState(() {_hover = false; });
                   },
                child:
                Focus(
                  onFocusChange: (hasFocus) { 
                    if (hasFocus) { 
                      print("editing the name");
                      setState(() {
                        _focussed = true;
                        
                      });
                    } else { 
                      print("Finished editing the name");
                      setState(() {
                        _focussed = false;
                      });
                    }
                  },
                  child: 
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: widget.getName(),
                        labelText: _focussed ? "Name" : null ,
                        prefixIcon: Icon(Icons.person), // todo once we have profile photo
                        // icon: Icon(Icons.mail),
                        suffixIcon: _focussed || _hover ? nameController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {nameController.clear(); widget.updateName(widget.defaultName);},
                              )
                            : null,
                        border: OutlineInputBorder(borderSide: _focussed ? BorderSide(): _hover ? BorderSide(color: Colors.black12):  BorderSide.none),
                      ),
                      onChanged: (text) { widget.updateName(text);},
                      onSubmitted: (text){ print("Name is $text");},

                    )
                ))
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