import 'package:authority_panel/Screen/issues_screen.dart';
import 'package:authority_panel/helperfunctions.dart';
import 'package:authority_panel/repositoy/usermodel.dart';
import 'package:authority_panel/repositoy/userrepo.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyUsersScreen extends StatefulWidget {
  @override
  _NearbyUsersScreenState createState() => _NearbyUsersScreenState();
}

class _NearbyUsersScreenState extends State<NearbyUsersScreen> {
  List<UserModel> _nearbyUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNearbyUsers();
  }

  Future<void> _fetchNearbyUsers() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      double currentLat = position.latitude;
      double currentLon = position.longitude;

      List<UserModel> nearbyUsers =
          await UserRepository.getNearbyUsers(currentLat, currentLon);
      setState(() {
        _nearbyUsers = nearbyUsers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" विद्यालय सूची", style: TextStyle(fontSize: 20,color: Colors.white),),
        backgroundColor:  Color.fromRGBO(192, 119, 33, 1.0),
        actions: [],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
            color:  Color.fromRGBO(192, 119, 33, 1.0),
          ))
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _nearbyUsers.isEmpty
                  ? Center(child: Text('No users found within 5 km.'))
                  : ListView.builder(
                      itemCount: _nearbyUsers.length,
                      itemBuilder: (context, index) {
                        UserModel user = _nearbyUsers[index];
                        // return ListTile(

                        //   title: Text("${user.first} ${user.school}"),
                        //   subtitle: Text("Location: ${user.x}, ${user.y}"),
                        //   leading: user.photo.isNotEmpty
                        //       ? Image.network(user.photo)
                        //       : Icon(Icons.person),
                        // );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: THelperFunctions.screenHeight() * 0.22,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(204, 210, 237, 1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 2,
                                  color: Color.fromRGBO(192, 119, 33, 1.0),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // user.photo.isNotEmpty
                                      //     ? Image.network(user.photo)
                                      //     : Icon(Icons.person),
                                      Text(
                                        "${user.school}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SchoolDetails(
                                    user: user,
                                    heading: "प्रधानाचार्य का नाम :",
                                    subheading: user.first,
                                  ),
                                  SchoolDetails(
                                    user: user,
                                    heading: "प्रधानाचार्य का फ़ोन नंबर :",
                                    subheading: user.phone.toString(),
                                  ),
                                  SchoolDetails(
                                      heading: "विद्यालय का स्थान : ",
                                      subheading: user.x.toString() +
                                          " " +
                                          user.y.toString(),
                                      user: user),
                                  SizedBox(
                                      height: THelperFunctions.screenHeight() *
                                          0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final phoneNumber =
                                              Uri.parse('tel:+91${user.phone}');
                                          if (await launchUrl(phoneNumber)) {
                                            await launchUrl(phoneNumber);
                                          } else {
                                            throw 'Could not launch $phoneNumber';
                                          }
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight: THelperFunctions
                                                    .screenHeight() *
                                                0.03,
                                          ),
                                          child: Image.asset(
                                            "assets/phone-call-auricular-icon-on-transparent-background-free-png.webp",
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IssuesScreen(user:user
                                                          )));
                                        },
                                        child: Container(
                                            height: THelperFunctions
                                                    .screenHeight() *
                                                0.04,
                                            width:
                                                THelperFunctions.screenWidth() *
                                                    0.55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:const Color.fromRGBO(
                                                  52, 73, 94, 1.0),
                                            ),
                                            child: const Center(
                                                child: Text(
                                              "समस्या देखे",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ))),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () async {
                                          await _launchWhatsApp(
                                              user.phone.toString());
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight: THelperFunctions
                                                    .screenHeight() *
                                                0.03,
                                          ),
                                          child: Image.asset(
                                            "assets/Posters_20240705_080928_0006.png",
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

// ignore: must_be_immutable
class SchoolDetails extends StatelessWidget {
  String heading;
  String subheading;
  SchoolDetails({
    required this.heading,
    required this.subheading,
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(192, 119, 33, 1.0),
            ),
          ),
          Text(
            subheading,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

Future<void> _launchWhatsApp(String phone) async {
  final whatsappUrl = Uri.parse('https://wa.me/+91$phone');
  try {
    await launchUrl(whatsappUrl);
  } catch (e) {
    print(e);
  }
}
