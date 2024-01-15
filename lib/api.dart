import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:jaspr/html.dart';

final Random _rng = Random();

@immutable
class Api {
  static Future<List<String>> ipv4(
      [double chance = 0.4, int amount = 10]) async {
    List<String> ips = <String>[];
    bool genned = false;
    for (int i = 0; i < amount; i++) {
      if (!genned) {
        double r = _rng.nextDouble();
        if (r <= chance) {
          ips.add(await _IPRest.readIpv4());
          genned = true;
        }
      } else {
        ips.add(_getRandomIpv4());
      }
    }
    return ips;
  }

  static Future<List<String>> ipv6(
      [double chance = 0.4, int amount = 10]) async {
    List<String> ips = <String>[];
    bool genned = !_isIpv6Usable();
    for (int i = 0; i < amount; i++) {
      if (!genned) {
        double r = _rng.nextDouble();
        if (r <= chance) {
          ips.add(await _IPRest.readIpv6());
          genned = true;
        }
      } else {
        ips.add(_getRandomIpv6());
      }
    }
    return ips;
  }
}

bool _isIpv6Usable() {
  bool res = false;
  InternetAddress.lookup("google.com")
      .then((List<InternetAddress> value) {
    res = value
        .any((element) => element.type == InternetAddressType.IPv6);
  });
  return res;
}

String _getRandomIpv4() {
  List<int> octets = <int>[];
  for (int i = 0; i < 4; i++) {
    octets[i] = _rng.nextInt(256);
  }
  return "${octets[0]}.${octets[1]}.${octets[2]}.${octets[3]}";
}

String _getRandomIpv6() {
  StringBuffer buff = StringBuffer();
  for (int i = 0; i < 8; i++) {
    buff.write(_rng.nextInt(65536).toRadixString(16).toUpperCase());
    if (i < 7) {
      buff.write(":");
    }
  }
  return buff.toString();
}

class _IPRest {
  static Future<String> readIpv4() async {
    var res =
        await get(Uri.parse("https://api.ipify.org?format=json"));
    if (res.statusCode == 200) {
      return res
          .body; // we requested from ipfiy as a simple string (no json formatting)
    }
    return _getRandomIpv4();
  }

  static Future<String> readIpv6() async {
    var res = await get(Uri.parse(
        "https://api64.ipify.org?format=json")); // this will return an ipv4 if the user does not have ipv6 setup. so we have to use the _isIpv6Usable
    if (res.statusCode == 200) {
      return res.body;
    }
    return _getRandomIpv6();
  }
}
