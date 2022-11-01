# flutter_wallet_connect_metamask

A sample Flutter project for checking Wallet Connect link for Metamask on multiple platforms.

**THE BIG QUESTION:** Does the prompt to connect an account pop up when Metamask opens? See
discussion in `lib/main.dart` for results tested by code uploader.

## How to run

### Web builds

Please run

```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

And then visit either:
- `localhost:8080` on a laptop or desktop (in this mode, WalletConnect URI is displayed as QR code,
   which may be scanned by Metamask on a mobile device.)
- `${IP_ADDRESS}:8080` on a browser in some mobile device connected to the same WiFi network.

### Native builds

Please run

```bash
flutter run -d DEVICE_NAME
```

using your preferred emulator, simulator, or physical device.
