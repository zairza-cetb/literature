## Literature
Literature is a card game for 4 to 12 players, most commonly played with 6 or 8 players in two teams.

![Literature-cover](https://user-images.githubusercontent.com/26324376/86165562-177bc380-bb31-11ea-916c-c3b56fb2cffb.jpg)

## Features
- Connect to up to 6 people in a single game
- Add friends from social media
- Play the epic game of literature
- Get coins and get fancy items from the store.
- Learn and enjoy!



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to run
#### Server:
```
 1. cd node_server
 2. npm install
 3. Create a new .env file. (refer to .env.example)
 4. Provide mongodb credentials in .env.
 5. npm start
```

#### Client:
Most of the configuration on the client side depends upon a lot of factors, it is
better to follow a tutorial as per your requirements. There's a ton on the internet.
```
1. Install and setup flutter
2. On VS-Code move to main.dart
3. Hit on run and debug and choose your device/emulator.
```

### Note:

There might be problems connecting to your localhost server from an mobile device(not emulators). Here are some methods through which you can solve this issue.

#### Connecting to the same local network.
1. Connect your system(where your nodejs server is running) and the mobile device to the same local network.(Ex. Same wifi).
2. After successful connection call your systems port through the IP address of the system or laptop.

Refer: https://stackoverflow.com/questions/4779963/how-can-i-access-my-localhost-from-my-android-device

#### Exposing your local server port to the internet by creating a safe local tunnel.
This is a more easy and simple way to connect to your system. Create a local tunnel to your port through a tunneling service such as ngrok, pagekite, etc.

To create a local tunnel to your port:
1. Install ngrok in yout system. (Download and unzip the file).
2. Connect to your account through the token. (Optional step).
3. Expose your port through by running `./ngrok http ${port}`

This command will give you a public url, which will directly connect you to your node server. Use this url to make connection to the server from your mobile device. 



### Frontend logic
![Frontend logic](https://user-images.githubusercontent.com/26324376/79640179-cdc84180-81ad-11ea-8be7-41438ae61afd.png)
