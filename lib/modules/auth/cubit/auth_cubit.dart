import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/modules/auth/models/user_model.dart';
import 'package:firebase_project/modules/auth/repositories/firebase_firestore_repository.dart';
import 'package:firebase_project/modules/auth/services/firebase_auth_services.dart';
import 'package:firebase_project/services/encrypt_decrypt_services.dart';
import 'package:firebase_project/services/firbase_storage_services.dart';
import 'package:firebase_project/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../../cubit/image_picker_cubit.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.sps}) : super(AuthState());
  final SharedPreferencesServices sps;
  final fas = FirebaseAuthServices();
  final ffr = FirebaseFirestoreRepository();
  final fss = FirebaseStorageServices();

  Future<void> loginUserUsingSp({required Map<dynamic, dynamic> data}) async {
    if (data.isNotEmpty) {
      final token = data['token'];
      final uid = data['uid'];
      final isExpired = Jwt.isExpired(token);
      print('token detail ;: ${Jwt.parseJwt(token)}');
      if (isExpired) {
        emit(AuthState(userModel: null));
      } else {
        final userModel = await ffr.getUserDetails(uid);
        emit(AuthState(userModel: userModel));
      }
    } else {
      emit(AuthState(userModel: null));
    }
  }

  Future<void> loginUser({required String email, required String password}) async {
    BotToast.showLoading();
    try {
      final userCred = await fas.loginUsingEmailAndPassword(email: email, password: password);
      final userModel = await ffr.getUserDetails(userCred.user!.uid);
      BotToast.closeAllLoading();
      final token = await userCred.user?.getIdToken();
      print('token from firbease: $token');
      if (token != null) {
        await sps.storeUserDetails(token: token, userId: userModel!.id!);
        final savedData = sps.getUserDetails();
        print('saved data in cubit: $savedData');
      }

      ///todo need to save token in shared preference
      emit(AuthState(userModel: userModel));
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: 'Error in login.');
    }
  }

  Future<void> registerUser({required UserModel userModel, required BuildContext context}) async {
    // BotToast.showLoading();
    try {
      final imageState = context.read<ImagePickerCubit>().state;
      String? imageUrl;
      if (imageState.image != null) {
        ///storing image in firebase storage
        try {
          imageUrl = await fss.uploadUint8ListImageAndGetUrl(
            imageState.imageData!,
            collection: 'userProfiles',
            imageName: 'userImage.${imageState.imageExtension ?? 'jpg'}',
          );
        } catch (e) {
          print('image store error: $e');
        }
      }
      print('user detail : ${userModel.toDatabase()}');
      final userCred = await fas.registerUsingEmailAndPassword(email: userModel.email, password: userModel.password);
      final uid = userCred.user!.uid;
      userModel.id = uid;
      userModel.password = EncryptDecryptServices().encryptData(data: userModel.password);
      userModel.profileImage = imageUrl;
      await ffr.storeUser(userModel);
      BotToast.closeAllLoading();
      emit(AuthState());
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      BotToast.closeAllLoading();
      print('error in auth: ${e.message}');
    } catch (e) {
      BotToast.closeAllLoading();
      print('error in register: $e');
      BotToast.showText(text: 'Error in register.');
    }
  }

  Future<void> logoutUser() async {
    BotToast.showLoading();
    try {
      await fas.logoutUser();
      BotToast.closeAllLoading();
      await sps.clearUserPreferences();
      emit(AuthState());
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: 'Error in logout.');
    }
  }
}

class AuthState {
  final UserModel? userModel;
  AuthState({this.userModel});
}
