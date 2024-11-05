import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerScreen(),
    );
  }
}

// Класс для управления состоянием таймера
class TimerModel with ChangeNotifier {
  Timer? _timer;
  int _start = 10; // Начальное значение таймера в секундах

  int get start => _start;

  // Метод для старта таймера
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        _start--;
        notifyListeners(); // Уведомляем слушателей об изменении
      } else {
        _timer?.cancel();
      }
    });
  }

  // Метод для обновления таймера
  void refreshTimer() {
    _start = 10; // Сбрасываем таймер
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Таймер')),
      body: Center(
        child: Consumer<TimerModel>(
          builder: (context, timerModel, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Осталось времени: ${timerModel.start} секунд',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: timerModel.startTimer,
                child: Text('Запустить таймер'),
              ),
              ElevatedButton(
                onPressed: timerModel.refreshTimer,
                child: Text('Обновить таймер'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
