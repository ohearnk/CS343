/* Author: Kurt O'Hearn
 * Date: February 1, 2013
 * Class: CS 343-02
 * Assignment: Project 1
 * Description: This program performs textual drawing
 *  according to the state-based concept of turtle graphics.
 *  Drawing commands are read in from a file and rendered to
 *  another file (by default).  */

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* file length constant */
#define MAX_LEN 20
/* turtle constants */
#define N 0
#define E 1
#define S 2
#define W 3
#define UP 0
#define DOWN 1
/* board characters */
#define BLANK_CHAR ' '
#define DRAW_CHAR '*'

/* turtle struct for drawing info */
typedef struct {
    /* vertical axis on drawing board */
    int x_pos;
    /* horizontal axis on drawing board */
    int y_pos;
    /* direction turtle is facing 
 *      I.e., one of the following: N, E, S, W */
    int dir;
    /* position that pen is in
 *      I.e., one of the following: UP, DOWN */
    int pen_pos;
} turtle_t;

/* macros */
#define MAX(i,j) (i>j?i:j)
#define MIN(i,j) (i<j?i:j)

/* valid short (single-character) command-line arguments 
 * Note: characters with a colon following them have
 *  associated required arguements, while characters with
 *  two colons following have optional arguments */
static const char *opt_string = "hs";

/* struct of pointers to option structs for long arguments 
 * Note: the four fields in option are: 
 *  long_arg_nane, arg_opts, flag, arg_int_val
 * where if flag == NULL, arg_int_val is returned,
 * else 0 is returned 
 * Note 2: the last element must be all zeros */
static const struct option long_opts[] = {
    { "help", no_argument, NULL, 'h' },
    { "stdout", no_argument, NULL, 's' },
    { NULL, no_argument, NULL, 0 }
};

/* index of the specified argument in long_opts[] */
int long_opts_index;

/* global indicating whether or not --stdout flag is set */
int stdout_opt = 0;

/* print usage info and exit */
void usage() {
    puts("Usage: turtle [OPTIONS] bsize input_file output_file");
    puts("Try 'turtle --help' for more information.");
    exit(EXIT_FAILURE);
}


/* print help message and exit */
void print_help() {
    puts("Usage: turtle [OPTIONS] bsize input_file output_file");
    puts("DESCRIPTION:");
    puts("\tThis is a turtle graphics program.");
    puts("ARGUMENTS:");
    puts("\tbsize:\t\tintegral dimensions of the drawing board");
    puts("\tinput_file:\tfile to read drawing commands from");
    puts("\toutput_file:\tfile to write drawing board to");
    puts("OPTIONS:");
    puts("\t-h, --help\tPrint this message");
    puts("\t-s, --stdout\tWrite board to STDOUT upon issuing a draw board (6) command");
    exit(EXIT_SUCCESS);
}


/* process command-line arguments */
void process_args(int *bsize, FILE **fp_in, FILE **fp_out, 
int argc, char *argv[]) {
    /* input and output file names */
    char in_file[MAX_LEN], out_file[MAX_LEN];
    /* used for arg parsing in getopt_long( ) */
    int opt;

    /* process all command-line options */
    opt = getopt_long(argc, argv, opt_string, long_opts, &long_opts_index);
    while(opt != -1) {
        switch(opt) {
            case 'h':
                print_help();
                break;
            case 's':
                stdout_opt = 1;
                break;
            default:
                usage();
                break;
        }
        opt = getopt_long(argc, argv, opt_string, long_opts, &long_opts_index);
    }
    
    /* process required input */
    if((argc - optind + 1) != 4) {
        usage();
    }
    
    *(bsize) = atoi(argv[optind]);
    strcpy(in_file, argv[optind+1]);
    strcpy(out_file, argv[optind+2]);

    if(*(bsize) <= 0) {
        puts("ERROR: size must be integer > 0.");
        exit(EXIT_FAILURE);
    }

    /* open file pointers */
    *fp_in = fopen(in_file, "r");
    if(*fp_in == NULL) {
        printf("ERROR: Unable to open %s for reading.\n", in_file);
        exit(EXIT_FAILURE);
    }
    *fp_out = fopen(out_file, "w");
    if(*fp_out == NULL) {
        printf("ERROR: Unable to open %s for writing.", out_file);
        exit(EXIT_FAILURE);
    }
}


