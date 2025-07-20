import 'package:flutter/material.dart';

class GPAHomePage extends StatefulWidget {
  const GPAHomePage({super.key});

  @override
  _GPAHomePageState createState() => _GPAHomePageState();
}

class _GPAHomePageState extends State<GPAHomePage> {
  List<TextEditingController> nameControllers = [TextEditingController()];
  List<TextEditingController> gradeControllers = [TextEditingController()];
  List<TextEditingController> unitControllers = [TextEditingController()];

  double gpa = 0.0;
  String errorMessage = "نتیجه محاسبه در اینجا نمایش داده میشود"; // متن پیش‌فرض

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
    bool hasEmptyField = false;

    // بررسی اینکه آیا همه فیلدها پر شده‌اند یا خیر
    for (int i = 0; i < nameControllers.length; i++) {
      double? grade = double.tryParse(gradeControllers[i].text);
      int? units = int.tryParse(unitControllers[i].text);

      // اگر هیچ کدام از فیلدها وارد نشده باشد
      if (nameControllers[i].text.isEmpty || grade == null || units == null) {
        hasEmptyField = true;
        break;
      }

      totalWeighted += grade * units;
      totalUnits += units;
    }

    setState(() {
      if (hasEmptyField) {
        errorMessage = "مقادیر مورد نیاز را وارد نکرده اید"; // نمایش پیغام خطا
      } else {
        gpa = totalUnits == 0 ? 0.0 : totalWeighted / totalUnits;
        errorMessage =
            "معدل: ${gpa.toStringAsFixed(2)}"; // نمایش معدل محاسبه‌شده
      }
    });
  }

  InputDecoration _customInputDecoration(String hint, FocusNode focusNode) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Color(0xFFD7D7D7),
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
      backgroundColor: Color(0xFF273F4F),
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'محاسبه معدل',
            style: TextStyle(color: Color(0xFFFE7743)),
          ),
          backgroundColor: Colors.transparent),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // غیرفعال کردن فوکوس
        },
        child: SafeArea(
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
                                    color: Color(0xFFFE7743))))),
                    Expanded(
                        child: Center(
                            child: Text('واحد',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFE7743))))),
                    Expanded(
                        child: Center(
                            child: Text('نمره',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFE7743))))),
                    Expanded(
                        child: Center(
                            child: Text('درس',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFE7743))))),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: nameControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xFFD7D7D7),
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
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    if (hasFocus) {
                                      _setFocus(index, 'unit');
                                    }
                                  });
                                },
                                child: TextField(
                                  controller: unitControllers[index],
                                  decoration: _customInputDecoration(
                                      'تعداد واحد', unitFocusNodes[index]),
                                  keyboardType: TextInputType.number,
                                  focusNode: unitFocusNodes[index],
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    if (hasFocus) {
                                      _setFocus(index, 'grade');
                                    }
                                  });
                                },
                                child: TextField(
                                  controller: gradeControllers[index],
                                  decoration: _customInputDecoration(
                                      'نمره', gradeFocusNodes[index]),
                                  keyboardType: TextInputType.number,
                                  focusNode: gradeFocusNodes[index],
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    if (hasFocus) {
                                      _setFocus(index, 'name');
                                    }
                                  });
                                },
                                child: TextField(
                                  controller: nameControllers[index],
                                  decoration: _customInputDecoration(
                                      'نام درس', nameFocusNodes[index]),
                                  focusNode: nameFocusNodes[index],
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _addRow,
                  icon: Icon(Icons.add),
                  label: Text('افزودن ردیف', style: TextStyle(fontSize: 18.0)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD7D7D7),
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateGPA,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF447D9B),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'محاسبه',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFD7D7D7),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                          fontSize: 18,
                          color: errorMessage.startsWith('مقادیر')
                              ? Colors.red
                              : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setFocus(int index, String field) {
    // غیرفعال کردن فوکوس همه فیلدها
    for (int i = 0; i < nameFocusNodes.length; i++) {
      nameFocusNodes[i].unfocus();
      gradeFocusNodes[i].unfocus();
      unitFocusNodes[i].unfocus();
    }
    if (field == 'name') {
      nameFocusNodes[index].requestFocus();
    } else if (field == 'grade') {
      gradeFocusNodes[index].requestFocus();
    } else if (field == 'unit') {
      unitFocusNodes[index].requestFocus();
    }
    setState(() {
      focusedFieldIndex = index;
    });
  }
}
