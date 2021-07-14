library g2x_predictions_container;

import 'package:flutter/material.dart';

class G2xPredictionsContainerController extends ValueNotifier<List<String>> {
  G2xPredictionsContainerController({List<String> value = const <String>[]}) : super(value);

  update(List<String> newValue){
    value = List.from(newValue);
    notifyListeners();
  }
}

class G2xPredictionsContainer extends StatefulWidget {
  final Widget child;
  final G2xPredictionsContainerController controller;
  final ScrollController? scrollController;
  const G2xPredictionsContainer({ Key? key, required this.child, required this.controller, this.scrollController }) : super(key: key);

  @override
  _G2xPredictionsContainerState createState() => _G2xPredictionsContainerState();
}

class _G2xPredictionsContainerState extends State<G2xPredictionsContainer> {
  OverlayEntry? overlayEntry;
  var internalList = <String>[];

  @override
  void initState() {
    widget.controller.addListener(update);
    widget.scrollController?.addListener(() {
      if(overlayEntry != null){
        disposeOverlayEntry();
      }
    });
    super.initState();
  }
  @override
  void dispose() {
     widget.controller.removeListener(update);
     disposeOverlayEntry();
    super.dispose();
  }

  disposeOverlayEntry(){
    overlayEntry?.remove();
    overlayEntry = null;
  }

  update(){
    internalList = widget.controller.value;
    if(internalList.length > 0 && overlayEntry == null){
      show();
    }
    else if(internalList.length == 0){
      disposeOverlayEntry();
    }
    overlayEntry?.markNeedsBuild();
  }

  void show(){
    overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(this.overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: List.generate(widget.controller.value.length, (index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.controller.value[index]),
              );
            })
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
