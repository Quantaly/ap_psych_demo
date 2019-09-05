import 'dart:convert';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';

typedef LogDownloader = void Function(List<ChallengeLog> log);

abstract class DemoState {
  String get header;

  bool get buttonsEnabled => true;
}

class InitialState extends DemoState {
  @override
  final header = "Press either button to start";
}

class DisplayState extends DemoState {
  @override
  final String header;
  @override
  final bool buttonsEnabled = false;

  DisplayState(this.header);
}

class PromptState extends DemoState {
  @override
  final String header;
  final bool correct;

  PromptState(this.header, this.correct);
}

class EndState extends DemoState {
  @override
  String get header =>
      "Sorry, you are wrong. Your final score was $score characters.";

  final int score;

  @override
  final bool buttonsEnabled = false;

  EndState(this.score);
}

class VictoryState extends DemoState {
  @override
  final String header =
      "Congratulations, you have run out of letters in the alphabet. "
      "I guess that means you win?";

  @override
  final bool buttonsEnabled = false;
}

class ChallengeLog {
  String display;
  String prompt;
  bool correct;

  Map<String, dynamic> toJson() => {
        "display": display,
        "prompt": prompt,
        "correct": correct,
      };
}

class DemoBloc extends Bloc<bool, DemoState> {
  int charsCount = 3;
  final List<ChallengeLog> log = [];
  final _rand = math.Random();

  final LogDownloader download;
  DemoBloc(this.download);

  @override
  final initialState = InitialState();

  @override
  Stream<DemoState> mapEventToState(bool event) async* {
    final prevState = currentState;
    if (prevState is InitialState) {
      yield* presentChallenge();
    } else if (prevState is DisplayState) {
      yield prevState;
    } else if (prevState is PromptState) {
      log.last.correct = prevState.correct == event;
      if (prevState.correct == event) {
        charsCount++;
        if (charsCount > 26) {
          download(log);
          yield VictoryState();
          return;
        }
        yield* presentChallenge();
      } else {
        download(log);
        yield EndState(charsCount);
      }
    } else if (prevState is EndState) {
      yield prevState;
    }
  }

  static final chars = [
    for (var i = 0; i < 26; i++) ascii.decode([i + 65])
  ];
  Stream<DemoState> presentChallenge() async* {
    var shuffled = chars.toList()..shuffle(_rand);
    var display = shuffled.take(charsCount).join();
    yield DisplayState(display);
    await Future.delayed(const Duration(seconds: 5));
    var correct = _rand.nextBool();
    String prompt;
    if (correct) {
      prompt = shuffled[_rand.nextInt(charsCount)];
    } else {
      prompt = shuffled[charsCount + _rand.nextInt(26 - charsCount)];
    }
    log.add(ChallengeLog()
      ..display = display
      ..prompt = prompt);
    yield PromptState(prompt, correct);
  }
}