/* execute the drawing commands in the input file */
void draw(turtle_t *turtle, char *floor, int bsize, FILE **fp_in) {
    /* command buffer */
    char buffer[MAX_LEN];
    /* delimiters for the tokenizer */
    char * delim = " ,\r\n";
    /* tokenizer buffer holding one token */
    char * token;
    /* temporary variable holding the x- or y-coordinate
 *      of the turtle's old position before moving */
    int old_pos;
    /* counter varible */
    int i;

    /* read in commands */
    fgets(buffer, MAX_LEN, *fp_in);
    while(feof(*fp_in) == 0) {
        /* tokenize input, error check */
        if((token = strtok(buffer, delim)) == NULL) {
            printf("Error: no command.\n");
            exit(0);
        }
        if(strlen(token) != 1) {
            printf("Error: unrecognized command %s\n", token);
            exit(0);
        }
        /* commands */
        switch(token[0]) {
            /* pen up */
            case '1':
                turtle->pen_pos = UP;
                break;
            /* pen down */
            case '2':
                turtle->pen_pos = DOWN;
                floor[bsize*turtle->x_pos+turtle->y_pos] = DRAW_CHAR;
                break;
            /* rotate clockwise*/
            case '3':
                turtle->dir = (turtle->dir+1)%4;
                break;
            /* rotate counter-clockwise*/
            case '4':
                turtle->dir = (turtle->dir-1);
                /* mod operator on this machine returns
 *                  an integer less than zero if the dividend
 *                  is less then zero; threshold manually
 *                  and avoid the operation */
                if(turtle->dir < 0)
                    turtle->dir = W;
                break;
            /* move forward */
            case '5':
                /* get the next token in the input buffer */
                if((token = strtok(NULL, delim)) == NULL) {
                    printf("Error: no command.\n");
                    exit(0);
                }
                /* switch based on direction facing */
                switch(turtle->dir) {
                    case N:
                        old_pos = turtle->x_pos;
                        turtle->x_pos = MAX(0, 
                            turtle->x_pos - atoi(token));
                        if(turtle->pen_pos == DOWN)
                            for(i=old_pos; i >= turtle->x_pos; i--)
                                floor[bsize*i+turtle->y_pos] = DRAW_CHAR;
                        break;
                    case E:
                        old_pos = turtle->y_pos;
                        turtle->y_pos = MIN(bsize - 1, 
                            turtle->y_pos + atoi(token));
                        if(turtle->pen_pos == DOWN)
                            for(i=old_pos; i <= turtle->y_pos; i++)
                                floor[bsize*turtle->x_pos+i] = DRAW_CHAR;
                        break;
                    case S:
                        old_pos = turtle->x_pos;
                        turtle->x_pos = MIN(bsize - 1, 
                            turtle->x_pos + atoi(token));
                        if(turtle->pen_pos == DOWN)
                            for(i=old_pos; i <= turtle->x_pos; i++)
                                floor[bsize*i+turtle->y_pos] = DRAW_CHAR;
                        break;
                    case W:
                        old_pos = turtle->y_pos;
                        turtle->y_pos = MAX(0, 
                            turtle->y_pos - atoi(token));
                        if(turtle->pen_pos == DOWN)
                            for(i=old_pos; i >= turtle->y_pos; i--)
                                floor[bsize*turtle->x_pos+i] = DRAW_CHAR;
                        break;
                }
                break;
            /* display floor */
            case '6':
                break;
            default:
                printf("Command not recognized.");
                break;
        }
        fgets(buffer, MAX_LEN, *fp_in);
    }
}


/* write board out to file */
void write_board_to_file(char *floor, int bsize, FILE *fp_out) {
    /* buffer to rendering one row of the board */
    char buffer[bsize+4];
    /* counter variables */
    int i,j;

    /* render the board by rows*/

    /* top border */
    for(i=0;i<bsize+2;i++)
        buffer[i] = '-';
    buffer[bsize+2] = '\n';
    buffer[bsize+3] = '\0';
    fputs(buffer, fp_out);
    if(stdout_opt)
        fputs(buffer, stdout);
    /* create string of board row */
    for(i=0;i<bsize;i++) {
        /* left border */
        buffer[0] = '|';
        for(j=1;j<bsize+1;j++) {
            buffer[j] = floor[i*bsize+(j-1)];
        }
        /* right border */
        buffer[bsize+1] = '|';
        buffer[bsize+2] = '\n';
        buffer[bsize+3] = '\0';
        /* write row to file */
        fputs(buffer, fp_out);
        if(stdout_opt)
            fputs(buffer, stdout);
    }
    /* bottom border */
    for(i=0;i<bsize+4;i++)
        buffer[i] = '-';
    buffer[bsize+2] = '\n';
    buffer[bsize+3] = '\0';
    fputs(buffer, fp_out);
    if(stdout_opt)
        fputs(buffer, stdout);
}


int main(int argc, char *argv[]) {
    /* file pointers for input and output, respectively*/
    FILE *fp_in, *fp_out;
    /* user-specifed board size */
    int bsize;
    /* instantiate and initialize the turtle */
    turtle_t turtle = {.x_pos = 0, .y_pos = 0, .dir = E, .pen_pos = UP};
    /* drawing board */
    char *floor;
    /* counter variables */
    int i,j;

    /* process optional and required command-line arguments */
    process_args(&bsize, &fp_in, &fp_out, argc, argv);

    /* allocate space for the board */
    floor = malloc((unsigned int)(bsize*bsize*sizeof(char)));

    /* initialize board to zeroes */
    for(i=0;i<bsize;i++)
        for(j=0;j<bsize;j++)
            floor[i*bsize+j] = BLANK_CHAR;

    /* draw! */
    draw(&turtle, floor, bsize, &fp_in);
    
    /* close input file pointer */
    fclose(fp_in);

    /* output result */
    write_board_to_file(floor, bsize, fp_out);

    /* free drawing board */
    free(floor);

    /* close output file pointer */
    fclose(fp_out);
    
    return 0;
}
