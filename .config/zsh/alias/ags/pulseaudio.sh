alias pal="nu -c 'pactl list short sinks | detect columns --no-headers | select column0 column1 column2 column3 column4 column5 column6 | rename ID NAME DRIVER FORMAT CHANNEL FRECUENCY STATE'"
alias pas="pactl set-default-sink"
