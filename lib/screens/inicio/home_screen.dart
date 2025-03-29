import 'package:flutter/material.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rowingmaterialapp/widgets/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
      // appBar: AppBar(
      //   title: const Text('Rowing Material App'),
      //   centerTitle: true,
      // ),
      body: _getBody(),
    );
  }

//---------------------------------------------------------------
//----------------------- _getBody ------------------------------
//---------------------------------------------------------------

  Widget _getBody() {
    const nTextstyle = TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

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
            const SizedBox(
              height: 60,
            ),
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
            const SizedBox(
              height: 40,
              child: Text('Bienvenido/a',
                  textAlign: TextAlign.center, style: nTextstyle),
              // child: AnimatedTextKit(
              //   animatedTexts: [
              //     for (final text in ['Bienvenido/a'])
              //       WavyAnimatedText(
              //         text,
              //         textStyle: nTextstyle,
              //         textAlign: TextAlign.center,
              //       )
              //   ],
              //   repeatForever: false,
              // ),
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Text(widget.user.nombre!.replaceAll("  ", ""),
                  textAlign: TextAlign.center, style: nTextstyle),
              // child: AnimatedTextKit(
              //   animatedTexts: [
              //     for (final text in [widget.user.nombre!.replaceAll("  ", "")])
              //       WavyAnimatedText(
              //         text,
              //         textStyle: nTextstyle,
              //         textAlign: TextAlign.center,
              //       )
              //   ],
              //   repeatForever: false,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.user.habilitaInstalacionesAPP == 1
                        ? () async {
                            await Navigator.push(
                                context,
                                // MaterialPageRoute(
                                //     builder: (context) => HomeScreen(
                                //           user: user,
                                //           imei: _imeiNo,
                                //         )));
                                PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) =>
                                        InstalacionesScreen(
                                          user: widget.user,
                                          imei: widget.imei,
                                        ),
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      final curvedAnimation = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut);

                                      return FadeTransition(
                                          child: child,
                                          opacity: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(curvedAnimation));
                                    }));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => InstalacionesScreen(
                            //       user: widget.user,
                            //       imei: widget.imei,
                            //     ),
                            //   ),
                            // );
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
                  // InkWell(
                  //   onTap: null,
                  //   child: SizedBox(
                  //     width: ancho * 0.5,
                  //     child: const Boton(
                  //       icon: FontAwesomeIcons.carBurst,
                  //       texto: "Vehículos",
                  //       color1: Colors.grey,
                  //       color2: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     InkWell(
            //       onTap: null,
            //       child: SizedBox(
            //         width: ancho * 0.5,
            //         child: const Boton(
            //           icon: FontAwesomeIcons.users,
            //           texto: "RR.HH.",
            //           color1: Color.fromARGB(255, 137, 137, 137),
            //           color2: Color.fromARGB(255, 137, 137, 137),
            //         ),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: null,
            //       child: SizedBox(
            //         width: ancho * 0.5,
            //         child: const Boton(
            //           icon: FontAwesomeIcons.helmetSafety,
            //           texto: "SS&HH",
            //           color1: Color.fromARGB(255, 137, 137, 137),
            //           color2: Color.fromARGB(255, 137, 137, 137),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _logOut();
                  },
                  child: SizedBox(
                    width: ancho * 0.95,
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
