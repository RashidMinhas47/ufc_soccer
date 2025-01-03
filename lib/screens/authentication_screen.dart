import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufc_soccer/providers/manage_app_provider.dart';
import 'package:ufc_soccer/utils/constants.dart';
import 'package:ufc_soccer/widgets/sign_up_button.dart';
import '../providers/auth_providers.dart';
import '../utils/image_urls.dart';
import '../widgets/auth_text_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  static const screen = "/AuthScreen";
  const AuthScreen({super.key});

  ConsumerState<AuthScreen> createState() => _AuthScreenConsumerState();
}

class _AuthScreenConsumerState extends ConsumerState<AuthScreen> {
  bool isToogleScreen = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final accessCodeController = TextEditingController();
  String? displayName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // loginu3A (211:24)
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(40 * 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // ellipse124qmN (211:109)
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                height: 64 * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32 * 1),
                  image: DecorationImage(
                    image: AssetImage(
                      AppImages.appIcon,
                    ),
                  ),
                ),
              ),
              Container(
                // pleaselogintoyouraccountk7e (211:26)
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  isToogleScreen
                      ? 'Please Sign Up to your account'
                      : 'Please Login to your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16 * 1,
                    fontWeight: FontWeight.w600,
                    height: 1.2125 * 1 / 1,
                    color: Color(0xff333333),
                  ),
                ),
              ),
              Container(
                // frame5094dx8 (211:56)
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // frame5093NPv (211:57)
                      margin: EdgeInsets.fromLTRB(0 * 1, 0 * 1, 0 * 1, 34 * 1),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // frame5092KKA (211:58)
                            margin: EdgeInsets.fromLTRB(
                                0 * 1, 0 * 1, 0 * 1, 20 * 1),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                textFieldsList(ref.watch(signUpProvider)),
                                Text(
                                  // forgotpassword724 (211:69)
                                  'Forgot password?',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    fontSize: 14 * 1,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * 1 / 1,
                                    color: Color(0xff999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ref.watch(signInProvider).loading ||
                                  ref.watch(signUpProvider).loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : SignUpButton(
                                  onPressed: () {
                                    isToogleScreen
                                        ? ref
                                            .read(signUpProvider)
                                            .signUpValidation(
                                              appSettingsProvider: ref
                                                  .watch(appSettingsProvider),
                                              context: context,
                                              correctCode: accessCodeController
                                                  .text
                                                  .trim(),
                                              nameController: nameController,
                                              email: emailController,
                                              password: passwordController,
                                              displayName: nameController.text,
                                            )
                                        : ref
                                            .watch(signInProvider)
                                            .signInValidation(
                                                context: context,
                                                email: emailController,
                                                password: passwordController);
                                  },
                                  provider: ref.read(signUpProvider),
                                  nameController: nameController,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  size: size,
                                  isToogleScreen: isToogleScreen),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ScreenToogleButton(
                onTap: () => setState(() {
                  isToogleScreen = !isToogleScreen;
                }),
                isToogleScreen: isToogleScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container textFieldsList(SignUpAuthProvider provider) {
    return Container(
      // frame5091rpt (211:59)
      margin: paddBottom16,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isToogleScreen
              ? AuthTextField(
                  hintText: 'Name*',
                  iconPath: AppSvg.personIcon,
                  controller: nameController,
                )
              : sizeBoxShrink,
          AuthTextField(
            hintText: 'Email*',
            iconPath: AppSvg.mailIcon,
            controller: emailController,
          ),
          AuthTextField(
            hintText: 'Password*',
            controller: passwordController,
            iconPath: AppSvg.lockIcon,
            obscureText: provider.obScureText,
            suffixIcon: IconButton(
              onPressed: () => provider.tooglingObscureText(),
              icon: SvgPicture.asset(
                  provider.obScureText ? AppSvg.eyeIcon : AppSvg.eyeOffIcon,
                  height: 19,
                  width: 19,
                  color: Color.fromARGB(255, 70, 69, 69)),
            ),
          ),
          isToogleScreen
              ? AuthTextField(
                  hintText: 'Access code',
                  iconPath: AppSvg.eyeIcon,
                  controller: accessCodeController,
                )
              : sizeBoxShrink,
        ],
      ),
    );
  }
}

class ScreenToogleButton extends StatelessWidget {
  const ScreenToogleButton(
      {super.key, required this.isToogleScreen, required this.onTap});

  final bool isToogleScreen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        // newuserssignupoYQ (211:27)
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 14 * 1,
            fontWeight: FontWeight.w400,
            height: 1.5 * 1 / 1,
            color: kGrayColor,
          ),
          children: [
            TextSpan(
              text:
                  isToogleScreen ? 'Already have an account? ' : 'New users? ',
              style: GoogleFonts.inter(
                fontSize: 14 * 1,
                fontWeight: FontWeight.w400,
                height: 1.2125 * 1 / 1,
                color: kGrayColor,
              ),
            ),
            TextSpan(
              text: isToogleScreen ? 'Log in' : 'Sign Up',
              style: GoogleFonts.inter(
                fontSize: 14 * 1,
                fontWeight: FontWeight.w600,
                height: 1.2125 * 1 / 1,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const paddBottom16 = EdgeInsets.only(bottom: 16);
const sizeBox16 = SizedBox(
  width: 16 * 1,
);

const sizeBoxShrink = SizedBox.shrink();
const padd44_14 = EdgeInsets.symmetric(horizontal: 14.83, vertical: 44.11);
const sizeBox20 = SizedBox(
  width: 20 * 1,
);
