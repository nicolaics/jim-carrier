import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


extension ColorExtension on Color {
  Color widthOpacity(double opacity) {
    return this.withOpacity(opacity);
  }
}


class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon=true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.widthOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title,style: GoogleFonts.roboto(fontSize: 20).apply(color: textColor),),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(LineAwesomeIcons.angle_right_solid, size: 18.0, color: Colors.grey)
      ): null,
    );
  }
}