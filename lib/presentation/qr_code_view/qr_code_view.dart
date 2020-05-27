import 'package:flutter/material.dart';
import 'package:messager/presentation/components/qr_image_custom.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatefulWidget {
  final String textForGenerate;

  const QrCodeView({Key key, @required this.textForGenerate}) : super(key: key);
  @override
  _QrCodeViewState createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  GlobalKey<QrImageCustomState> qrCodeViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: QrImageCustom(
          key: qrCodeViewKey,
          data: widget.textForGenerate,
          version: QrVersions.auto,
          size: MediaQuery.of(context).size.width - 40,
        ),
      ),
    );
  }
}
