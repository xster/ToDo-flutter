import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  int indicator;
  var toDo;
  bool expanded;
  var toggleExpand;
  var toggleToDo;
  var leftSwipe;
  var undoLeftSwipe;
  var rightSwipe;
  var undoRightSwipe;

  var reorderList;

  ToDo(
      this.indicator,
      this.toDo,
      this.expanded,
      this.toggleExpand,
      this.toggleToDo,
      this.leftSwipe,
      this.undoLeftSwipe,
      this.rightSwipe,
      this.undoRightSwipe,
      this.reorderList);

  @override
  State createState() => new ToDoState();
}

class ToDoState extends State<ToDo> {
  ThemeData _theme;
  bool _expanded;
  String _leftText;
  String _rightText;
  Icon _leftIcon;
  Icon _rightIcon;

  double _boxHeight;

  @override
  void initState() {
    super.initState();
    switch (config.indicator) {
      case 0:
        _leftText = 'ToDo archived';
        _rightText = 'ToDo deleted';
        _leftIcon = new Icon(Icons.archive, size: 36.0);
        _rightIcon = new Icon(Icons.delete, size: 36.0);
        break;
      case 1:
        _leftText = 'ToDo restored';
        _rightText = 'ToDo deleted';
        _leftIcon = new Icon(Icons.unarchive, size: 36.0);
        _rightIcon = new Icon(Icons.delete, size: 36.0);
        break;
      default:
        _leftText = 'ToDo restored';
        _rightText = 'ToDo deleted';
        _leftIcon = new Icon(Icons.restore_from_trash, size: 36.0);
        _rightIcon = new Icon(Icons.delete_forever, size: 36.0);
        break;
    }
  }

  void _onDragStart() {
    config.toggleExpand(config.toDo, false);
    Scaffold.of(context).showBottomSheet((context) {
      return new Container(
        decoration: new BoxDecoration(
            border:
                new Border(top: new BorderSide(color: _theme.dividerColor))),
        child: new Row(
          children: [
            new Expanded(
              flex: 1,
              child: new DragTarget(
                builder: (context, a, b) {
                  return _leftIcon;
                },
                onAccept: (data) {
                  _leftSwipe();
                  Navigator.pop(context);
                },
              ),
            ),
            new SizedBox(
              width: 1.0,
              height: 48.0,
              child: new Container(
                decoration:
                    new BoxDecoration(backgroundColor: _theme.dividerColor),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new DragTarget(
                builder: (context, a, b) {
                  return _rightIcon;
                },
                onAccept: (data) {
                  _rightSwipe();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onDragCancel() {
    Navigator.pop(context);
  }

  void _leftSwipe() {
    config.leftSwipe(config.toDo, false);
    Scaffold.of(context).showSnackBar(
          new SnackBar(
            duration: new Duration(seconds: 2),
            content: new Text(_leftText),
            action: new SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                config.undoLeftSwipe(config.toDo, true);
              },
            ),
          ),
        );
  }

  void _rightSwipe() {
    config.rightSwipe(config.toDo, false);
    Scaffold.of(context).showSnackBar(
          new SnackBar(
            duration: new Duration(seconds: 2),
            content: new Text(_rightText),
            action: new SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                config.undoRightSwipe(config.toDo, true);
              },
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _theme = Theme.of(context);
      _expanded = config.expanded;
      _boxHeight = _expanded ? 64.0 : 0.0;
    });
    return new Stack(
      key: new ObjectKey(config.toDo),
      children: [
        new LongPressDraggable(
          data: config.toDo,
          feedback: new SizedBox(
            width: MediaQuery.of(context).size.width,
            child: new Card(
              elevation: 4,
              child: new ListItem(
                dense: true,
                leading: new IconButton(
                  icon: new Icon(
                    config.toDo['done']
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: config.toDo['done'] ? Colors.green[600] : null,
                  ),
                  onPressed: () {},
                ),
                title: new Text(config.toDo['title']),
                subtitle: new Text(config.toDo['subtitle']),
              ),
            ),
          ),
          childWhenDragging: new Card(
            elevation: 0,
            child: new ListItem(
              dense: true,
              title: new Text(''),
              subtitle: new Text(''),
            ),
          ),
          child: new Card(
            elevation: 2,
            child: new Column(
              children: [
                new ListItem(
                  dense: true,
                  leading: new IconButton(
                    icon: new Icon(
                      config.toDo['done']
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: config.toDo['done'] ? Colors.green[600] : null,
                    ),
                    onPressed: config.toggleToDo is Function
                        ? () => config.toggleToDo(config.toDo)
                        : () {},
                  ),
                  title: new Text(config.toDo['title']),
                  subtitle: new Text(config.toDo['subtitle']),
                  trailing: _expanded ?
                    new Icon(Icons.keyboard_arrow_up)
                      : new Container(),
                  onTap: () {
                    config.toggleExpand(config.toDo, !_expanded);
                  },
                ),
                new AnimatedContainer(
                  height: _boxHeight,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  child: new Container(
                          alignment: FractionalOffset.topLeft,
                          padding:
                              new EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 12.0),
                          child: new Text(
                            config.toDo['description'].length >= 140
                                ? config.toDo['description'].substring(0, 140) +
                                    '...'
                                : config.toDo['description'],
                            textScaleFactor: 0.9,
                          ),
                        ),
//                      config.indicator == 0
//                          ? new Container(
//                              alignment: FractionalOffset.bottomRight,
//                              padding: new EdgeInsets.only(right: 12.0),
//                              child: new IconButton(
//                                icon: new Icon(Icons.edit),
//                                onPressed: () {
//                                      Navigator.push(
//                                        context,
//                                        new MaterialPageRoute(
//                                          builder: (context) {
//                                            return new ToDoDetail();
//                                          },
//                                        ),
//                                      );
//                                },
//                              ),
//                            )
//                          : new Container(),
                ),
              ],
            ),
          ),
          onDragStarted: () {
            _onDragStart();
          },
          onDraggableCanceled: (o, v) {
            _onDragCancel();
          },
        ),
        new DragTarget(
          onAccept: (data) {
            config.reorderList(data, config.toDo);
            Navigator.pop(context);
          },
          builder: (context, a, b) {
            return new AnimatedContainer(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 200),
              height: 60.0 + _boxHeight,
            );
          },
        ),
      ],
    );
  }
}
