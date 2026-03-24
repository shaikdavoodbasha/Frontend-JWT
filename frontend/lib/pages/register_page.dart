// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../pages/login_page.dart';

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController confirmPassword = TextEditingController();
  
//   bool isLoading = false;
//   bool obscurePassword = true;
//   bool obscureConfirmPassword = true;
  
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1500),
//     );
    
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
    
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
    
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     name.dispose();
//     email.dispose();
//     password.dispose();
//     confirmPassword.dispose();
//     super.dispose();
//   }

//   void register() async {
//     // Validation
//     if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty || confirmPassword.text.isEmpty) {
//       _showSnackBar(
//         message: 'Please fill in all fields',
//         color: Colors.orange.shade700,
//         icon: Icons.warning_amber_rounded,
//       );
//       return;
//     }

//     if (!_isValidEmail(email.text)) {
//       _showSnackBar(
//         message: 'Please enter a valid email address',
//         color: Colors.orange.shade700,
//         icon: Icons.email_outlined,
//       );
//       return;
//     }

//     if (password.text.length < 6) {
//       _showSnackBar(
//         message: 'Password must be at least 6 characters',
//         color: Colors.orange.shade700,
//         icon: Icons.lock_outline,
//       );
//       return;
//     }

//     if (password.text != confirmPassword.text) {
//       _showSnackBar(
//         message: 'Passwords do not match',
//         color: Colors.red.shade600,
//         icon: Icons.error_outline,
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       bool success = await ApiService.register(
//         name.text.trim(),
//         email.text.trim().toLowerCase(),
//         password.text,
//       );

//       setState(() => isLoading = false);

//       if (success) {
//         _showSnackBar(
//           message: 'Registration successful! 🎉',
//           color: Colors.green.shade600,
//           icon: Icons.check_circle_outline,
//           duration: 2,
//         );

//         // Animate out before popping
//         await _animationController.reverse();
        
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               var begin = Offset(1.0, 0.0);
//               var end = Offset.zero;
//               var curve = Curves.easeInOut;
//               var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//               return SlideTransition(
//                 position: animation.drive(tween),
//                 child: child,
//               );
//             },
//           ),
//         );
//       } else {
//         _showSnackBar(
//           message: 'Registration failed. Email might already exist.',
//           color: Colors.red.shade600,
//           icon: Icons.error_outline,
//         );
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showSnackBar(
//         message: 'An error occurred. Please try again.',
//         color: Colors.red.shade600,
//         icon: Icons.error_outline,
//       );
//     }
//   }

//   bool _isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }

//   void _showSnackBar({required String message, required Color color, required IconData icon, int duration = 3}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: Duration(seconds: duration),
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF6A11CB),  // Purple
//               Color(0xFF2575FC),  // Blue
//             ],
//             stops: [0.2, 0.9],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Back Button and Header
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ScaleTransition(
//                               scale: _scaleAnimation,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: IconButton(
//                                   icon: Icon(Icons.arrow_back, color: Colors.white),
//                                   onPressed: () => Navigator.pop(context),
//                                 ),
//                               ),
//                             ),
//                             ScaleTransition(
//                               scale: _scaleAnimation,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.favorite, color: Colors.white, size: 16),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'Join Us',
//                                       style: TextStyle(color: Colors.white, fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Animated Logo
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.person_add_alt_1_rounded,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 20),
                        
//                         // Title
//                         Text(
//                           'Create Account',
//                           style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 1.5,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 offset: Offset(2, 2),
//                                 blurRadius: 4,
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
                        
//                         SizedBox(height: 10),
                        
//                         Text(
//                           'Sign up to get started with your journey',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
                        
//                         SizedBox(height: 40),
                        
//                         // Name Field
//                         _buildAnimatedField(
//                           index: 0,
//                           child: _buildTextField(
//                             controller: name,
//                             hint: 'Full Name',
//                             icon: Icons.person_outline,
//                             keyboardType: TextInputType.name,
//                           ),
//                         ),
                        
//                         SizedBox(height: 16),
                        
//                         // Email Field
//                         _buildAnimatedField(
//                           index: 1,
//                           child: _buildTextField(
//                             controller: email,
//                             hint: 'Email Address',
//                             icon: Icons.email_outlined,
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                         ),
                        
