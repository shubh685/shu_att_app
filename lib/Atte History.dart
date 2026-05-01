import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Atte_History extends StatefulWidget {
  const Atte_History({super.key});

  @override
  State<Atte_History> createState() => _Atte_HistoryState();
}

class _Atte_HistoryState extends State<Atte_History> {
  int selectedTab = 0; // 0 = Today, 1 = Monthly
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
            height: size.height*0.27, width: size.width,
            decoration: BoxDecoration(
              color: Colors.lime.shade300
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
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle
                          ),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back_rounded, color:  Colors.white))),
                      ), SizedBox(width: size.width*0.028),
                      Container(
                          height: size.height*0.045, width: size.width*0.065,
                          child: Icon(Icons.history, color:  Colors.purple.shade400)), SizedBox(width: size.width*0.02),
                      Text("View Attendance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade400,
                      borderRadius: BorderRadius.circular(0)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.person_alt_circle, color: Colors.white), SizedBox(width: size.width*0.05),
                              Text("Name:-", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color:  Color(0xFFE8FFB5))), SizedBox(width: size.width*0.05),
                              Text("Shubham Shah", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B)))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height*0.018,
                          child: Divider(color: Colors.white, thickness: 5),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.badge_sharp, color: Colors.white), SizedBox(width: size.width*0.05),
                              Row(
                                children: [
                                  Text("Employee ID:-", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color:  Color(0xFFE8FFB5))), SizedBox(width: size.width*0.023),
                                  Text("E1584", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B))),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height*0.018,
                          child: Divider(color: Colors.white, thickness: 5),
                        ),
                      ],
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 12),
                  child: Row(
                    children: [
                      Text("Today's Date:-", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.purple.shade400)), SizedBox(width: size.width*0.05),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color:  Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: Text("23-04-2026", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.only(left: 10, top: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedTab=0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: size.height*0.05,
                     decoration: BoxDecoration(
                        color: selectedTab == 0 ? Color(0xFF4F46E5) : Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                     ),
                      child: Text("Today's Activity", style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold, color: selectedTab==0 ? Color(0xFFCDFF6B) :  Color(0xFF4F46E5)))),
                ), SizedBox(width: size.width*0.055),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedTab=1;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: size.height*0.05,
                      decoration: BoxDecoration(
                        color: selectedTab == 1 ? Color(0xFF4F46E5) : Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Monthly Activity", style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold, color:  selectedTab==1 ? Color(0xFFCDFF6B) :  Color(0xFF4F46E5)))),
                ),
              ],
            ),
          ),
           if(selectedTab ==0) ...[
           Padding(
             padding: const EdgeInsets.only(left: 10, top: 12, right: 12),
             child: Container(
                 width: size.width,
                 decoration: BoxDecoration(
                   color: Colors.purple.shade400,
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 8, left: 10),
                       child: Text("Today's Activity", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B))),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 12, top: 8),
                       child: Row(
                         children: [
                           Container(
                             width: size.width*0.42,
                             decoration: BoxDecoration(
                                 color:  Color(0xFF4F46E5),
                                 borderRadius: BorderRadius.circular(0),
                                 border: Border.all(color: Colors.white, width: 2)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10, top: 8),
                                   child: Row(
                                     children: [
                                       Icon(Icons.login, size: 25, color:  Color(0xFFCDFF6B)), SizedBox(width: size.width*0.08),
                                       Text("Att. In", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                                     ],
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 15, top: 8),
                                   child: Text("Time", style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold, color: Colors.white)),
                                 )
                               ],
                             ),
                           ), SizedBox(width: size.width*0.045),
                           Container(
                             width: size.width*0.42,
                             decoration: BoxDecoration(
                                 color:  Color(0xFF4F46E5),
                                 borderRadius: BorderRadius.circular(0),
                                 border: Border.all(color: Colors.white, width: 2)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10, top: 8),
                                   child: Row(
                                     children: [
                                       Icon(Icons.logout, size: 25, color:  Color(0xFFCDFF6B)), SizedBox(width: size.width*0.08),
                                       Text("Att. Out", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                                     ],
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 15, top: 8),
                                   child: Text("Time", style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B))),
                                 )
                               ],
                             ),
                           )
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 12, top: 13),
                       child: Row(
                         children: [
                           Container(
                             width: size.width*0.34, height: size.height*0.052,
                             decoration: BoxDecoration(
                                 color:  Color(0xFF4F46E5),
                                 borderRadius: BorderRadius.circular(0),
                                 border: Border.all(color: Colors.white, width: 2)
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10, top: 8),
                                   child: Row(
                                     children: [
                                       Icon(Icons.update, size: 25, color:  Color(0xFFCDFF6B)), SizedBox(width: size.width*0.023),
                                       Text("Present", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ), SizedBox(width: size.width*0.045),
                           Row(
                             children: [
                               Container(
                                 width: size.width*0.48, height: size.height*0.052,
                                 decoration: BoxDecoration(
                                     color:  Color(0xFF4F46E5),
                                     borderRadius: BorderRadius.circular(0),
                                     border: Border.all(color: Colors.white, width: 2)
                                 ),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, top: 8),
                                       child: Row(
                                         children: [
                                           Icon(Icons.hourglass_bottom_sharp, size: 25, color:  Color(0xFFCDFF6B)), SizedBox(width: size.width*0.025),
                                           Text("Hours:-", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)), SizedBox(width: size.width*0.032),
                                           Text("00:00", style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold, color: Colors.purple.shade100))
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ), SizedBox(width: size.width*0.045),
                             ],
                           ),
                         ],
                       ),
                     ), SizedBox(height: size.height*0.022),
                   ],
                 )),
           )
          ],
           if(selectedTab ==1) ...[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 12, right: 12),
              child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Text("Monthly Activity", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B))),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color:  Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(0)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: size.width*0.018),
                              Icon(Icons.present_to_all, size: 25, color: Colors.white), SizedBox(width: size.width*0.045),
                              Text("Present Days:-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFFCDFF6B))), SizedBox(width: size.width*0.065),
                              Text("24", style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color:  Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(0)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: size.width*0.018),
                              Icon(Icons.close, size: 25, color: Colors.white), SizedBox(width: size.width*0.045),
                              Text("Absent Days:-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFFCDFF6B))), SizedBox(width: size.width*0.065),
                              Text("2", style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold, color: Colors.redAccent.shade100)),
                            ],
                          ),
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color:  Colors.lime.shade500,
                              borderRadius: BorderRadius.circular(0)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: size.width*0.018),
                              Icon(Icons.percent, size: 25, color:  Color(0xFF4F46E5)), SizedBox(width: size.width*0.045),
                              Text("Attendance Rate:-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.purple.shade500)), SizedBox(width: size.width*0.065),
                              Text("10%", style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold, color:  Color(0xFF4F46E5))),
                            ],
                          ),
                        ),
                      ), SizedBox(height: size.height*0.024),
                    ],
                  )),
            )
         ],
           Padding(
             padding: const EdgeInsets.only(left: 10, top: 12),
             child: Row(
               children: [
                 Icon(Icons.calendar_today, size: 25, color: Colors.purple.shade500), SizedBox(width: size.width*0.025),
                 Text("Daily Attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  Color(0xFF4F46E5))), SizedBox(width: size.width*0.15),
                 Container(
                   height: size.height*0.038, width: size.width*0.28,
                   padding: EdgeInsets.symmetric(horizontal: 12),
                   decoration: BoxDecoration(
                     color:  Color(0xFF4F46E5),
                     borderRadius: BorderRadius.circular(15)
                   ),
                   child: Row(
                     children: [
                       Icon(Icons.calendar_today, size: 22, color: Colors.white), SizedBox(width: size.width*0.038),
                       Text("Filter", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B)))
                     ],
                   ),
                 )
               ],
             ),
           ),
           Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DataTable(
                columnSpacing: 48, // 👈 better spacing
                headingRowHeight: 45,
                dataRowHeight: 50,

                /// HEADER STYLE
                headingRowColor: MaterialStateProperty.all(
                  Color(0xFF4F46E5),
                ),

                columns: [
                  DataColumn(label: Text("Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                  DataColumn(label: Text("In Time", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                  DataColumn(label: Text("Out Time", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                ],

                rows: [
                  DataRow(
                    color: MaterialStateProperty.all(Colors.grey.shade100), // 👈 row bg
                    cells: [

                      /// DATE
                      DataCell(
                        Text("15-04-2026", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple.shade400)),
                      ),

                      /// IN TIME
                      DataCell(
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Color(0xFF4F46E5)),
                            SizedBox(width: 5),
                            Text("11:11 AM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5))),
                          ],
                        ),
                      ),

                      /// OUT TIME
                      DataCell(
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.red),
                            SizedBox(width: 5),
                            Text("6:50 PM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}
