%{
/*
 * Author: Kurt O'Hearn 
 * Date: March 15, 2013
 * Class: CS 343-02
 * Assignment: Project 2 Calc+
 * Description: This project implements a simple intepreter using
 *  flex and bison to perform basic integer arthimetic.  Variables
 *  are support and dynamically allocated, and the symbol table
 *  is implemented using a hash map with lifo queues attached to
 *  each bin.
 *
 * This file provides the grammar template for bison to generate the parser. */

/* libraries and macros */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* number of bins to hash an identifier to */
#define n 10
/* max identifier length */
#define MAX_ID_LEN 255


/* global typedefs, variables */

/* symbol element */
typedef struct symbol_t {
    char *id;
    int value;
} Symbol;

/* queue element */
typedef struct lifenode {
    void *data;
    struct lifenode *next;
} LifoNode;

/* type alias for LIFO queue data structure */
typedef LifoNode *LifoQueue;

/* symbol table */
LifoQueue symbolTable[n];


/* parser function declarations */
void yyerror(char *s);

/* custom function declarations */
LifoQueue initLifoQueue();
void destroyLifoQueue(LifoQueue queue);
bool insertLifo(LifoQueue queue, void *data);
void* removeLifo(LifoQueue queue);
int identifierHash(char * id); 
int getSymbolValue(char *ident);
void updateSymbolValue(char *ident, int val);
void destroySymbolTable();
void initSymbolTable();
%}

/* bison type definitions */
%union {int num; char *id;}
/* define initial grammer construct */
%start line
/* define terminal types in grammer */
%token print
%token exit_command
%token <num> number
%token <id> identifier
/* define nonterminal types in grammer */
%type <num> line exp term factor
%type <id> assignment

%%

/* define productions in grammar and corresponding
 * actions for matched productions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{destroySymbolTable(); exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("%d\n", $2);}
		| exp ';'			    {printf("%d\n", $1);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("%d\n", $3);}
		| line exp ';'	        {printf("%d\n", $2);}
		| line exit_command ';'	{destroySymbolTable(); exit(EXIT_SUCCESS);}
        ;

assignment : identifier '=' exp {updateSymbolValue($1,$3);}
			;
exp    	: term                  {$$ = $1;}
        | exp '+' term          {$$ = $1 + $3;}
        | exp '-' term          {$$ = $1 - $3;}
       	;
term   	: factor                {$$ = $1;}
        | term '*' factor       {$$ = $1 * $3;}
        | term '/' factor       {$$ = $1 / $3;}
        ;
factor  : number                {$$ = $1;}
	    | identifier		    {$$ = getSymbolValue($1);} 
	    | '-' factor		    {$$ = -1*$2;} 
	    | '(' exp ')'		    {$$ = $2;} 
        ;

%%

/* custom functions */

/* instantiate an empty LIFO queue */
LifoQueue initLifoQueue()
{
    LifoQueue queue = (LifoQueue)malloc(sizeof(LifoNode));
    queue->data = NULL;
    queue->next = NULL;
    return queue;
}


/* destroys an existing queue and its content */
void destroyLifoQueue(LifoQueue queue)
{
    LifoNode *ptr = queue;
    Symbol *dptr; 
    char *idptr;
    while(ptr!=NULL) {
        /* set data pointer */
        dptr = (Symbol*) queue->data;
        if(dptr != NULL) {
            /* if the id was allocated, free */
            if(dptr->id != NULL) {
                idptr = dptr->id;
                free(idptr);
            }
            free(dptr);
        }
        queue = ptr->next;
        /* free the node and the Symbol data struct */
        free(ptr);
        /* move to the next node */
        ptr = queue;
    }
}

/* insert data into queue */
bool insertLifo(LifoQueue queue, void *data)
{
    bool retval = false;
    if((data != NULL) && (queue != NULL)) {
        if(queue->data == NULL) {
            queue->data = data;
            queue->next = NULL;
            retval = true;
        } else {
            LifoNode* newNode = (LifoNode*)malloc(sizeof(LifoNode));
            if(newNode != NULL) {
                newNode->data = queue->data;
                newNode->next = queue->next;
                queue->data = data;
                queue->next = newNode;
                retval = true;
            }
        }
    }
    return retval;
}


