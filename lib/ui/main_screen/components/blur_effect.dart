import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlurEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          var pref = snapshot.data;

          if(snapshot.hasData){
            double blurValue = pref.getDouble('currentblur');
            if(blurValue == null){
              blurValue = 0.0;
            }
            
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurValue,
                sigmaY: blurValue,
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            );
          }
          else{
            return Container();
          }
        }
      ),
    );
  }
}