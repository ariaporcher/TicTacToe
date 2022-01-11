#include <stdio.h>
#include <stdlib.h>

void drawBoard(char board[]){

  for(int i = 0; i < 16; i++){

    if(board[i] == 48){
      printf(" %c"," ");
    }

    else{
      printf("%c", board[i]);
    }

    if((i == 3) || (i == 7) || (i == 11) || (i == 15)){
      printf("\n");
      printf("______________");
      printf("\n");
    }

    else{

      printf(" | ");
    }
  }
  
  printf("\n");
  
}


