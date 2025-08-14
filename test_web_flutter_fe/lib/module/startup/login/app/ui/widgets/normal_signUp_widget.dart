import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_web_flutter_fe/generated/assets.gen.dart';

class NormalSignupWidget extends StatefulWidget {
  final TextEditingController userController;
  final TextEditingController passController;
  final TextEditingController emailController;
  final TextEditingController confirmPassController;
  final TextEditingController fullNameController;
  final TextEditingController displayNameController;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool enableRegister;
  final Function(bool) onShowPassword;
  final Function(bool) onShowConfirmPassword;
  const NormalSignupWidget({
    super.key,
    required this.userController,
    required this.passController,
    required this.emailController,
    required this.confirmPassController,
    required this.fullNameController,
    required this.displayNameController,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.enableRegister,
    required this.onShowPassword,
    required this.onShowConfirmPassword,
  });

  @override
  State<NormalSignupWidget> createState() => _NormalSignupWidgetState();
}

class _NormalSignupWidgetState extends State<NormalSignupWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: 1,
          controller: widget.fullNameController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          decoration: InputDecoration(
            prefixIcon: Assets.resources.icons.icPerson.image(
              width: 20.w,
              height: 20.h,
            ),
            hintText: 'Họ và tên',
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
          controller: widget.emailController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20.w,
              color: const Color.fromRGBO(177, 177, 177, 1),
            ),
            hintText: 'Email',
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
          controller: widget.displayNameController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.badge_outlined,
              size: 20.w,
              color: const Color.fromRGBO(177, 177, 177, 1),
            ),
            hintText: 'Display Name',
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

        SizedBox(height: 20.h),

        TextField(
          maxLines: 1,
          controller: widget.confirmPassController,
          style: TextStyle(color: Colors.black, fontSize: 12.sp),
          obscureText: !widget.showConfirmPassword,
          decoration: InputDecoration(
            prefixIcon: Assets.resources.icons.icLock.image(
              width: 20.w,
              height: 20.h,
            ),
            suffixIcon: widget.showConfirmPassword
                ? InkWell(
                    onTap: () {
                      widget.onShowConfirmPassword(false);
                    },
                    child: const Icon(Icons.visibility),
                  )
                : InkWell(
                    onTap: () {
                      widget.onShowConfirmPassword(true);
                    },
                    child: const Icon(Icons.visibility_off),
                  ),
            hintText: 'Confirm Password',
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
      ],
    );
  }
}
