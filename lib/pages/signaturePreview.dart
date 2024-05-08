import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:path_provider/path_provider.dart';
import 'package:pit/themes/AppTheme.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List? signature;

  const SignaturePreviewPage({
    Key? key,
    @required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppTheme.warnaUngu,
            leading: CloseButton(),
            title: Text('Signature Preview'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(context, saveSignature(signData: signature!));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Center(
            child: Image.memory(signature!, width: double.infinity),
          ),
        ),
      );

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${DateTime.now()}.png');
  }

  Future saveSignature({required Uint8List signData}) async {
    ///provide local path to store the signature
    final signFile = await _localFile;
    var DataFile = await File(signFile.path).writeAsBytes(signData.toList());
    // print(DataFile);
    final image = img.decodeImage(DataFile.readAsBytesSync())!;
    final reSize = img.copyResize(image,
        width: 250, height: 200, interpolation: img.Interpolation.cubic);
    File(signFile.path).writeAsBytesSync(img.encodePng(reSize));

    return DataFile;
  }
}
