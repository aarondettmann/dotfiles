/***************************************************************************
*  wakeupneo.c -- "The Matrix" scence written in C                         *
*  Copyright (C) 2014,2018 edloaa <edloaa at gmail dot com>                *
*                                                                          *
*  This program is free software: you can redistribute it and/or modify    *
*  it under the terms of the GNU General Public License as published by    *
*  the Free Software Foundation, either version 3 of the License, or       *
*  (at your option) any later version.                                     *
*                                                                          *
*  This program is distributed in the hope that it will be useful,         *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
*  GNU General Public License for more details.                            *
*                                                                          *
*  You should have received a copy of the GNU General Public License       *
*  along with this program.  If not, see <https://www.gnu.org/licenses/>.  *
***************************************************************************/

#include <stdio.h>
#include <unistd.h> // usleep()
#include <signal.h> // signal()
#include <stdlib.h> // exit()
#include <time.h>   // time()

#define BGREEN "\033[32;1m"
#define RESET  "\033[0m"
#define CLEAR  "\033[H\033[0J"

// "\033[H"    // move cursor to upper-left corner of the screen
// "\033[0J"   // clear from cursor to end of the screen
// "\033[?25l" // hide cursor

void sighandler(int);
void type(char*);

int main(void)
{
    char *msg1 = "Wake up, Neo...\nThe Matrix has you...\nFollow the white rabbit.\n";

    signal(SIGINT, sighandler);
    srand(time(NULL));
    printf(CLEAR BGREEN);

    type(msg1);
    printf("Knock, kock, Neo.");
    fflush(stdout);

    usleep(2000000);
    printf(RESET "\n" CLEAR);

    return 0;
}

void sighandler(int sigint)
{
    printf(RESET "\n" CLEAR);
    exit(sigint);
}

void type(char *m)
{
    int n;

    for(n=0; m[n]!='\0'; n++)
    {
        if( m[n] == '\n' )
        {
            usleep(1000000);
            printf(CLEAR);
            continue;
        }

        printf("%c", m[n]);
        fflush(stdout);
        usleep((rand()%(100000))+100000); // (rand()%(max-min))+min
    }
}

