import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class OpenCamera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const OpenCamera({this.cameras, Key? key}) : super(key: key);

  @override
  _OpenCameraState createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  late CameraController cameraController;
  XFile? pictureFile;

  Widget cameraWidget(context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras![1], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (pictureFile == null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Center(
                        child: SizedBox(
                      height: 500,
                      child: cameraWidget(context),
                    )),
                  ),
                ],
              ),
            if (pictureFile != null)
              Container(
                color: const Color(0xff121421),
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Center(
                    child: Column(
                      //color: Color(0xff121421),
                      children: [
                        //color: Color(0xff121421),
                        Image.file(
                          File(
                            pictureFile!.path,
                          ),
                          height: 577.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff121421),
        items: [
          BottomNavigationBarItem(
            icon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                onPressed: () {
                  pictureFile = null;
                  setState(() {});
                },
                child: const Text("Retake")),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                pictureFile = await cameraController.takePicture();
                setState(() {});
              },
              //color: Color(0xff121421),
              icon: const Icon(
                Icons.photo_camera,
                size: 50,
                color: Colors.white,
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
