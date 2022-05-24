import 'package:camera/camera.dart';

class CameraService {
   late List<CameraDescription> cameras;

   void init() async {
      cameras = await availableCameras();
   }

   CameraDescription getFirstCamera() {
      return cameras.first;
   }
}