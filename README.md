<h1 align="center">Kitsumon</h1>

<div align="center">
A fox powered Kitsu.io API Wrapper for Dart.
A package to interact with the official 

[Kitsu.io API](https://kitsu.io/).

[![Dart Version](https://img.shields.io/badge/Dart-2.7.2-blue.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Build Status](https://img.shields.io/travis/Nebulino/Kitsumon/master?style=flat-square&logo=travis)](https://travis-ci.org/github/Nebulino/Kitsumon)
[![Kitsu.io](https://img.shields.io/badge/Kitsu.io-1.0-00aced.svg?style=flat-square)](https://kitsu.docs.apiary.io/)
[![Nebulino](https://img.shields.io/badge/💬%20Telegram-Nebulino-blue.svg?style=flat-square)](https://t.me/Nebulino/)

</div>

## Meaning

From Kitsu, you know what is it if you're here, and Kitsumon (詰問), question or asking in japanese.

I love Kitsu.io and with the will of interfacing with their API, asking... questioning... or just sending queries.

So here we go~ Kitsumon is born!

## Disclaimer

I'm doing it just for fun, so... use at your own risk.

I hope it will become something great.

^-^

## Usage

A simple usage example:

```dart
import 'package:kitsumon/kitsumon.dart';

// A simple example...
// For more, check the example folder.
void main() async {
  final kitsumon = Kitsumon();
  
  // Start using the Wrapper...
}

```

## Get Kitsumon

Add Kitsumon dependency on `pubspec.yaml`:

From GitHub (for example: branch-name >> dev-build):
```yaml
dependencies:
  kitsumon:
    git: https://github.com/Nebulino/Kitsumon.git
      ref: branch-name
```

From pub.dev:

##### Coming soon... I hope...

## Features and bugs

#### Status:

For now, I'm using Restful API, because graphQL is still in early stages after I asked the owners of the site about 
the status of it. 

Maybe in a future project I will support also GQl API.

#### WARNING 

THIS IS NOT FULLY USABLE.
IT'S A WORK IN PROGRESS, FEEL FREE TO SHARE YOUR THOUGHTS HOW TO MAKE IT BETTER. 

#### AUTHENTICATION

**NOTE:** Application registration has not yet been implemented, 
so for now all requests should be made with the public client ID and secret.

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Nebulino/Kitsumon/issues

##### Copyright © 2020 Nebulino