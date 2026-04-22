import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Atte_History extends StatefulWidget {
  const Atte_History({super.key});

  @override
  State<Atte_History> createState() => _Atte_HistoryState();
}

class _Atte_HistoryState extends State<Atte_History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade400,
                borderRadius: BorderRadius.circular(12)
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 25, color:  Color(0xFFCDFF6B) )),
            ), SizedBox(width: 15),
            Text("View Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple.shade400)),
          ],
        ),
        backgroundColor: Colors.lime.shade400,
      ),
    );
  }
}
