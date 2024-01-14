import 'dart:math';

import 'package:collection/collection.dart';
import 'package:jaspr/html.dart';

class App extends StatefulComponent {
  @override
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  List<String> ips = <String>[];

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
        styles: const Styles.combine([
          Styles.background(color: Colors.black),
          Styles.box(radius: BorderRadius.circular(Unit.pixels(15)))
        ]),
        [
          p([
            h1([text("amogus")],
                styles: Styles.combine([
                  Styles.text(
                      color: Colors.white,
                      align: TextAlign.center,
                      fontSize: Unit.em(1.5))
                ]))
          ])
        ]);
    yield IPModel(ips, child: IPDisplay());
    yield DomComponent(
        tag: 'button',
        events: {
          'click': (e) {
            setState(() {
              ips.clear();
              for (int i = 0; i < 10; i++) {
                ips.add("amogus${Random.secure().nextInt(30)}");
              }
            });
          }
        },
        child: Text("Generate IPs"));
  }
}

class IPModel extends InheritedComponent {
  final List<String> ips;
  IPModel(this.ips, {required Component child}) : super(child: child);

  @override
  bool updateShouldNotify(IPModel oldComponent) {
    return ips.equals(oldComponent.ips);
  }
}

class IPDisplay extends StatelessComponent {
  const IPDisplay({Key? key}) : super(key: key);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    List<String> ipsGet =
        context.dependOnInheritedComponentOfExactType<IPModel>()!.ips;
    StringBuffer str = StringBuffer();
    for (String r in ipsGet) {
      str
        ..write(r)
        ..write("<br/>");
    }
    yield div([
      p([Text("Generated IPs:")],
          styles: Styles.combine([
            Styles.text(align: TextAlign.center, color: Colors.pink)
          ])),
      p([Text(str.toString(), rawHtml: true)])
    ],
        styles: Styles.flexbox(
            direction: FlexDirection.column,
            justifyContent: JustifyContent.center));
  }
}
