import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signeOut() async{
    await _firebaseAuth.signOut();
  }

  Future<String?> singIn({required String email, required String password}) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In Successfully";
    }on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  Future<String?> reg({required String email, required String password}) async {
    try{
      var user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Registered Successfully";
    }on FirebaseAuthException catch (e){
      return e.message;
    }
  }
}
