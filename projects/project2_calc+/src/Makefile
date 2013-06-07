BASE=calc+

PARSER=$(shell which bison)
ifdef PARSER
PARSER=bison
PARSEROPTS=-y -d
else
PARSER=yacc
PARSEROPTS=-d
endif

LEXER=$(shell which flex)
ifdef LEXER
LEXER=flex
else
LEXER=lex
endif

all:
	echo $(PARSER)
	$(PARSER) $(PARSEROPTS) $(BASE).y
	$(LEXER) $(BASE).l
	gcc -o $(BASE) y.tab.c lex.yy.c
clean:
	rm y.tab.{c,h} lex.yy.c
