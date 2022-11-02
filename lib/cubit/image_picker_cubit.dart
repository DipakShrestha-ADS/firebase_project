import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerState());

  void handlePickedImage(XFile? image) async {
    if (image != null) {
      final imageData = await image.readAsBytes();
      print('picked image name : ${image.name}');
      final imageExtension = image.name.split('.').last;
      emit(ImagePickerState(
        image: image,
        imageExtension: imageExtension,
        imageData: imageData,
      ));
    } else {
      emit(ImagePickerState());
    }
  }
}

class ImagePickerState {
  XFile? image;
  Uint8List? imageData;
  String? imageExtension;
  ImagePickerState({this.image, this.imageData, this.imageExtension});
}
