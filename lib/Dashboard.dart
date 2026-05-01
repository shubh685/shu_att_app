import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_track/Atte%20History.dart';
import 'package:team_track/Leave_History.dart';
import 'package:team_track/Log%20in.dart';

// ─── Theme Colors ────────────────────────────────────────────────────────────

class AppColors {
  static const Color primaryBg   = Color(0xFF0F172A);
  static const Color accent      = Color(0xFF38BDF8); // Sky Blue
  static const Color glassWhite  = Color(0x1AFFFFFF);
  static const Color textMain    = Colors.white;
  static const Color textDim     = Color(0xFF94A3B8);

  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
  );
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

// ... imports unchanged
class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  // ── ANIMATIONS ──
  AnimationController? _fadeCtrl;
  AnimationController? _slideCtrl;
  Animation<double>? _fadeAnim;
  Animation<Offset>? _slideAnim;
  String seleAtt = "Att.In", wStatus = "Completed", outReason = "• Time is Completed", leReason ="• Casual Leave";
  final con = TextEditingController(), co = TextEditingController(); DateTimeRange? dateRange, datSalary;
  final _form = GlobalKey<FormState>(), _form2 = GlobalKey<FormState>();
  final _form3 = GlobalKey<FormState>();
  int _step = 0; final primaryColor = const Color(0xFF4F46E5);
  final edN = TextEditingController(), edE = TextEditingController();
  String position = "Nursing";

  List<String> poList = [
    "Nursing", "Doctor",
  ];

  Widget _buildCardContent(int index, Size size) {
    switch (index) {
      case 0:
        return Column(
          children: [
            Expanded(   // 👈 THIS FIXES ALIGNMENT
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Color(0xFF4F46E5), size: 28),
                  SizedBox(width: 5),
                  SizedBox(
                    height: size.height * 0.06,
                    child: VerticalDivider(color: Colors.black, thickness: 2),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.logout, color: Color(0xFF4F46E5), size: 28),
                ],
              ),
            ),
            _bottomBar("Att. In / Out", size),
          ],
        );

      case 1:
        return Column(
          children: [
            Expanded(   // 👈 pushes content up
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 40, color: Colors.red),
                ],
              ),
            ),
            _bottomBar("Leave Form", size),
          ],
        );

      case 2:
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.currency_rupee_sharp, size: 40),
                ],
              ),
            ),
            _bottomBar("Salary Info.", size),
          ],
        );

      case 3:
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 40, color: Colors.grey.shade600),
                ],
              ),
            ),
            _bottomBar("Atte. History", size),
          ],
        );

      case 4:
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 40, color: Colors.grey.shade600),
                ],
              ),
            ),
            _bottomBar("Leave History", size),
          ],
        );

      case 5:
        return Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.profile_circled, size: 40, color: Colors.black),
                ],
              ),
            ),
            _bottomBar("Edit Profile", size),
          ],
        );

      default:
        return SizedBox();
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  _handleCard(int index, BuildContext context) {
    final size = MediaQuery.of(context).size;
    switch (index) {
      case 0:
        seleAtt = "IN";
        return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient( // 🎨 ENHANCED
                          colors: [Color(0xFFF0F4FF), Color(0xFFE8FFE8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Color(0xFF7C3AED),
                            width: 2.5),
                        boxShadow: [ // 🎨 ENHANCED
                          BoxShadow(
                            color: Color(0xFF4F46E5).withOpacity(0.18),
                            blurRadius: 24, spreadRadius: 2,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// HEADER
                          Container( // 🎨 ENHANCED
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Text("Daily Attendance",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5)),
                            ),
                          ),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Container(
                                width: size.width * 0.65,
                                height: size.height * 0.065,
                                decoration: BoxDecoration(
                                  color: Color(0xFF1A1A2E), // 🎨 ENHANCED
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(CupertinoIcons.person_alt_circle,
                                        color: Color(0xFFCDFF6B), size: 25),
                                    // 🎨 lime accent
                                    SizedBox(width: 10),
                                    Text("Employee ID:- ", style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                                    SizedBox(width: 6),
                                    Text("E1584", style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFCDFF6B))),
                                    // 🎨
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 12),
                                child: attendanceButton(
                                  label: "Att. In",
                                  icon: Icons.login,
                                  value: "IN",
                                  size: size,
                                  onTap: () {
                                    setStateDialog(() {
                                      seleAtt = "IN";
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 15, top: 12),
                                child: attendanceButton(
                                  label: "Att. Out",
                                  icon: Icons.logout,
                                  value: "OUT",
                                  size: size,
                                  onTap: () {
                                    setStateDialog(() {
                                      seleAtt = "OUT";
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          seleAtt == "IN" ? _attIn() : _attOut(setStateDialog),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );

      case 1:
        return showDialog(context: context, builder: (context) {
          return StatefulBuilder(
              builder: (context, void Function(void Function()) setState) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient( // 🎨 ENHANCED
                          colors: [Color(0xFFF0F4FF), Color(0xFFE8FFE8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container( // 🎨 ENHANCED
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade300, Colors.red],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Center(
                                child: Text("Absence Request", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Container(
                                  width: size.width * 0.65,
                                  height: size.height * 0.065,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4F46E5), // 🎨 ENHANCED
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(CupertinoIcons.person_alt_circle,
                                          color: Color(0xFFCDFF6B), size: 25),
                                      // 🎨 lime accent
                                      SizedBox(width: 10),
                                      Text("Employee ID:- ", style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                      SizedBox(width: 6),
                                      Text("E1584", style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFCDFF6B))),
                                      // 🎨
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, top: 12, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.red.shade300, Colors.red],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 1.5),
                                ),
                                child: Form(
                                  key: _form2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 12, top: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.logout, size: 28,
                                                color: Color(0xFFCDFF6B)), // 🎨
                                            SizedBox(width: 10),
                                            SizedBox(
                                                height: 25, width: 8,
                                                child: VerticalDivider(
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    thickness: 3)), // 🎨
                                            SizedBox(width: 10),
                                            Text("Type of Leave",
                                                style: TextStyle(fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .w500)) // 🎨
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, right: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient( // 🎨 ENHANCED
                                              colors: [
                                                Color(0xFF7C3AED),
                                                Color(0xFF9333EA)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                10), // 🎨
                                            border: Border.all(
                                                color: Colors.white.withOpacity(
                                                    0.5), width: 2), // 🎨
                                          ),
                                          child: DropdownButton<String>(
                                            value: leReason,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            icon: Icon(CupertinoIcons
                                                .chevron_down_circle,
                                                color: Color(0xFFCDFF6B)),
                                            // 🎨
                                            isExpanded: true,
                                            dropdownColor: Color(0xFF7C3AED),
                                            // 🎨 purple instead of red
                                            underline: SizedBox(),
                                            // 🎨 removes default underline
                                            items: [
                                              "• Casual Leave",
                                              "• Marriage Leave",
                                              "• Sick Leave",
                                              "• Maternity Leave",
                                              "• Paternity Leave",
                                              "• Study Leave",
                                              "• Half Day Leave",
                                              "• Earned Leave",
                                              "• Other",
                                            ].map((item) =>
                                                DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFCDFF6B),
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 16))))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                leReason = val!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 12, top: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.calendar_today, size: 25,
                                                color: Color(0xFFCDFF6B)),
                                            SizedBox(width: 10),
                                            SizedBox(
                                                height: 25, width: 8,
                                                child: VerticalDivider(
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    thickness: 3)), // 🎨
                                            SizedBox(width: 10),
                                            Text("From Date to End Date",
                                                style: TextStyle(fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .w500)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, right: 15),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTimeRange? range = await showDateRangePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              // today
                                              lastDate: DateTime(3000),
                                              initialDateRange: DateTimeRange(
                                                start: DateTime.now(),
                                                end: DateTime.now().add(
                                                    Duration(
                                                        days: 2)), // default till 22-04-2026 type
                                              ),
                                            );

                                            if (range != null) {
                                              setState(() {
                                                dateRange = range;
                                              });
                                            }
                                          },
                                          child: Container(
                                              height: 85,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient( // 🎨 ENHANCED
                                                  colors: [
                                                    Color(0xFF7C3AED),
                                                    Color(0xFF9333EA)
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius
                                                    .circular(10), // 🎨
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    width: 2), // 🎨
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 5),
                                                    child: Column(
                                                      children: [
                                                        Text(dateRange == null
                                                            ? "Select Date Range"
                                                            : "${formatDate(
                                                            dateRange!.start)}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Color(
                                                                    0xFFCDFF6B))),
                                                        Text("to",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Color(
                                                                    0xFFCDFF6B))),
                                                        Text(dateRange == null
                                                            ? "Select Date Range"
                                                            : "${formatDate(
                                                            dateRange!.end)}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Color(
                                                                    0xFFCDFF6B))),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: size.width * 0.25),
                                                  Icon(Icons.calendar_today,
                                                      size: 25,
                                                      color: Color(0xFFCDFF6B))
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 12, top: 8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.description, size: 28,
                                                color: Color(0xFFCDFF6B)), // 🎨
                                            SizedBox(width: 10),
                                            SizedBox(
                                                height: 25, width: 8,
                                                child: VerticalDivider(
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    thickness: 3)), // 🎨
                                            SizedBox(width: 10),
                                            Text("Reason For Leave",
                                                style: TextStyle(fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .w500)) // 🎨
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 12, top: 10),
                                        child: SizedBox(
                                          height: 45,
                                          child: TextFormField(
                                            controller: co,
                                            decoration: InputDecoration(
                                                hintText: "Reason",
                                                suffixIcon: Icon(
                                                  Icons.description,
                                                  color: Colors.purple
                                                      .shade500,),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .shade500),
                                                filled: true,
                                                fillColor: Colors.white,
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(12),
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 2)
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color(
                                                            0xFFCDFF6B),
                                                        width: 2)
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10,
                                            right: 15,
                                            top: 15,
                                            bottom: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            // --- CANCEL BUTTON (Subtle Style) ---
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.purple.shade500,
                                                  // Soft neutral background
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey[300]!,
                                                      width: 1.5),
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(horizontal: 24,
                                                    vertical: 10),
                                                child: const Text("Cancel",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        color: Color(
                                                            0xFFCDFF6B))),
                                              ),
                                            ),

                                            // --- SUBMIT BUTTON (Matches your Palette) ---
                                            InkWell(
                                              onTap: () {
                                                // Add your submission logic here
                                              },
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.lime.shade200,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.purple.shade500, width: 3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0xFF4F46E5)
                                                          .withOpacity(0.3),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                          0, 4),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(horizontal: 32,
                                                    vertical: 10),
                                                child: const Text("Submit",
                                                  style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold, color: Colors.purple,),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        });

      case 2:
        return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {

            final size = MediaQuery.of(context).size; // ✅ IMPORTANT

            String selectedMonth = "January";

            List<String> months = [
              "January","February","March","April","May","June",
              "July","August","September","October","November","December"
            ];

            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// HEADER
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade400, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text("Salary Info.", style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ), SizedBox(height: size.height * 0.02),

                      /// EMPLOYEE ID
                      Row(
                        children: [
                          Icon(Icons.person, size: size.width * 0.06),
                          SizedBox(width: 5),
                          SizedBox(
                            height: 20,
                            child: VerticalDivider(color: Colors.purple, thickness: 3),
                          ),
                          SizedBox(width: 5),
                          Text("Employee ID:- ", style: TextStyle(fontSize: size.width * 0.045)),
                          Text("E1584", style: TextStyle(fontSize: size.width * 0.045, color: Colors.purple, fontWeight: FontWeight.bold)),
                        ],
                      ), SizedBox(height: size.height * 0.02),

                      /// MONTH DROPDOWN
                      Text("Select Month", style: TextStyle(fontSize: size.width * 0.04)),
                      SizedBox(height: 8),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade100, Colors.purple.shade100],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedMonth,
                            isExpanded: true,
                            items: months.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value!;
                              });
                            },
                          ),
                        ),
                      ), SizedBox(height: size.height * 0.02),

                      /// COUNTS ROW
                      Row(
                        children: [

                          /// PRESENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Present", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade100, Colors.purple.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("24",
                                      style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

                          /// ABSENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Absent", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("2", style: TextStyle(color: Colors.white, fontSize: size.width * 0.045)),
                                ),
                              ],
                            ),
                          ),

                          /// HOURS
                          Expanded(
                            child: Column(
                              children: [
                                Text("Hours", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade100, Colors.purple.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("120", style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), SizedBox(height: size.height * 0.02),

                      /// SALARY
                      Row(
                        children: [
                          Icon(Icons.currency_rupee),
                          SizedBox(width: 5),
                          Text("Total Salary: ", style: TextStyle(fontSize: size.width * 0.045)),
                          Text("13000", style: TextStyle(fontSize: size.width * 0.045, color: Colors.purple, fontWeight: FontWeight.bold)),
                        ],
                      ), SizedBox(height: size.height * 0.02),

                      /// Salary Counts
                      Row(
                        children: [

                          /// PRESENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Salary Per Hours", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade100, Colors.purple.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("25",
                                      style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

                          /// ABSENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Salary Per Days", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("450", style: TextStyle(color: Colors.white, fontSize: size.width * 0.045)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), SizedBox(height: size.height * 0.02),

                      /// Payment Details
                      Center(
                        child: Column(
                          children: [
                            Text("Payment Status", style: TextStyle(fontSize: size.width * 0.035)),
                            SizedBox(height: 5),
                            Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade100, Colors.purple.shade100],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("• Successful", style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color:  Color(0xFF4F46E5) )),
                            ),
                          ],
                        ),
                      ), SizedBox(height: size.height * 0.02),
                      Row(
                        children: [

                          /// PRESENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Payment Date", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade100, Colors.purple.shade100],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("12-04-2026", style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

                          /// ABSENT
                          Expanded(
                            child: Column(
                              children: [
                                Text("Payment Mode", style: TextStyle(fontSize: size.width * 0.035)),
                                SizedBox(height: 5),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text("Cash", style: TextStyle(color: Colors.white, fontSize: size.width * 0.045)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), SizedBox(height: size.height * 0.02),

                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width*0.8, height: size.height*0.04,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade400,
                            borderRadius: BorderRadius.circular(12)
                          ),
                            child: Center(child: Text("Generate PDF", style: TextStyle(fontSize: size.width * 0.048, color: Colors.white)))),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // --- CANCEL BUTTON (Subtle Style) ---
                            InkWell(
                              onTap: () { Navigator.pop(context); },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade500, // Soft neutral background
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFCDFF6B))),
                              ),
                            ),

                            // --- SUBMIT BUTTON (Matches your Palette) ---
                            InkWell(
                              onTap: () {
                                // Add your submission logic here
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lime.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.purple.shade500, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple,),),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );

      case 3 :
        Navigator.push(context, MaterialPageRoute(builder: (context) => Atte_History()));
   
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveHistory()));

      case 5:
        return showModalBottomSheet(context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
            return StatefulBuilder(builder: (context, setStateST) {
                  return Form(
                    key: _form3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          /// HEADER
                          Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                          decoration: BoxDecoration(
                            color: Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.person_alt_circle, size: 30, color: Colors.white), SizedBox( height: size.height*0.04,width: size.width*0.065,
                                  child: VerticalDivider(color: Colors.lime, thickness: 5)),
                                  Text("Edit Profile.", style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                  height: 110, width: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.lime.shade100,
                                      border: Border.all(color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(0)
                                  ),
                                  child: Icon(CupertinoIcons.profile_circled, color: Color(0xFF4F46E5), size: 50),
                                ),
                              ),
                            ],
                          ),
                        ), SizedBox(height: size.height * 0.02),

                          Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12),
                          child: Container(
                            height: size.height*0.05,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.lime.shade300, width: 2)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.badge_sharp, color: Colors.white), SizedBox(width: size.width*0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Employee ID:-", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color:  Color(0xFFE8FFB5))), SizedBox(width: size.width*0.023),
                                    Text("E1584", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),SizedBox(height: size.height*0.02),

                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Full Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF4F46E5))),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                            child: TextFormField(
                              controller: edN,
                              decoration: InputDecoration(
                                hintText: "Enter Name", filled: true, fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red)
                                )
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 8),
                            child: Text("Email ID", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF4F46E5))),
                          ),

                          Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                          child: TextFormField(
                            controller: edN,
                            decoration: InputDecoration(
                                hintText: "Enter Email", filled: true, fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red)
                                )
                            ),
                          ),
                        ),

                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                            child: Text("Select Position", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF4F46E5))),
                          ),

                          Padding(
                             padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                             child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                 colors: [Colors.blue.shade100, Colors.purple.shade100],
                                ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.purple),
                             ),
                             child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: position,
                                isExpanded: true,
                                items: poList.map((month) {
                                  return DropdownMenuItem(
                                    value: month,
                                    child: Text(month),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    position = value!;
                                  });
                                },
                              ),
                                                           ),
                                                         ),
                           ),

                          Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // --- CANCEL BUTTON (Subtle Style) ---
                              InkWell(
                                onTap: () { Navigator.pop(context); },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade500, // Soft neutral background
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFCDFF6B))),
                                ),
                              ),

                              // --- SUBMIT BUTTON (Matches your Palette) ---
                              InkWell(
                                onTap: () {
                                  // Add your submission logic here
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lime.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.purple.shade500, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4F46E5).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                  child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple,),),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
            });
        });
    }

  }

  Widget _attIn() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 15, right: 12, bottom: 10),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(                           // 🎨 ENHANCED
              colors: [Color(0xFF4F46E5), Color(0xFF6D5CE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 12, top: 8),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.home, size: 28, color: Color(0xFFCDFF6B)),  // 🎨
                          SizedBox(width: 10),
                          SizedBox(
                              height: 25, width: 8,
                              child: VerticalDivider(color: Colors.white.withOpacity(0.6), thickness: 3)),  // 🎨
                          SizedBox(width: 10),
                          Text("Location", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500))  // 🎨
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 12, top: 8),
                      child: Container(
                        height: size.height * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),           // 🎨
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFE9D5FF), width: 1),  // 🎨 subtle
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 8),
                                child: Text("Find Location",
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(CupertinoIcons.location_circle, size: 25, color: Color(0xFF4F46E5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10, top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFC084FC), width: 2),  // 🎨 lighter purple
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.date_range_outlined, size: 22, color: Color(0xFF4F46E5)),  // 🎨
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Att. In Date",
                                        style: TextStyle(fontSize: 14, color: Color(0xFF7C3AED))),   // 🎨
                                    SizedBox(height: 2),
                                    Text("19-04-2026",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFC084FC), width: 2),  // 🎨
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Icon(Icons.access_time_rounded, size: 22, color: Color(0xFF4F46E5)),  // 🎨
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Att. In Time",
                                        style: TextStyle(fontSize: 14, color: Color(0xFF7C3AED))),   // 🎨
                                    SizedBox(height: 2),
                                    Text("10:50 AM",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // --- CANCEL BUTTON (Subtle Style) ---
                          InkWell(
                            onTap: () { Navigator.pop(context); },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.purple.shade500, // Soft neutral background
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[300]!, width: 1.5),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFCDFF6B))),
                            ),
                          ),

                          // --- SUBMIT BUTTON (Matches your Palette) ---
                          InkWell(
                            onTap: () {
                              // Add your submission logic here
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lime.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.purple.shade500, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                              child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple,),),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attOut(void Function(void Function()) setStateDialog) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 15, right: 12, bottom: 10),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(                         // 🎨 ENHANCED
              colors: [Color(0xFF4F46E5), Color(0xFF6D5CE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [

                        /// ── LOCATION SECTION ──
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12, top: 8),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.home, size: 28, color: Color(0xFFCDFF6B)),  // 🎨 lime accent
                              SizedBox(width: 10),
                              SizedBox(
                                height: 25, width: 8,
                                child: VerticalDivider(color: Colors.white.withOpacity(0.6), thickness: 3),  // 🎨
                              ),
                              SizedBox(width: 10),
                              Text("Location",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),  // 🎨
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12, top: 8),
                          child: Container(
                            height: size.height * 0.045,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),             // 🎨
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFFE9D5FF), width: 1),  // 🎨 subtle purple tint
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 8),
                                    child: Text("Find Location",
                                        style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(CupertinoIcons.location_circle, size: 25, color: Color(0xFF4F46E5)),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// ── DATE / TIME CHIPS ──
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10, top: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFC084FC), width: 2),  // 🎨 lighter purple
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Icon(Icons.date_range_outlined, size: 22, color: Color(0xFF4F46E5)),  // 🎨
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Att. Out Date",
                                            style: TextStyle(fontSize: 14, color: Color(0xFF7C3AED))),   // 🎨
                                        SizedBox(height: 2),
                                        Text("19-04-2026",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.only(top: 8, right: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFC084FC), width: 2),  // 🎨
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Icon(Icons.access_time_rounded, size: 22, color: Color(0xFF4F46E5)),  // 🎨
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Att. Out Time",
                                            style: TextStyle(fontSize: 14, color: Color(0xFF7C3AED))),   // 🎨
                                        SizedBox(height: 2),
                                        Text("07:00 PM",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ── WORK STATUS SECTION ──
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 12, top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.task_alt, size: 28, color: Color(0xFFCDFF6B)),  // 🎨
                              SizedBox(width: 10),
                              SizedBox(
                                height: 25, width: 8,
                                child: VerticalDivider(color: Colors.white.withOpacity(0.6), thickness: 3),  // 🎨
                              ),
                              SizedBox(width: 10),
                              Text("Work Status",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),  // 🎨
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        /// ── RADIO BUTTONS ──
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              width: size.width * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFF87171), width: 2),  // 🎨 soft red
                              ),
                              child: RadioMenuButton(
                                value: "Completed",
                                groupValue: wStatus,
                                onChanged: (val) {
                                  setStateDialog(() { wStatus = val!; });
                                },
                                style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                child: Text("Completed",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),  // 🎨
                              ),
                            ),
                            Container(
                              width: size.width * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFF87171), width: 2),  // 🎨
                              ),
                              child: RadioMenuButton(
                                value: "Half",
                                groupValue: wStatus,
                                onChanged: (val) {
                                  setStateDialog(() { wStatus = val!; });
                                },
                                style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                child: Text("Half",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),  // 🎨
                              ),
                            ),
                            Container(
                              width: size.width * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFF87171), width: 2),  // 🎨
                              ),
                              child: RadioMenuButton(
                                value: "Pending",
                                groupValue: wStatus,
                                onChanged: (val) {
                                  setStateDialog(() { wStatus = val!; });
                                },
                                style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                child: Text("Pending",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),  // 🎨
                              ),
                            ),
                          ],
                        ),

                        /// ── PENDING REASON (conditional) ──
                        if (wStatus == "Pending") ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
                                child: Text("Reason For Pending Work",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),  // 🎨 w500
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
                                child: TextFormField(
                                  controller: con,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: "Reason",
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(Icons.task_alt, color: Color(0xFF7C3AED)),  // 🎨
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(           // 🎨 ENHANCED
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFF4F46E5), width: 2),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFC084FC)),  // 🎨
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) { return "Enter Your reason"; }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],

                        /// ── DROPDOWN ──
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(                           // 🎨 ENHANCED
                                colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),           // 🎨
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),  // 🎨
                            ),
                            child: DropdownButton<String>(
                              value: outReason,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              icon: Icon(CupertinoIcons.chevron_down_circle, color: Color(0xFFCDFF6B)),  // 🎨
                              isExpanded: true,
                              dropdownColor: Color(0xFF7C3AED),                  // 🎨 purple instead of red
                              underline: SizedBox(),                             // 🎨 removes default underline
                              items: [
                                "• Office Work Completed",
                                "• Medical Reason",
                                "• Time is Completed",
                                "• Overtime",
                                "• Other",
                              ].map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: TextStyle(
                                        color: Color(0xFFCDFF6B),               // 🎨 lime text
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              )).toList(),
                              onChanged: (val) {
                                setStateDialog(() { outReason = val!; });
                              },
                            ),
                          ),
                        ),

                        /// ── ACTION BUTTONS ──
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // --- CANCEL BUTTON (Subtle Style) ---
                              InkWell(
                                onTap: () { Navigator.pop(context); },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade500, // Soft neutral background
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFCDFF6B))),
                                ),
                              ),

                              // --- SUBMIT BUTTON (Matches your Palette) ---
                              InkWell(
                                onTap: () {
                                  // Add your submission logic here
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lime.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.purple.shade500, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4F46E5).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                                  child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple,),),
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(String title, Size size) {
    return Container(
      width: double.infinity,   // 👈 FULL WIDTH (touch border)
      height: size.height * 0.035,  // 👈 responsive height
      decoration: BoxDecoration(
        color: Colors.purple.shade400,
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.width * 0.03,  // responsive text
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget attendanceButton({
    required String label,
    required IconData icon,
    required String value,
    required Size size,
    required VoidCallback onTap, // 👈 NEW
  }) {
    bool isSelected = seleAtt == value;

    return InkWell(
      onTap: onTap, // 👈 use passed function
      child: Container(
        height: size.height * 0.055,
        width: size.width * 0.28,
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey.shade400,
        ),
        child: Row(
          children: [
            SizedBox(width: 8),
            Icon(icon, size: 25, color: Colors.white),
            SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Colors.lime.shade200 : Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String value,
      Size size, {
        Color? titleColor,
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 12, right: 15),
      child: Container(
        width: size.width * 0.3,
        height: size.height * 0.09,
        decoration: BoxDecoration(
          color: Colors.lime.shade300,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: size.width * 0.03, color: titleColor ?? Colors.black,  )),
            Text(value, style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {

    final steps = ['Page 1', 'Page2 ', 'Page 3', 'Page 4'];

    return Row(
      children: List.generate(steps.length, (i) {
        final active = i == _step;
        // ✅ FIX: Wrap the Column in Expanded directly as a Row child —
        // no extra Container/Padding wrapping Expanded.
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ FIX: Use a plain Container here — no Expanded inside Column
              Container(
                height: 25, width: 65,
                color: i <= _step ? primaryColor : Colors.grey[300],
                child:  Center(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      color: active ? Color(0xFFCDFF6B) : Colors.grey, fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAllPage (void Function(void Function()) setStateAP) {
    switch(_step) {
      case 0:
        return _firstPage(setStateAP);

      case 1:
        return _secondPage(setStateAP);

      case 2:
        return _ThirdPage(setStateAP);

      case 3:
        return _FourthPage(setStateAP);

      default:
        return SizedBox();
    }
  }

  Widget _firstPage(void Function(void Function()) setState) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Att. In / Out Card",
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCDFF6B))),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Column(
                      children: [
                        Text(
                          "• Open the Att. In card to submit your attendance when you enter the office. It will fetch your current location automatically.",
                          style: TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "• Open the Att. Out card to submit your attendance when you leave the office or work from another location. It will fetch your current location automatically. Also, mention your work status and the reason for being out of the office.",
                          style: TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Leave Form",
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCDFF6B))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Text(
                    "• In the leave form, select your leave type, enter how many days you need, and write the reason.",
                    style:
                    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 15, bottom: 8),
          child: InkWell(
              onTap: () {
                setState(() {
                  _step = 1;
                });
              },
              child: Container(
                  padding: EdgeInsets.only(left: 12, right: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text("Continue >>",
                          style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))))),
        )
      ],
    );
  }

  Widget _secondPage(void Function(void Function()) setStateSP) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Salary Info.",
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCDFF6B))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• This screen allows you to view your salary details. First, select the required month to see your information.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• After selecting the month, you can check your total present days, absent days, and working hours (including daily hours).",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• You can also view your total monthly salary and payment status, including payment date and mode (Cash, GPay, or Bank Transfer).",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• You can download the PDF for full details. If you find any mistake, check it on your phone and report it to your boss.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),

        /// Back Button Row
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            onTap: () {
              setStateSP(() {
                _step = 0;
              });
            },
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF4F46E5), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white)),
                SizedBox(width: size.width * 0.025),
                Text("Back to Page 1", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)))
              ],
            ),
          ),
        ),
        SizedBox(height: 8),

        /// Continue Button
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 15, bottom: 8),
          child: InkWell(
              onTap: () {
                setStateSP(() {
                  _step = 2;
                });
              },
              child: Container(
                  padding: EdgeInsets.only(left: 12, right: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text("Continue >>", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.bold, color: Colors.white))))),
        )
      ],
    );
  }

  Widget _ThirdPage(void Function(void Function()) setStateS) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Att. History.",
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCDFF6B))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• This screen shows your attendance history along with your Name, Employee ID, and Current Date.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• In Today's Activity, you can check your Attendance In and Out time, Present/Absent status, and Total Working Hours.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• In Monthly Activity, you can view Total Present Days and Absent Days for the selected month (excluding Sundays and holidays).",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• You can also see the overall attendance summary and total working hours for the entire month.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• Use the Filter option to select specific dates and view detailed attendance records.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),

        /// Back Button Row
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            onTap: () {
              setStateS(() {
                _step = 1;
              });
            },
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF4F46E5), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white)),
                SizedBox(width: size.width * 0.025),
                Text("Back to Page 2", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)))
              ],
            ),
          ),
        ),
        SizedBox(height: 8),

        /// Continue Button
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 15, bottom: 8),
          child: InkWell(
              onTap: () {
                setStateS(() {
                  _step = 3;
                });
              },
              child: Container(
                  padding: EdgeInsets.only(left: 12, right: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text("Continue >>",
                          style: TextStyle(
                              fontSize: 15.8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))))),
        )
      ],
    );
  }

  Widget _FourthPage(void Function(void Function()) setStateT) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Leave History", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFFCDFF6B))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• This screen shows your Leave History with Employee ID and allows you to search leave by type.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• You can view Total, Approved, and Pending leave requests, and filter them using All, Pending, or Approved options.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "• Each leave record shows leave type, date range, status, and reason provided for the leave request.",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 10),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF4F46E5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Text("Edit Profile", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Text(
                    "• In the Edit Profile section, you can enter and update your Name, Email ID, Profile Photo, and Position.",
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        /// Back Button Row
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            onTap: () {
              setStateT(() {
                _step = 2;
              });
            },
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF4F46E5), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white)),
                SizedBox(width: size.width * 0.025),
                Text("Back to Page 3", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)))
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 15, right: 12, top: 11.5, bottom: 8),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              setStateT(() {
                _step = 0;
              });
            },
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 8),
              decoration: BoxDecoration(
                color: Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red, width: 2)
              ),
              child: Center(child: Text("Got It", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B)))),
            ),
          ),
        )
      ],
    );
  }


  // Update build method background to Light Theme
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor:Colors.purple.shade600,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                        return Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Color(0xFF7C3AED), width: 2.5),

                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// HEADER
                                Container( // 🎨 ENHANCED
                                  width: double.infinity, height: size.height*0.072,
                                  decoration: BoxDecoration(
                                    color: Colors.lime.shade400,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("App Guide", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)), SizedBox(width: size.width*0.42),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _step = 0;
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 15, backgroundColor: Colors.red,
                                            child: Icon(Icons.close, color:  Color(0xFFCDFF6B), size: 23)),
                                      )
                                    ],
                                  ),
                                ), SizedBox(height: 10),

                                if (_step <= 3) Padding(
                                  padding: const EdgeInsets.only(left: 12.5, right: 12),
                                  child: _buildStepIndicator(),
                                ),

                                (_fadeAnim == null || _slideAnim == null)
                                    ? _buildAllPage(setState) : FadeTransition(
                                  opacity: _fadeAnim!,
                                  child: SlideTransition(
                                    position: _slideAnim!,
                                    child: _buildAllPage(setState),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    );
                  });
                });
              },
              child: Container(
                  width: 35, height: 35,
                  decoration: BoxDecoration(
                      color: Colors.lime.shade200, borderRadius: BorderRadius.circular(0), border: Border.all(color: Colors.black)
                  ),
                  child: Icon(Icons.info_outline, color: Colors.black, size: 25)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                showDialog(context: context, barrierDismissible: true, builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF4F46E5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             const SizedBox(height: 12),
                             Container(
                               height: 45, width: 60,
                               decoration: BoxDecoration(
                                 color: Colors.lime.shade200,
                               ),
                               child: Icon(Icons.logout, size: 35),
                             ),
                             const SizedBox(height: 12),
                             const Text("Log Out", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), SizedBox(height: 15),
                             Text("Confirm to Log Out ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lime.shade200)),
                             Padding(
                               padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 12),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   InkWell(
                                     onTap: () {
                                       Navigator.pop(context);
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: Colors.red,
                                         border: Border.all(color: Colors.lime, width: 2)
                                       ),
                                         child: Text("Cancel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                                   ),
                                   InkWell(
                                     onTap: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                     },
                                     child: Container(
                                         decoration: BoxDecoration(
                                             color: Colors.red,
                                             border: Border.all(color: Colors.lime, width: 2)
                                         ),
                                         child: Text("Confirm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                                   ),
                                 ],
                               ),
                             )
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
              child: Container(
                width: 35, height: 35,
                decoration: BoxDecoration(
                  color: Colors.lime.shade200, borderRadius: BorderRadius.circular(0), border: Border.all(color: Colors.black)
                ),
                  child: Icon(Icons.login, color: Colors.black, size: 25)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 12, right: 12),
              child: SingleChildScrollView(
                child: Container(
                  width: size.width*0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(colors: [
                      Colors.purple.shade400, Colors.purple.shade300
                    ])
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(0),
                                border: Border.all(color: Colors.black, width: 2)
                              ),
                              child: Text("Your Info.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(color: Colors.black, width: 2)
                                  ),
                                  child: Text("• Good Afternoon", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                                height: 110, width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.lime.shade100,
                                  border: Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(0)
                                ),
                                child: Icon(CupertinoIcons.profile_circled, color: Color(0xFF4F46E5), size: 50),
                            ),
                          ), SizedBox(width: 10),
                          Container(
                            height: 115, width: 8,
                            child: VerticalDivider(color: Colors.white, thickness: 4),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 8),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.lime.shade100,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(color: Colors.black, width: 2)
                                  ),
                                    child: Text("Shubham Shah", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 10),
                                child: Text("Flutter Developer",  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(color: Colors.black, width: 2)
                                  ),
                                  child: Text("Time: 10:57 PM", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  )
                ),
              ),
            ), SizedBox(height: size.height*0.015),
            Row(
              children: [
                Expanded(child: _infoCard("Employee ID", "E1584", size, titleColor: Colors.purple.shade500)),
                SizedBox(width: 8),
                Expanded(child: _infoCard("Attendance Status", "• Present", size, valueColor: Colors.indigo, titleColor: Colors.purple.shade500)),
                SizedBox(width: 8),
                Expanded(child: _infoCard("Working Days", "• 22/30", size, titleColor: Colors.indigo, valueColor: Colors.purple)),
              ],
            ), SizedBox(height: size.height*0.011),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 8),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0xFF4F46E5),
                    border: Border.all(color: Colors.red, width: 2)
                ),
                child: Text("Move to All Pages", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            Wrap(
              spacing: 15,       // horizontal space between items
              runSpacing: 8,    // vertical space between rows
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, right: 10),
                  child: InkWell(
                    onTap: () => _handleCard(index, context),
                    child: Container(
                      width: size.width * 0.25,
                      height: size.height * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.lime.shade200,
                        border: Border.all(color: Colors.black, width: 3.3),
                      ),
                      child: _buildCardContent(index, size),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      )
    );
  }
}