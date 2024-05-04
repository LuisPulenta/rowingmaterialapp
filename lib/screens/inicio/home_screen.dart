import 'package:flutter/material.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rowingmaterialapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final String imei;

  const HomeScreen({Key? key, required this.user, required this.imei})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  //---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rowing Material App'),
        centerTitle: true,
      ),
      body: _getBody(),
    );
  }

//---------------------------------------------------------------
//----------------------- _getBody ------------------------------
//---------------------------------------------------------------

  Widget _getBody() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff242424),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/logo.png",
              height: 50,
              width: 500,
            ),
            const Text(
              'LOGISTICA',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Bienvenido/a',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.user.nombre!.replaceAll("  ", ""),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                  onTap: widget.user.habilitaInstalacionesAPP == 1
                      ? () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstalacionesScreen(
                                user: widget.user,
                                imei: widget.imei,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: Boton(
                      icon: FontAwesomeIcons.barcode,
                      texto: "Equipos",
                      color1: widget.user.habilitaInstalacionesAPP == 1
                          ? const Color(0xff6989F5)
                          : Colors.grey,
                      color2: widget.user.habilitaInstalacionesAPP == 1
                          ? const Color(0xff906EF5)
                          : Colors.grey,
                    ),
                  ),
                ),
                InkWell(
                  onTap: null,
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.carBurst,
                      texto: "Vehículos",
                      color1: Colors.grey,
                      color2: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: null,
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.users,
                      texto: "RR.HH.",
                      color1: Color.fromARGB(255, 137, 137, 137),
                      color2: Color.fromARGB(255, 137, 137, 137),
                    ),
                  ),
                ),
                InkWell(
                  onTap: null,
                  child: SizedBox(
                    width: ancho * 0.5,
                    child: const Boton(
                      icon: FontAwesomeIcons.helmetSafety,
                      texto: "SS&HH",
                      color1: Color.fromARGB(255, 137, 137, 137),
                      color2: Color.fromARGB(255, 137, 137, 137),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _logOut();
                  },
                  child: SizedBox(
                    width: ancho * 1,
                    child: const Boton(
                      icon: FontAwesomeIcons.doorOpen,
                      texto: "Cerrar Sesión",
                      color1: Color.fromARGB(255, 236, 8, 8),
                      color2: Color.fromARGB(255, 211, 116, 113),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

//---------------------------------------------------------------
//----------------------- _logOut -------------------------------
//---------------------------------------------------------------

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