//                         SizedBox(height: 16),
                        
//                         // Password Field
//                         _buildAnimatedField(
//                           index: 2,
//                           child: _buildTextField(
//                             controller: password,
//                             hint: 'Password',
//                             icon: Icons.lock_outline,
//                             isPassword: true,
//                           ),
//                         ),
                        
//                         SizedBox(height: 16),
                        
//                         // Confirm Password Field
//                         _buildAnimatedField(
//                           index: 3,
//                           child: _buildTextField(
//                             controller: confirmPassword,
//                             hint: 'Confirm Password',
//                             icon: Icons.lock_outline,
//                             isPassword: true,
//                             isConfirm: true,
//                           ),
//                         ),
                        
//                         // Password Requirements
//                         _buildAnimatedField(
//                           index: 4,
//                           child: Container(
//                             margin: EdgeInsets.only(top: 8),
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   password.text.length >= 6 ? Icons.check_circle : Icons.radio_button_unchecked,
//                                   color: password.text.length >= 6 ? Colors.green.shade300 : Colors.white.withOpacity(0.5),
//                                   size: 16,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Minimum 6 characters',
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.8),
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Register Button
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Container(
//                             height: 55,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Colors.white.withOpacity(0.95),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0xFF6A11CB).withOpacity(0.4),
//                                   blurRadius: 15,
//                                   offset: Offset(0, 8),
//                                   spreadRadius: 0,
//                                 ),
//                               ],
//                             ),
//                             child: ElevatedButton(
//                               onPressed: isLoading ? null : register,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               child: isLoading
//                                   ? SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A11CB)),
//                                       ),
//                                     )
//                                   : Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Create Account',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF6A11CB),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Icon(Icons.arrow_forward, color: Color(0xFF6A11CB)),
//                                       ],
//                                     ),
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 20),
                        
//                         // Terms and Privacy
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Text(
//                             'By signing up, you agree to our Terms of Service\nand Privacy Policy',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.7),
//                               fontSize: 12,
//                               height: 1.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
                        
//                         SizedBox(height: 20),
                        
//                         // Login Link
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Already have an account? ",
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8),
//                                   fontSize: 15,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   _animationController.reverse().then((_) {
//                                     Navigator.pop(context);
//                                   });
//                                 },
//                                 child: Text(
//                                   'Sign In',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     decoration: TextDecoration.underline,
//                                     decorationColor: Colors.white,
//                                     decorationThickness: 2,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedField({required int index, required Widget child}) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SlideTransition(
//         position: Tween<Offset>(
//           begin: Offset(0, 0.1 * (index + 1)),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(
//           parent: _animationController,
//           curve: Interval(0.1 * index, 0.5 + (0.1 * index), curve: Curves.easeOut),
//         )),
//         child: child,
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool isPassword = false,
//     bool isConfirm = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword 
//           ? (isConfirm ? obscureConfirmPassword : obscurePassword)
//           : false,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//         keyboardType: keyboardType,
//         onChanged: (value) {
//           if (isPassword || isConfirm) {
//             setState(() {}); // Trigger rebuild for password requirements
//           }
//         },
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             color: Colors.white.withOpacity(0.5),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           prefixIcon: Icon(
//             icon, 
//             color: Colors.white.withOpacity(0.8),
//             size: 22,
//           ),
//           suffixIcon: isPassword 
//             ? IconButton(
//                 icon: Icon(
//                   (isConfirm ? obscureConfirmPassword : obscurePassword) 
//                     ? Icons.visibility_off_outlined 
//                     : Icons.visibility_outlined,
//                   color: Colors.white.withOpacity(0.7),
//                   size: 22,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (isConfirm) {
//                       obscureConfirmPassword = !obscureConfirmPassword;
//                     } else {
//                       obscurePassword = !obscurePassword;
//                     }
//                   });
//                 },
//               )
//             : null,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         ),
//       ),
//     );
//   }
// }