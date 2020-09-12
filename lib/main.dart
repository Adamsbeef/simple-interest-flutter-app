import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
  ));
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Others', 'Dollars', 'Pounds', 'Naira'];
  final _minimumPadding = 5.0;
  var _currentSelectedItem = '';
  String displayResult = '';

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _currentSelectedItem = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();

  TextEditingController roiController = TextEditingController();

  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('SI Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: [
              getImageAsset(),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                    controller: principalController,
                    style: textStyle,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.yellow),
                        hintText: 'Enter Principal Amount',
                        labelText: 'Principal',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'You have to enter a Roi';
                      } else if (double.parse(value, (e) => null) == null) {
                        return 'You have to enter a valid nubber';
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: textStyle,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'You have to enter a Roi';
                    } else if (double.parse(value, (e) => null) == null) {
                      return 'You have to enter a valid nubber';
                    }
                  },
                  controller: roiController,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.yellow),
                      hintText: 'Rate of Interest',
                      labelText: 'In percent',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding,
                    bottom: _minimumPadding,
                    left: _minimumPadding * 2),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      style: textStyle,
                      controller: termController,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.yellow),
                          hintText: 'Term',
                          labelText: 'Time in years',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.number,
                      validator: (String userInput) {
                        if (userInput.isEmpty) {
                          return 'You have to enter a term';
                        } else if (double.parse(userInput, (e) => null) ==
                            null) {
                          return 'You have to enter a valid nubber';
                        }
                      },
                    )),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: _minimumPadding,
                                bottom: _minimumPadding,
                                left: _minimumPadding * 2),
                            child: DropdownButton<String>(
                              items: _currencies.map((String dropDownString) {
                                return DropdownMenuItem<String>(
                                    value: dropDownString,
                                    child: Text(dropDownString));
                              }).toList(),
                              value: _currentSelectedItem,
                              onChanged: (String valueSelected) {
                                _onDropDownSelected(valueSelected);
                              },
                            )))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        'Calculate',
                        textScaleFactor: 1.0,
                        style: textStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            this.displayResult = _calculateTotalReturns();
                          }
                        });
                      },
                    )),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Reset',
                        style: textStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownSelected(String valueSelected) {
    setState(() {
      this._currentSelectedItem = valueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    return 'Total payable interest is $totalAmountPayable after $term years';
  }

  void _reset() {
    roiController.text = '';
    principalController.text = '';
    termController.text = '';
    displayResult = '';
    _currentSelectedItem = _currencies[0];
  }
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}
