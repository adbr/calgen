calfix
======

Filtr tekstowy do poprawiania kalendarza wygenerowanego przez
calgen:
- usuwa gwiazdki w nagłówkach dni będących poniedziałkiem,
- usuwa numer tygodnia dla dni nie będących poniedziałkiem

Zamienia:
    *** 2019-01-07 Pon [w02] *
    *** 2019-01-08 Wto [w02]
    *** 2019-01-09 Śro [w02]
    *** 2019-01-10 Czw [w02]
    *** 2019-01-11 Pią [w02]
    *** 2019-01-12 Sob [w02]
    *** 2019-01-13 Nie [w02]
na:
    *** 2019-01-07 Pon [w02]
    *** 2019-01-08 Wto
    *** 2019-01-09 Śro
    *** 2019-01-10 Czw
    *** 2019-01-11 Pią
    *** 2019-01-12 Sob
    *** 2019-01-13 Nie

Sposób użycia:
./calfix < calendar-old.org > calendar-new.org
