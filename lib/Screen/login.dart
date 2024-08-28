import 'package:authority_panel/Screen/Signup.dart';
import 'package:authority_panel/Screen/logincontroller.dart';
import 'package:authority_panel/Screen/validator.dart';
import 'package:authority_panel/helperfunctions.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _selectedTopValue;

  final List<String> _dropdownItems = [
    'Hindi/हिंदी',
    'English',
    'Malayalam/മലയാളം'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Center(
                child: IntrinsicWidth(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Select Language",
                      border: InputBorder.none,
                    ),
                    value: _selectedTopValue,
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTopValue = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Center(
                child: Text(
                  "लॉगिन करें ",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(192, 119, 33, 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.01,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "कार्यालय का ई-मेल",
                    style: TextStyle(
                      fontSize: THelperFunctions.screenHeight() * 0.022,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(187, 187, 187, 1.0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: SigninController.email,
                      validator: (value) => Validator.validateEmail(value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: THelperFunctions.screenHeight() * 0.022,
                  ),
                  Text(
                    "पासवर्ड",
                    style: TextStyle(
                      fontSize: THelperFunctions.screenHeight() * 0.022,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(187, 187, 187, 1.0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: SigninController.password,
                      obscureText: true,
                      obscuringCharacter: "*",
                      validator: (value) => Validator.validatepassword(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: THelperFunctions.screenHeight() * 0.022,
                  ),
                  SizedBox(
                    height: THelperFunctions.screenHeight() * 0.022,
                  ),
                  InkWell(
                    onTap: () async {
                   SigninController.signIncall(
                                  
                                  SigninController.email.text,
                                  SigninController.password.text,
                                  context);
                    },
                    child: Container(
                      height: THelperFunctions.screenHeight() * 0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(192, 119, 33, 1.0),
                        border: Border.all(
                          color: Color.fromRGBO(187, 187, 187, 1.0),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "लॉगिन करें",
                          style: TextStyle(
                            fontSize: THelperFunctions.screenHeight() * 0.023,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                SizedBox(height: 10,),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("नए उपयोगकर्ता", style: TextStyle(fontWeight: FontWeight.w600),),
                        InkWell(
                          onTap: (){Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  SignUp())); },
                          child: Text("साइन अप करें",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                            color: Color.fromRGBO(192, 119, 33, 1.0),
                          ),),
                        )
                      ],
                    ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.3),
              IntrinsicHeight(
                child: Image.asset("assets/Group 22.png"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
