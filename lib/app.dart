import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fake_fake_ip/parts.dart';
import 'package:fake_fake_ip/shared.dart';
import 'package:jaspr/html.dart';

class App extends StatefulComponent {
  @override
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  List<String> ips = <String>[]; // this is so bad

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      span([
        p([text("Fake")],
            styles: Styles.text(
                fontWeight: FontWeight.w900,
                color: Config.primary1,
                fontSize: Unit.em(3.4))),
        p([text("&nbsp;IP&nbsp;Generator", rawHtml: true)],
            styles: Styles.text(
                fontWeight: FontWeight.w900,
                color: Config.primary2,
                fontSize: Unit.em(3.4)))
      ],
          styles: Styles.flexbox(
              direction: FlexDirection.row,
              alignItems: AlignItems.center)),
      a([text("made by exoad")],
          href: "https://github.com/exoad",
          styles: Styles.text(
              fontFamily: FontFamily("Patrick Hand"),
              color: Config.secondary1,
              decoration: TextDecoration(
                  color: Color.unset,
                  line: TextDecorationLine.none,
                  thickness:
                      TextDecorationThickness.value(Unit.zero)))),
      strut(height: 0.3),
      div([
        SimpleButtonComponent(
            label: "Generate IPv4",
            onPressed: () => setState(() {
                  for (int i = 0; i < 10; i++) {
                    ips.add("amogus${Random.secure().nextInt(30)}");
                  }
                }),
            style: SimpleButtonComponent.defaultStyle()),
        SimpleButtonComponent(
            label: "Generate IPv4",
            onPressed: () => setState(() {
                  for (int i = 0; i < 10; i++) {
                    ips.add("amogus${Random.secure().nextInt(30)}");
                  }
                }),
            style: SimpleButtonComponent.defaultStyle()),
        SimpleButtonComponent(
            label: "Generate IPv6",
            onPressed: () => setState(() {
                  for (int i = 0; i < 10; i++) {
                    ips.add("amogus${Random.secure().nextInt(30)}");
                  }
                }),
            style: (
              bg: Config.primary2,
              fg: Config.bg,
              onClick: Config.primary2Darker2,
              onHover: Config.primary2Darker1
            )),
        SimpleButtonComponent(
            label: "Clear",
            onPressed: () => setState(() {
                  ips.clear();
                }),
            style: SimpleButtonComponent.defaultStyle()),
        SimpleButtonComponent(
            label: "Copy",
            onPressed: () => {/* need impl */},
            style: (
              bg: Config.primary2,
              fg: Config.bg,
              onClick: Config.primary2Darker2,
              onHover: Config.primary2Darker1
            )),
      ],
          styles: Styles.combine([
            Styles.raw({"gap": "0.2em"}),
            Styles.flexbox(
                direction: FlexDirection.row,
                alignItems: AlignItems.center,
                justifyContent: JustifyContent.center)
          ])),
      IPModel(ips, child: IPDisplay()),
    ],
        styles: Styles.combine([
          Styles.raw({
            "transition": "0.2s",
            "transition-timing-function":
                "cubic-bezier(.43,.51,.25,.85)",
          }),
          Styles.flexbox(
              direction: FlexDirection.column,
              justifyContent: JustifyContent.center,
              alignItems: AlignItems.center),
          Styles.box(padding: EdgeInsets.all(Unit.em(5.8))),
          Styles.text(
            fontFamily: FontFamily("Fira Sans"),
          )
        ]));
  }
}

Component ipLabel(String label, {required bool isClient}) =>
    SimpleButtonComponent(
        label: label,
        onPressed: () {},
        style: SimpleButtonComponent.defaultStyle());

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
      str.write(r);
    }
    yield div([
      p([
        Text(
            "Generated IPs ${ipsGet.isEmpty ? "" : ipsGet.length}: ")
      ],
          styles: Styles.combine([
            Styles.text(
                align: TextAlign.center,
                color: Config.secondary1,
                fontWeight: FontWeight.bold,
                fontSize: Unit.em(1.1),
                fontFamily: FontFamily("Fira Sans"))
          ])),
    ],
        styles: Styles.flexbox(
            direction: FlexDirection.column,
            justifyContent: JustifyContent.center,
            alignItems: AlignItems.baseline));
    yield div([
      p([Text(str.toString(), rawHtml: false)])
    ],
        styles: Styles.flexbox(
            alignItems: AlignItems.baseline,
            direction: FlexDirection.row,
            wrap: FlexWrap.wrap));
  }
}
