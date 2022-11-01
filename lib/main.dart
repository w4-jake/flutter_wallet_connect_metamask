import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_wallet_connect_metamask/qr_modal.dart';
import 'package:flutter_wallet_connect_metamask/wallet_info.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'device_utils/device_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Test Project for WC and Metamask'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WalletInfo? _walletInfo;

  final WalletConnect _walletConnect = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'Sample',
      description: 'Here is a sample description',
      icons: <String>[
        'https://cdn.mos.cms.futurecdn.net/m33Pou2DHPmjSvVGVX6sRH-1200-80.jpg',
      ],
      url: 'http://www.github.com',
    ),
  );

  void _setWalletInfo(int chainId, String address) {
    setState(() {
      _walletInfo = WalletInfo(chainId: chainId, address: address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This device\'s environment has been determined to be:',
            ),
            Text(
              DeviceUtils.deviceLabel(),
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton.icon(
              onPressed: _walletInfo != null
                  ? null
                  : () async {
                      final SessionStatus session =
                          await _walletConnect.createSession(
                        onDisplayUri: (String uri) async {
                          // Please uncomment one of the three launch URI choices.

                          // NOTE: The following environments were tested:
                          // - Native Android: Pixel 4 emulator, R Android 11.0 x86
                          // - Android web: Chrome on Galaxy S9, Android 10
                          // - iOS web: Safari on iPhone 6, iOS 12.5.6
                          // - PC web: Chrome on MacBook Pro. QR scanned with above physical devices

                          // OPTION 1: The `wc:` protocol URI provided by WalletConnect.
                          // (/) Android native: An arbitrary wallet app is opened. In the case of
                          //                     Metamask opening, the connect prompt shows and
                          //                     connecting succeeds, but ensuring only Metamask
                          //                     opens is impossible.
                          // (X) Android web: User given option to open with various wallet apps.
                          //                  If user chooses Metamask, Metamask opens, but there is
                          //                  no prompt to connect.
                          // (/) iOS web: User given option to open with various wallet apps. If
                          //              user chooses Metamask, Metamask opens and connect prompt
                          //              shows. Ensuring only Metamask is used is impossible.
                          // (/) PC web: Can scan QR code and connect with multiple apps. (ex.
                          //             Rainbow, etc.) Ensuring only Metamask is used is
                          //             impossible.
                          // final launchUri = uri;

                          // OPTION 2: Deep link.
                          // (O) Android native: Metamask is opened, a connect prompt shows, and
                          //                     the connection succeeds.
                          // (X) Android web: User given option to open with Metamask or other
                          //                  browsers. If user chooses Metamask, Metamask opens,
                          //                  but there is no prompt to connect.
                          //                  ^ *PLEASE CHECK*
                          // (O) iOS web: User prompted to open Metamask. If user follows through,
                          //              Metamask opens and connect prompt shows.
                          // (O) PC web: QR code scan works with Metamask and not with other apps
                          //             like Rainbow. Ensuring only Metamask is used is possible!
                          final launchUri = 'metamask://wc?uri=$uri';

                          // OPTION 3: Universal link.
                          // (X) Android native: User given option to open with Metamask or other
                          //                     browsers. If user chooses Metamask, Metamask opens
                          //                     but there is no prompt to connect.
                          // (X) Android web: User given option to open with Metamask or other
                          //                  browsers. If user chooses Metamask, Metamask opens,
                          //                  but there is no prompt to connect.
                          // (X) iOS web: User taken to AppStore page for Metamask, even if already
                          //              downloaded. Navigating to Metamask results in no connect
                          //              prompt.
                          // (X) PC web: QR code scan interpreted as external link. Does not work.
                          // final launchUri =
                          //     'https://metamask.app.link/wc?uri=$uri';

                          debugPrint('The URI to be launched is: $launchUri');

                          if (DeviceUtils.isPcWeb()) {
                            await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  QrModal(uri: launchUri),
                            );
                          } else {
                            // NOTE: For this demo, assume device has Metamask installed with a
                            // wallet set up. So we don't check if URI is openable.
                            await launchUrlString(
                              launchUri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      );
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      _setWalletInfo(session.chainId, session.accounts[0]);
                    },
              icon: SvgPicture.asset('assets/metamask.svg'),
              label: const Text('Connect with Metamask'),
            ),
            _walletInfo == null
                ? const Text('Not connected to a wallet...')
                : Text(
                    'Connected account: ${_walletInfo!.address} (chainId: ${_walletInfo!.chainId})',
                    style: Theme.of(context).textTheme.headline6,
                  ),
          ],
        ),
      ),
    );
  }
}
