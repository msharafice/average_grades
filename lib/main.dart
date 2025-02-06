import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'محاسبه معدل',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GPAHomePage(),
    );
  }
}

class GPAHomePage extends StatefulWidget {
  @override
  _GPAHomePageState createState() => _GPAHomePageState();
}

class _GPAHomePageState extends State<GPAHomePage> {
  List<TextEditingController> nameControllers = [TextEditingController()];
  List<TextEditingController> gradeControllers = [TextEditingController()];
  List<TextEditingController> unitControllers = [TextEditingController()];

  double gpa = 0.0;

  // لیست FocusNode ها برای هر فیلد
  List<FocusNode> nameFocusNodes = [FocusNode()];
  List<FocusNode> gradeFocusNodes = [FocusNode()];
  List<FocusNode> unitFocusNodes = [FocusNode()];

  // متغیر برای نگهداری فیلدی که فوکوس دارد
  int? focusedFieldIndex;

  void _addRow() {
    setState(() {
      nameControllers.add(TextEditingController());
      gradeControllers.add(TextEditingController());
      unitControllers.add(TextEditingController());

      nameFocusNodes.add(FocusNode());
      gradeFocusNodes.add(FocusNode());
      unitFocusNodes.add(FocusNode());
    });
  }

  void _calculateGPA() {
    double totalWeighted = 0;
    int totalUnits = 0;

    for (int i = 0; i < nameControllers.length; i++) {
      double? grade = double.tryParse(gradeControllers[i].text);
      int? units = int.tryParse(unitControllers[i].text);

      if (grade != null && units != null) {
        totalWeighted += grade * units;
        totalUnits += units;
      }
    }

    setState(() {
      gpa = totalUnits == 0 ? 0.0 : totalWeighted / totalUnits;
    });
  }

  // این تابع فوکوس را فقط روی فیلدی که کاربر در حال تعامل است قرار می‌دهد
  void _setFocus(int index, String field) {
    // غیرفعال کردن فوکوس همه فیلدها
    for (int i = 0; i < nameFocusNodes.length; i++) {
      nameFocusNodes[i].unfocus();
      gradeFocusNodes[i].unfocus();
      unitFocusNodes[i].unfocus();
    }

    // فعال کردن فوکوس فیلد جدید
    if (field == 'name') {
      nameFocusNodes[index].requestFocus();
    } else if (field == 'grade') {
      gradeFocusNodes[index].requestFocus();
    } else if (field == 'unit') {
      unitFocusNodes[index].requestFocus();
    }

    setState(() {
      focusedFieldIndex = index; // فیلدی که فوکوس دارد ذخیره می‌شود
    });
  }

  InputDecoration _customInputDecoration(String hint, FocusNode focusNode) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: focusNode.hasFocus ? Colors.white : Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
          title: Text('محاسبه معدل'), backgroundColor: Color(0xFF1976D2)),
      body: GestureDetector(
        // این بخش باعث می‌شود که اگر کاربر خارج از فیلدها کلیک کند، فوکوس از فیلدها برداشته شود
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // غیرفعال کردن فوکوس
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Center(
                          child: Text('حذف',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)))),
                  Expanded(
                      child: Center(
                          child: Text('واحد',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)))),
                  Expanded(
                      child: Center(
                          child: Text('نمره',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)))),
                  Expanded(
                      child: Center(
                          child: Text('درس',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)))),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: nameControllers.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        // دکمه حذف برای هر ردیف
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                nameControllers.removeAt(index);
                                gradeControllers.removeAt(index);
                                unitControllers.removeAt(index);
                                nameFocusNodes.removeAt(index);
                                gradeFocusNodes.removeAt(index);
                                unitFocusNodes.removeAt(index);
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        // فیلد تعداد واحد با کیبورد عددی
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                if (hasFocus) {
                                  _setFocus(index,
                                      'unit'); // فوکوس را روی واحد فعال می‌کنیم
                                }
                              });
                            },
                            child: TextField(
                              controller: unitControllers[index],
                              decoration: _customInputDecoration(
                                  'تعداد واحد', unitFocusNodes[index]),
                              keyboardType: TextInputType.number,
                              focusNode: unitFocusNodes[index],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // فیلد نمره با کیبورد عددی
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                if (hasFocus) {
                                  _setFocus(index,
                                      'grade'); // فوکوس را روی نمره فعال می‌کنیم
                                }
                              });
                            },
                            child: TextField(
                              controller: gradeControllers[index],
                              decoration: _customInputDecoration(
                                  'نمره', gradeFocusNodes[index]),
                              keyboardType: TextInputType.number,
                              focusNode: gradeFocusNodes[index],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // فیلد نام درس با کیبورد پیش‌فرض
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                if (hasFocus) {
                                  _setFocus(index,
                                      'name'); // فوکوس را روی نام درس فعال می‌کنیم
                                }
                              });
                            },
                            child: TextField(
                              controller: nameControllers[index],
                              decoration: _customInputDecoration(
                                  'نام درس', nameFocusNodes[index]),
                              focusNode: nameFocusNodes[index],
                              keyboardType:
                                  TextInputType.text, // کیبورد پیش‌فرض
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addRow,
                icon: Icon(Icons.add),
                label: Text('افزودن ردیف'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateGPA,
                child: Text('محاسبه'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'معدل کل: ${gpa.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
