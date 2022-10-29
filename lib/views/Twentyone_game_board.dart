import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text.dart';

class TwentyoneGameBoard extends StatefulWidget {
  const TwentyoneGameBoard({Key? key}) : super(key: key);

  @override
  State<TwentyoneGameBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TwentyoneGameBoard> {
  final SocketMethods _socketMethods = SocketMethods();
  late bool isIncButtonDisable;
  late bool isDecButtonDisable;
  @override
  int increment(int count, roomDataProvider) {
    if (temp >= 2) {
      isDecButtonDisable = true;
    } else {
      setState(() {
        isDecButtonDisable = false;
        temp++;
        count += temp;
      });
    }
    return 0;
  }

  @override
  int decrement(int count, roomDataProvider) {
    if (temp <= 0) {
      isDecButtonDisable = true;
    } else {
      setState(() {
        isDecButtonDisable = false;
        temp--;
        count += temp;
      });
    }

    print(count);
    return 0;
  }

  int temp = 0;
  @override
  void initState() {
    super.initState();
    isIncButtonDisable = false;
    isDecButtonDisable = true;
    _socketMethods.tappedListener(context);
  }

  void tapped(RoomDataProvider roomDataProvider) {
    _socketMethods.tapGrid(temp, roomDataProvider.roomData['_id']);
    setState(() {
      temp = 0;
    });
    print(temp);
  }

  void change(RoomDataProvider roomDataProvider) {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    int count = roomDataProvider.filledBoxes.toInt();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: AbsorbPointer(
        absorbing: roomDataProvider.roomData['turn']['socketID'] !=
            _socketMethods.socketClient.id,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => isIncButtonDisable
                      ? null
                      : increment(count, roomDataProvider),
                  iconSize: 100,
                  icon: Icon(
                    Icons.arrow_drop_up,
                  )),
              CustomText(shadows: [
                Shadow(
                  blurRadius: 40,
                  color: Colors.purple,
                )
              ], text: (count + temp).toString(), fontSize: 120),
              IconButton(
                  onPressed: () => isDecButtonDisable
                      ? null
                      : decrement(count, roomDataProvider),
                  iconSize: 100,
                  icon: Icon(
                    Icons.arrow_drop_down,
                  )),
              TextButton(
                onPressed: () => tapped(roomDataProvider),
                child: Text("Pass"),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple),
              )
            ],
          ),
        ),
      ),
    );
  }
}
