# SMI-1.0
Проект команды разработчиков интерпретатора, где lead - Голубкин Николай, developers - Зинкин Станислав и  Гугунов Сергей.

Для компиляции используйте Makefile:
```
$ make
```
или вручную в Linux, следуя шагам:
```
$ bison -d parser.y
$ flex lexer.l
$ gcc parser.tab.c lex.yy.c -o smi -lm
$ ./smi
```
