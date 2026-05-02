import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final sapd = TextEditingController(), sapm = TextEditingController();
  final _form = GlobalKey<FormState>();

  Widget _AdminIdentity () {
    final size = MediaQuery.of(context).size;
    return  Padding(
      padding: const EdgeInsets.only(left: 10, top: 12, right: 12),
      child: SingleChildScrollView(
        child: Container(
            width: size.width*0.95,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:  Color(0xFF4F46E5)
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
                            color: Colors.lime.shade200,
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
                                  color:  Color(0xFFCDFF6B),
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(color: Colors.black, width: 2)
                              ),
                              child: Text("Shubham Shah", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 10),
                          child: Text("Flutter Developer",  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.lime.shade200,
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
    );
  }

  Widget _staffDetails () {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 15, right: 12),
      child: Column(
        children: [
          InkWell(
            onTap: _SalaryForm,
            child: Card(
              color:  Color(0xFF4F46E5),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24, backgroundColor:  Color(0xFFCDFF6B),
                    child: Icon(CupertinoIcons.person_alt_circle, color:  Color(0xFF4F46E5)),
                  ),
                  title: Text("Manav Dodiya", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text("Emp. ID: E1258", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.w500, color: Color(0xFFCDFF6B))),
                  trailing: Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    color: Colors.white,
                    child: Text("• Present", style: TextStyle(fontSize: 14.8, fontWeight: FontWeight.bold, color:  Color(0xFF4F46E5))),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Show more", style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500)), SizedBox(width: size.width*0.02),
                Icon(CupertinoIcons.arrow_down_circle_fill, size: 22, color: Color(0xFF4F46E5))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _SalaryForm () {
    return showDialog(context: context, builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container( // 🎨 ENHANCED
                width: double.infinity,
                decoration: BoxDecoration(
                  color:  Color(0xFF4F46E5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24, backgroundColor:  Color(0xFFCDFF6B),
                            child: Icon(CupertinoIcons.person_alt_circle, color:  Color(0xFF4F46E5)),
                          ), SizedBox(width: 10),
                          Container(
                            height: 45, width: 12,
                            child: VerticalDivider(color: Colors.white, thickness: 4),
                          ), SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Name:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0.5)), SizedBox(width: 12),
                                  Text("Manav Dodiya", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Emp ID:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color:  Color(0xFFCDFF6B), letterSpacing: 0.5)), SizedBox(width: 12),
                                  Text("E1258", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:  Color(0xFFCDFF6B), letterSpacing: 0.5)),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ), SizedBox(height: 8),
              Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 158,
                              child: TextFormField(
                                controller: sapd,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Per Day", labelText: "Per Day Salary",
                                  prefixIcon: Icon(Icons.currency_rupee, size: 15),  filled: true, fillColor: Colors.grey.shade300,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red, width: 2)
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.black, width: 2)
                                  )
                                ),
                                validator: (val) {
                                  if(val!.isEmpty) return "Salary Required";
                                },
                              ),
                            ), SizedBox(width: 13),
                            SizedBox(
                              width: 160,
                              child: TextFormField(
                                controller: sapm,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Per Month", labelText: "Per Month Salary",
                                    prefixIcon: Icon(Icons.currency_rupee, size: 15),  filled: true, fillColor: Colors.grey.shade300,
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.red, width: 2)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black, width: 2)
                                    )
                                ),
                                validator: (val) {
                                  if(val!.isEmpty) return "Salary Required";
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
         backgroundColor: Color(0xFF4F46E5),
         title: Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFCDFF6B))),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
             _AdminIdentity(),
             Padding(
               padding: const EdgeInsets.only(left: 12, top: 10),
               child: Container(
                 padding: EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 12),
                   decoration: BoxDecoration(
                     color:  Colors.lime.shade300,
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(color: Color(0xFF4F46E5), width: 3)
                   ),
                   child: Text("Staff Details", style: TextStyle(fontSize: 16.8, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)))),
             ),
             _staffDetails()
        ],
      ),
    );
  }
}
