import 'package:fake_fake_ip/shared.dart';
import 'package:jaspr/html.dart';

Component strut({double? width, double? height}) => div([
      p([text(" ")])
    ], // this is so cursed, but my most intuitive solution :/ (i hate webdev so much)
        styles: Styles.box(
            padding: EdgeInsets.only(
                left: Unit.em((width ?? 0) / 2),
                right: Unit.em((width ?? 0) / 2),
                top: Unit.em((height ?? 0) / 2),
                bottom: Unit.em((height ?? 0) / 2))));

typedef ButtonConfig = ({
  Color fg,
  Color bg,
  Color onHover,
  Color onClick
});

class SimpleButtonComponent extends StatefulComponent {
  static ButtonConfig defaultStyle() => (
        bg: Config.primary1,
        fg: Config.bg,
        onHover: Config.primary1Darker1,
        onClick: Config.primary1Darker2
      );

  final String label;
  final void Function() onPressed;
  final ButtonConfig style;
  final Component? icon;

  SimpleButtonComponent(
      {required this.label,
      this.icon,
      required this.onPressed,
      required this.style});

  @override
  State<SimpleButtonComponent> createState() {
    return _SimpleButtonState();
  }
}

class _SimpleButtonState extends State<SimpleButtonComponent> {
  late Color appropriateBgColor;

  @override
  void initState() {
    super.initState();
    appropriateBgColor = component.style.bg;
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
        tag: 'button',
        events: {
          'click': (e) => component.onPressed.call(),
          'mousedown': (e) => setState(
              () => appropriateBgColor = component.style.onClick),
          'mouseup': (e) =>
              setState(() => appropriateBgColor = component.style.bg),
          'mouseover': (e) => setState(
              () => appropriateBgColor = component.style.onHover),
          'mouseout': (e) =>
              setState(() => appropriateBgColor = component.style.bg)
        },
        styles: Styles.combine([
          Styles.raw({
            "transition": "0.2s",
            "transition-timing-function":
                "cubic-bezier(.53,.39,.39,.81)",
          }),
          Styles.box(
            border: Border.unset,
            radius:
                BorderRadius.all(Radius.circular(Config.roundCorner)),
          ),
          Styles.background(color: appropriateBgColor)
        ]),
        child: div([
          if (component.icon != null) component.icon!,
          p([text(component.label)],
              styles: Styles.combine([
                Styles.box(
                    padding: EdgeInsets.only(
                        left: Unit.em(0.3),
                        top: Unit.zero,
                        bottom: Unit.zero,
                        right: Unit.em(0.3))),
                Styles.text(
                    lineHeight: Unit.em(0.0001),
                    fontSize: Unit.em(1.1),
                    fontWeight: FontWeight.normal,
                    color: component.style.fg)
              ]))
        ]));
  }
}
