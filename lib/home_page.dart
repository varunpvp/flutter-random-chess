import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:flutter_stateless_chessboard/types.dart';

import 'utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    final size = min(viewport.height, viewport.width);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Chess"),
      ),
      body: Center(
        child: Chessboard(
          fen: _fen,
          size: size,
          orientation: ChessColor.WHITE,
          onPromote: () {
            return showDialog<PieceType>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Promotion'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Queen"),
                        onTap: () {
                          navigator.pop(PieceType.QUEEN);
                        },
                      ),
                      ListTile(
                        title: Text("Rook"),
                        onTap: () {
                          navigator.pop(PieceType.ROOK);
                        },
                      ),
                      ListTile(
                        title: Text("Bishop"),
                        onTap: () {
                          navigator.pop(PieceType.BISHOP);
                        },
                      ),
                      ListTile(
                        title: Text("Knight"),
                        onTap: () {
                          navigator.pop(PieceType.KNIGHT);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          onMove: (move) {
            final nextFen = makeMove(_fen, {
              'from': move.from,
              'to': move.to,
              'promotion':
                  move.promotion.map((t) => t.toString()).getOrElse(() => "q"),
            });

            if (nextFen != null) {
              setState(() {
                _fen = nextFen;
              });

              Future.delayed(Duration(milliseconds: 300)).then((_) {
                final computerMove = getRandomMove(_fen);
                final computerFen = makeMove(_fen, computerMove);

                if (computerMove != null && computerFen != null) {
                  setState(() {
                    _fen = computerFen;
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }
}
