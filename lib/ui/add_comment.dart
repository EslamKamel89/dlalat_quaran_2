import 'package:dlalat_quaran_new/controllers/comment_controller.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCommentView extends StatefulWidget {
  const AddCommentView({super.key});

  static var id = '/AddComment';

  @override
  State<AddCommentView> createState() => _AddCommentViewState();
}

class _AddCommentViewState extends State<AddCommentView> {
  late GlobalKey<FormState> formKey;
  late CommentController commentController;
  String name = '';
  String email = '';
  String phone = '';
  String comment = '';
  String countryCode = '';
  String commentType = Get.arguments['commentType'];
  int? id = int.parse(Get.arguments['id'].toString());
  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    commentController = Get.find<CommentController>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: QuranBar('addComment'.tr),
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
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: PrimaryButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      commentController.addComment(
                        commentType: commentType == 'ayah'
                            ? CommentType.ayah
                            : commentType == 'tag'
                                ? CommentType.tag
                                : CommentType.article,
                        id: id ?? 1,
                        name: name,
                        email: email,
                        phone: (countryCode == '' ? '+20' : countryCode) + phone,
                        comment: comment,
                      );
                      Get.back();
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
