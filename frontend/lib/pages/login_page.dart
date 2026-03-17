// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../storage/token_storage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'home_page.dart';
// import 'register_page.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
  
//   bool isLoading = false;
//   bool obscurePassword = true;
//   bool rememberMe = false;
  
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
//     email.dispose();
//     password.dispose();
//     super.dispose();
//   }

//   void login() async {
//     // Validation
//     if (email.text.isEmpty || password.text.isEmpty) {
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

//     setState(() => isLoading = true);

//     try {
//       String? token = await ApiService.login(
//         email.text.trim().toLowerCase(),
//         password.text,
//       );

//       setState(() => isLoading = false);

//       if (token != null) {
//         await TokenStorage.saveToken(token);
        
//         _showSnackBar(
//           message: 'Login successful! 🎉',
//           color: Colors.green.shade600,
//           icon: Icons.check_circle_outline,
//           duration: 1,
//         );

//         // Animate out before navigating
//         await _animationController.reverse();
        
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
//           message: 'Invalid email or password',
//           color: Colors.red.shade600,
//           icon: Icons.error_outline,
//         );
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showSnackBar(
//         message: 'Connection error. Please try again.',
//         color: Colors.red.shade600,
//         icon: Icons.wifi_off_rounded,
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
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               Color(0xFF4158D0), // Blue
//               Color(0xFFC850C0), // Pink
//               Color(0xFFFFCC70), // Yellow
//             ],
//             stops: [0.1, 0.5, 0.9],
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
//                         // Logo and Header
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Container(
//                             height: 120,
//                             width: 120,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.white.withOpacity(0.3),
//                                   Colors.white.withOpacity(0.1),
//                                 ],
//                               ),
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.white.withOpacity(0.2),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.lock_clock_rounded,
//                               size: 60,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Welcome Text
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Text(
//                             'Welcome Back!',
//                             style: TextStyle(
//                               fontSize: 42,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 2,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   offset: Offset(2, 2),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
                        
//                         SizedBox(height: 10),
                        
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Text(
//                             'Sign in to continue your journey',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white.withOpacity(0.9),
//                               letterSpacing: 0.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
                        
//                         SizedBox(height: 50),
                        
//                         // Email Field
//                         _buildAnimatedField(
//                           index: 0,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.3),
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: TextField(
//                               controller: email,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 hintText: 'Email Address',
//                                 hintStyle: TextStyle(
//                                   color: Colors.white.withOpacity(0.6),
//                                   fontSize: 16,
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.email_outlined,
//                                   color: Colors.white.withOpacity(0.8),
//                                   size: 22,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                               ),
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 16),
                        
//                         // Password Field
//                         _buildAnimatedField(
//                           index: 1,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.3),
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: TextField(
//                               controller: password,
//                               obscureText: obscurePassword,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Password',
//                                 hintStyle: TextStyle(
//                                   color: Colors.white.withOpacity(0.6),
//                                   fontSize: 16,
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.lock_outline_rounded,
//                                   color: Colors.white.withOpacity(0.8),
//                                   size: 22,
//                                 ),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                                     color: Colors.white.withOpacity(0.7),
//                                     size: 22,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       obscurePassword = !obscurePassword;
//                                     });
//                                   },
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//                               ),
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 20),
                        
//                         // Remember Me & Forgot Password
//                         _buildAnimatedField(
//                           index: 2,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Remember Me
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: Checkbox(
//                                       value: rememberMe,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           rememberMe = value ?? false;
//                                         });
//                                       },
//                                       fillColor: MaterialStateProperty.resolveWith((states) {
//                                         if (states.contains(MaterialState.selected)) {
//                                           return Colors.white;
//                                         }
//                                         return Colors.white.withOpacity(0.3);
//                                       }),
//                                       checkColor: Color(0xFF4158D0),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(6),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     'Remember me',
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.8),
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
                              
//                               // Forgot Password
//                               GestureDetector(
//                                 onTap: () {
//                                   _showSnackBar(
//                                     message: 'Password reset link sent!',
//                                     color: Colors.blue.shade600,
//                                     icon: Icons.mark_email_read_rounded,
//                                   );
//                                 },
//                                 child: Text(
//                                   'Forgot Password?',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     decoration: TextDecoration.underline,
//                                     decorationColor: Colors.white.withOpacity(0.5),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Login Button
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Colors.white.withOpacity(0.9),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0xFF4158D0).withOpacity(0.4),
//                                   blurRadius: 20,
//                                   offset: Offset(0, 10),
//                                   spreadRadius: 0,
//                                 ),
//                               ],
//                             ),
//                             child: ElevatedButton(
//                               onPressed: isLoading ? null : login,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 shadowColor: Colors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: isLoading
//                                   ? SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4158D0)),
//                                       ),
//                                     )
//                                   : Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Sign In',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF4158D0),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Icon(
//                                           Icons.arrow_forward_rounded,
//                                           color: Color(0xFF4158D0),
//                                           size: 24,
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Social Login
//                         _buildAnimatedField(
//                           index: 3,
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Divider(
//                                       color: Colors.white.withOpacity(0.3),
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 16),
//                                     child: Text(
//                                       'OR',
//                                       style: TextStyle(
//                                         color: Colors.white.withOpacity(0.7),
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Divider(
//                                       color: Colors.white.withOpacity(0.3),
//                                       thickness: 1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
                              
//                               SizedBox(height: 20),
                              
//                               // Social Buttons
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   _buildSocialButton(
//                                     icon: FontAwesomeIcons.google,
//                                     onPressed: () {},
//                                     color: Colors.redAccent,
//                                   ),
//                                   _buildSocialButton(
//                                     icon: Icons.facebook_rounded,
//                                     onPressed: () {},
//                                     color: Color(0xFF1877F2),
//                                   ),
//                                   _buildSocialButton(
//                                     icon: Icons.apple_rounded,
//                                     onPressed: () {},
//                                     color: Colors.black,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
                        
//                         SizedBox(height: 30),
                        
//                         // Create Account Link
//                         ScaleTransition(
//                           scale: _scaleAnimation,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Don't have an account? ",
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8),
//                                   fontSize: 15,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   _animationController.reverse().then((_) {
//                                     Navigator.push(
//                                       context,
//                                       PageRouteBuilder(
//                                         pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
//                                         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                                           var begin = Offset(1.0, 0.0);
//                                           var end = Offset.zero;
//                                           var curve = Curves.easeInOut;
//                                           var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//                                           return SlideTransition(
//                                             position: animation.drive(tween),
//                                             child: child,
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   });
//                                 },
//                                 child: Text(
//                                   'Create Account',
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

//   Widget _buildSocialButton({required IconData icon, required VoidCallback onPressed, required Color color}) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 55,
//         height: 55,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Icon(
//           icon,
//           color: color,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }