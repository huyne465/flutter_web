import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_web_flutter_fe/config/app_routes.dart';
import 'package:test_web_flutter_fe/core/extension/str_ext.dart';
import 'package:test_web_flutter_fe/generated/assets.gen.dart';
import 'package:test_web_flutter_fe/generated/locale_keys.g.dart';

class NormalLoginWidget extends StatefulWidget {
  final TextEditingController userController;
  final TextEditingController passController;
  final bool showPassword;
  final bool enableRegister;
  final Function(bool) onShowPassword;

  const NormalLoginWidget({
    super.key,
    required this.userController,
    required this.passController,
    required this.showPassword,
    required this.onShowPassword,
    required this.enableRegister,
  });

  @override
  State<NormalLoginWidget> createState() => _NormalLoginWidgetState();
}

class _NormalLoginWidgetState extends State<NormalLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: 1,
          controller: widget.userController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          decoration: InputDecoration(
            prefixIcon: Assets.resources.icons.icPerson.image(
              width: 20.w,
              height: 20.h,
            ),
            hintText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
                width: 1,
              ),
            ),
            filled: true,
            hintStyle: const TextStyle(color: Color.fromRGBO(177, 177, 177, 1)),
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          maxLines: 1,
          controller: widget.passController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          obscureText: !widget.showPassword,
          decoration: InputDecoration(
            prefixIcon: Assets.resources.icons.icLock.image(
              width: 20.w,
              height: 20.h,
            ),
            suffixIcon: widget.showPassword
                ? InkWell(
                    onTap: () {
                      widget.onShowPassword(false);
                    },
                    child: const Icon(Icons.visibility),
                  )
                : InkWell(
                    onTap: () {
                      widget.onShowPassword(true);
                    },
                    child: const Icon(Icons.visibility_off),
                  ),
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
                width: 1,
              ),
            ),
            filled: true,
            hintStyle: const TextStyle(color: Color.fromRGBO(177, 177, 177, 1)),
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromRGBO(177, 177, 177, 1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Visibility(
                  visible: widget.enableRegister,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.register);
                    },
                    child: Text(
                      LocaleKeys.button_registerAccount.translate(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromRGBO(55, 120, 218, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
