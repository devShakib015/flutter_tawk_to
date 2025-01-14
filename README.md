# flutter_tawk_to_chat
This package is a fork of [flutter_tawk](https://github.com/ayoubamine/flutter_tawk) package.

[![pub package](https://img.shields.io/pub/v/flutter_tawk_to_chat.svg)](https://pub.dev/packages/flutter_tawk_to_chat)

<img src="https://i1.wp.com/www.tawk.to/wp-content/uploads/2020/04/tawk-sitelogo.png" width="48">

[Tawk.to](https://www.tawk.to) widget for Flutter.

## 🚀 Showcase

<p>
    <img src="https://raw.githubusercontent.com/ycy-0510/flutter_tawk_to/main/readme_resources/screenshot4.png" width="200" />
    <img src="https://raw.githubusercontent.com/ycy-0510/flutter_tawk_to/main/readme_resources/screenshot5.png" width="200" />
    <img src="https://raw.githubusercontent.com/ycy-0510/flutter_tawk_to/main/readme_resources/screenshot6.png" width="200" />
    <img src="https://raw.githubusercontent.com/ycy-0510/flutter_tawk_to/main/readme_resources/screenshot7.png" width="200" />
</p>

## Install

To use this package, add `flutter_tawk_to_chat` as dependency in your pubspec.yaml file.

## Import

```dart
import 'package:flutter_tawk_to_chat/flutter_tawk_to_chat.dart';
```

## How To Use

```dart
Tawk(
    directChatLink: 'YOUR_DIRECT_CHAT_LINK',
    visitor: TawkVisitor(
        name: 'Username',
        email: 'example@gmail.com',
    ),
)
```

See the `example` directory for the complete sample app.

## Customization

### Tawk

| Parameter      | Type          | Default                                      | Description                                    | Required |
| -------------- | ------------- | -------------------------------------------- | ---------------------------------------------- | -------- |
| directChatLink | `String`      | `null`                                       | Tawk direct chat link.                         | Yes      |
| visitor        | `TawkVisitor` | `null`                                       | Object used to set the visitor name and email. | No       |
| onLoad         | `Function`    | `null`                                       | Called right after the widget is rendered.     | No       |
| onLinkTap      | `Function`    | `null`                                       | Called when a link pressed.                    | No       |
| placeholder    | `Widget`      | `Center(child: CircularProgressIndicator())` | Render your own loading widget.                | No       |

### TawkVisitor

| Parameter | Type     | Default | Description                                                 | Required |
| --------- | -------- | ------- | ----------------------------------------------------------- | -------- |
| name      | `String` | `null`  | Visitor's name.                                             | No       |
| email     | `String` | `null`  | Visitor's email.                                            | No       |
| hash      | `String` | `null`  | [Secure mode](https://developer.tawk.to/jsapi/#SecureMode). | No       |


## Changelog

[CHANGELOG](./CHANGELOG.md)

## License

[MIT License](./LICENSE)
