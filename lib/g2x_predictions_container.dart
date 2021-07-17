library g2x_predictions_container;

import 'package:flutter/material.dart';

class G2xPredictionsValue {
  final String displayText;
  final dynamic data;
  const G2xPredictionsValue({
    required this.displayText,
    required this.data,
  });
}

class G2xPredictionsContainerController extends ValueNotifier<List<G2xPredictionsValue>> {
  G2xPredictionsContainerController({List<G2xPredictionsValue> value = const <G2xPredictionsValue>[]}) : super(value);

  update(List<G2xPredictionsValue> newValue){
    value = List.from(newValue);
    notifyListeners();
  }
}

class G2xPredictionsContainer extends StatefulWidget {
  final Widget child;
  final G2xPredictionsContainerController controller;
  final ScrollController? scrollController;
  final Function(G2xPredictionsValue) onTap;
  const G2xPredictionsContainer({
    Key? key,
    required this.child,
    required this.controller,
    this.scrollController,
    required this.onTap,
  }) : super(key: key);

  @override
  _G2xPredictionsContainerState createState() => _G2xPredictionsContainerState();
}

class _G2xPredictionsContainerState extends State<G2xPredictionsContainer> {
  OverlayEntry? overlayEntry;
  var internalList = <G2xPredictionsValue>[];

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
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: (){
              disposeOverlayEntry();
            },
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5.0,
            width: size.width,
            child: Material(
              elevation: 4.0,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.generate(widget.controller.value.length, (index){
                  return GestureDetector(
                    onTap: (){
                      widget.onTap(widget.controller.value[index]);
                      disposeOverlayEntry();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.controller.value[index].displayText),
                    ),
                  );
                })
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
