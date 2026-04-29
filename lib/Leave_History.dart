import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveHistory extends StatefulWidget {
  const LeaveHistory({super.key});

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
  final ctrl = TextEditingController();

  Widget card () {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 15, right: 15),
      child: Column(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade300
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lime.shade300,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, color: Color(0xFF4F46E5)),
                      SizedBox(width: 10),
                      Text("Marriage Leave", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))), SizedBox(width: 55),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(0xFF4F46E5), width: 2)
                        ),
                        child: Row(
                          children: [
                            Text("• Pending", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                /// 1. Date
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_today, size: 28, color: Color(0xFF4F46E5)),
                      SizedBox(width: 10),

                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text("Dates:-", style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold)), SizedBox(width: 8),
                            Text("11-04-2026 to 15-04-2026", style: TextStyle(fontSize: 15, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  )
                ),

                /// 2. Reason
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.description, size: 28, color: Color(0xFF4F46E5)),

                          SizedBox(width: 10),

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Reason:-", style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 8),
                        child: Container(
                            padding: EdgeInsets.only(left: 12, bottom: 8, top: 5),
                            width: size.width,
                            decoration: BoxDecoration(
                                color:  Color(0xFF4F46E5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red, width: 2)
                            ),
                            child: Text("• I applied for my brother's marriage in mention date so pls you approved & i am handover my task to colleague.", style: TextStyle(fontSize: 13.5, color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height*0.23, width: size.width,
              decoration: BoxDecoration(
                  color:  Colors.purple.shade400
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                              height: size.height*0.045, width: size.width*0.065,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back_rounded, color: Colors.purple.shade400))),
                        ), SizedBox(width: size.width*0.028),
                        Container(
                            height: size.height*0.045, width: size.width*0.065,
                            child: Icon(Icons.history, color: Colors.lime.shade200)), SizedBox(width: size.width*0.02),
                        Text("Leave History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.badge_sharp, size: 30, color: Colors.white), SizedBox(width: size.width*0.05),
                        Text("Employee.ID:-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFFCDFF6B))), SizedBox(width: size.width*0.05),
                        Text("E1584", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 12, right: 12),
                    child: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText:"Search by Leave Type", hintStyle: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, size: 25, color: Colors.purple.shade400),
                        fillColor: Colors.white, filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color:  Color(0xFFCDFF6B), width: 4)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 12, top: 12),
              child: Row(
                children: [
                  Container(
                    width: size.width*0.26,
                    decoration: BoxDecoration(
                      color: Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Icon(CupertinoIcons.calendar_circle, size: 38, color: Colors.lime.shade300),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text("Total", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          child: Text("2", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color:   Color(0xFFCDFF6B))),
                        ),
                      ],
                    ),
                  ), SizedBox(width: size.width*0.075),
                  Container(
                    width: size.width*0.26,
                    decoration: BoxDecoration(
                        color: Colors.lime.shade300,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Icon(CupertinoIcons.check_mark_circled, size: 38, color:  Color(0xFF4F46E5)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text("Approved", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Color(0xFF4F46E5))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          child: Text("1", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color:  Color(0xFF4F46E5))),
                        ),
                      ],
                    ),
                  ), SizedBox(width: size.width*0.078),
                  Container(
                    width: size.width*0.26,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Icon(Icons.hourglass_bottom_sharp, size: 38, color:  Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text("Pending", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          child: Text("0", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color:  Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Row(
                children: [
                     Container(
                    width: size.width*0.15, height: size.height*0.055,
                    padding: EdgeInsets.only(left: 15, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.purple.shade400,
                        borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("All", style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B)))
              ), SizedBox(width: size.width*0.055),
                     Container(
                      width: size.width*0.26, height: size.height*0.055,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Pending", style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B)))
                  ), SizedBox(width: size.width*0.055),
                     Container(
                      width: size.width*0.28, height: size.height*0.055,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Approved", style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B)))
                  ),
                ],
              ),
            ),
            card()
         ]
        ),
      )
    );
  }
}
