# simple_stopwatch_in_assembly
Działanie stopera:
  - rozdzielczość wyświetlania czasu wynosi 10ms, maksymalny czas wyświetlany przez stoper to 99,99, po przekroczeniu tej wartości stoper jest zerowany i kontynuuje liczenie,
  - po uruchomieniu ekran LCD wyświetla wartość 00,00 (format ss,MM, gdzie ss - sekundy, MM - dziesiątki milisekund),
  - użytkownik może uruchomić/zatrzymać pracę stopera przyciskiem ENTER (wartość hex == F),
  - każde 10 s odliczonego przez stoper czasu jest sygnalizowane dźwiękiem brzęczka o czasie 0,5s,
  - po zatrzymaniu pracy stopera, wyświetlany jest ostatni czas zmierzony przez stoper,
  - po wznowieniu pracy stopera, odliczanie czasu jest kontynuowane od ostatniego czasu zmierzonego przez stoper,
  - realizacja mierzenia czasu i sygnalizacji upływu zmierzonych 10 s jest zrealizowana za pomocą dwóch osobnych przerwań (dwóch Timerów).
