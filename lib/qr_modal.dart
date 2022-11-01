import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrModal extends StatelessWidget {
  const QrModal({
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String uri;

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 1,
        expand: false,
        builder: (BuildContext context, ScrollController controller) =>
            SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          'Please scan with Metamask',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: QrImage(
                    data: uri,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
