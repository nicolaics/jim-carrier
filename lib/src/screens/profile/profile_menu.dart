import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


extension ColorExtension on Color {
  Color widthOpacity(double opacity) {
    return withOpacity(opacity);
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.fontWeight,
    required this.fontStyle,
    this.endIcon=true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

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
      title: Text(title, style: GoogleFonts.roboto(fontSize: 20, fontWeight: fontWeight).apply(color: textColor, fontStyle: fontStyle),),
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