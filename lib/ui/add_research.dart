import 'package:dlalat_quaran_new/controllers/add_reserch_controller.dart';
import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:dlalat_quaran_new/utils/api_service/upload_file_to_api.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddResearchView extends StatefulWidget {
  const AddResearchView({super.key});
  static var id = '/AddResearch';

  @override
  State<AddResearchView> createState() => _AddResearchViewState();
}

class _AddResearchViewState extends State<AddResearchView> {
  late GlobalKey<FormState> formKey;
  String name = '';
  String email = '';
  String phone = '';
  String comment = '';
  String countryCode = '';
  late AddResearchController addResearchController;
  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    addResearchController = Get.find<AddResearchController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: QuranBar('أضف بحث'.tr),
        backgroundColor: lightGray2,
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'الاسم',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: 'Almarai',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'لا يمكن ترك هذا الحقل فارغ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'البريد الألكتروني',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: 'Almarai',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'لا يمكن ترك هذا الحقل فارغ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'phoneNumber'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: 'Almarai',
                  ),
                ),
                const SizedBox(height: 5),
                // Directionality(
                // textDirection: TextDirection.ltr,
                // child:
                Stack(
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone = value;
                        },
                        validator: (value) {
                          if (value == '') {
                            // return 'لا يمكن ترك هذا الحقل فارغ';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          // prefixIcon: const SizedBox(width: 110),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          labelText: '',
                          hintText: 'رقم الهاتف + كود الدولة',
                          isDense: true,
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: -4,
                    //   child: CountryCodePicker(
                    //     initialSelection: '+20',
                    //     onChanged: (value) {
                    //       countryCode = value.dialCode ?? '';
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                // ),
                const SizedBox(height: 10),
                Text(
                  'comment'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: 'Almarai',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value) {
                    comment = value;
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'لا يمكن ترك هذا الحقل فارغ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      onPressed: () async {
                        AddResearchData.uploadFile = await pickFile();
                        setState(() {});
                      },
                      borderRadius: 5,
                      child: Row(
                        children: [
                          AddResearchData.uploadFile != null
                              ? const Icon(Icons.check, color: Colors.white)
                              : const SizedBox(),
                          const SizedBox(width: 5),
                          Text(
                            'رفع ملف'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    PrimaryButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (AddResearchData.uploadFile == null) {
                          pr("User didn't pick the file", 'submit button');
                          showCustomSnackBar(title: 'خطأ', body: 'لم يتم أختيار ملف ', isSuccess: false);
                          return;
                        }
                        if (await addResearchController.addResearch(
                          email: email,
                          name: name,
                          phone: countryCode + phone,
                          comment: comment,
                        )) {
                          Get.back();
                          return;
                        } else {
                          showCustomSnackBar(
                              title: "خطأ", body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري", isSuccess: false);
                        }
                      },
                      borderRadius: 5,
                      child: Text(
                        'save'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
