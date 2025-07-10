import 'package:flutter/material.dart';

class FullScreenImageWidget extends StatefulWidget {
  final String imageUrl;

  const FullScreenImageWidget({super.key, required this.imageUrl});

  @override
  State<FullScreenImageWidget> createState() => _FullScreenImageWidgetState();
}

class _FullScreenImageWidgetState extends State<FullScreenImageWidget> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _transformationController.value = Matrix4.identity();
        });
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(onTap: () => Navigator.pop(context)),
              Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 7.0,
                  child: Image.network(widget.imageUrl, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