/* remove the next element from the queue */
void* removeLifo(LifoQueue queue)
{
    void *dptr = NULL;
    if(queue != NULL) {
        if(queue->next != NULL) {
            LifoNode* savePtr = queue->next;
            dptr = queue->data;
            queue->data = queue->next->data;
            queue->next = queue->next->next;
            free(savePtr);
        } else {
            dptr = queue->data;
            queue->data = NULL;
            queue->next = NULL;
        }
    }
    return dptr;
}


/* search through a queue for a node for
 * a particular identifier and, if found,
 * return a pointer to that node */
LifoNode* findLifo(char *ident, int bucket) {
    /* pointers for traversing the queue and its contents */
    LifoQueue queue = symbolTable[bucket];
    Symbol *dptr;

    /* if there's at least one node in the queue */
    while(queue != NULL) {
        /* set data pointer */
        dptr = queue->data;
        /* check to see if there's data */
        if(queue->data != NULL)
            /* if the identifer matches, return */
            if(strcmp(dptr->id, ident) == 0) {
                return queue;
            }
        /* traverse queue */
        queue = queue->next;
    }
    return NULL;
}


/* hash function on the sum of the ASCII values
 * of identifier */
int identifierHash(char *id) {
    /* sum variable */
    int idx = 0;

    /* null identifier and nonpositive bin number error checks */
    if(id == NULL)
        return -1;
    if(n <= 0)
        return -1;

    /* sum the ASCII values of the identifier */
    while(*id != '\0')
        idx += *id++;

    /* return sum modulo number of hash bins */
    return (idx%n);
}


/* returns the value of a given identifer */
int getSymbolValue(char *ident)
{
    /* get the hash bin which this identifer maps to */
	int bucket;
    bucket = identifierHash(ident);

    /* check to see if the identifer is in the queue */
    LifoNode *node = findLifo(ident, bucket);

    /* if found, return value */
    Symbol *dptr;
    if(node != NULL) {
        dptr = node->data;
        return dptr->value;
    }
    /* if not found, allocate space and add to symbol table */
    else {
        Symbol *sym = (Symbol*)malloc(sizeof(Symbol));
        if(sym != NULL) {
            /* note: strdup( ) calls malloc( ) implicitly */
            sym->id = (char*)malloc((MAX_ID_LEN+1)*sizeof(char));
            strcpy(sym->id, ident);
            sym->value = 0;
            insertLifo(symbolTable[bucket], sym);
        }
	    return 0;
    }
}


/* updates the value of a given symbol */
void updateSymbolValue(char *ident, int val)
{
    /* get the hash bin which this identifer maps to */
	int bucket;
    bucket = identifierHash(ident);

    /* check to see if the identifer is in the queue */
    LifoNode *node = findLifo(ident, bucket);

    /* if found, update */
    Symbol* dptr;
    if(node != NULL) {
        dptr = node->data;
        dptr->value = val;
    }
    /* if not found, allocate space and add to symbol table */
    else {
        dptr = (Symbol*)malloc(sizeof(Symbol));
        if(dptr != NULL) {
            /* create the data struct and
             * copy the data into the queue
             * note: strdup( ) calls malloc( ) implicitly */
            dptr->id = (char*)malloc((MAX_ID_LEN+1)*sizeof(char));
            strcpy(dptr->id, ident);
            dptr->value = val;
            insertLifo(symbolTable[bucket], dptr);
        }
    }
}


/* initialize the symbol table */
void initSymbolTable() {
    int i;
    for(i=0;i<n;i++)
        symbolTable[i] = initLifoQueue();
}


/* destroy the symbol table */
void destroySymbolTable() {
    int i;
    for(i=0;i<n;i++)
        destroyLifoQueue(symbolTable[i]);
}


int main (void) {
	/* init symbol table */
    initSymbolTable();

    /* version and usage info */
    puts("Calc+ 1.0 (default, 2013-03-15, 00:00:00)");
    puts("[Compiled with 4.7.2 20120921 (Red Hat 4.7.2-2)] on linux2");

	return yyparse();
}


/* bison error handling */
void yyerror (char *s) {
    fprintf (stderr, "%s\n", s);
} 
