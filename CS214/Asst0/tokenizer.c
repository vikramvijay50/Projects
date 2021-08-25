#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

int arrLocation; //keeps track of position while traversing string
int lastToken; //keeps track of previous token type. 0 = decimal int, 1= octal, 2 = hex, 3 = float, 4 = word, 5 = any operator


//handles printing out floating point numbers 
static void printFloat(char* input, char* temp, int i, int j){

  while(input[i] != '\0' && input[i] != ' ' && input[i] != '\t' && input[i] != '\v' && input[i] != '\f' && input[i] != '\n' && input[i] != '\r'){
    if(input[i] == '.'){
      temp[j] = input[i];
      i++;
      j++;
      continue;
    }
    if(input[i] == 'e'){
      temp[j] = input[i];
      i++;
      j++;
      continue;
    }
    if(input[i] == '-'){
      if(input[i-1] == 'e'){
        temp[j] = input[i];
        i++;
        j++;
        continue;
      }
    }
    if(isdigit(input[i]) == 0){
      break;
    }
    temp[j] = input[i];
    i++;
    j++;
  }
  lastToken = 3;
  printf("floating point: \"%s\"\n", temp);
  arrLocation = i;

}

//handles printing out octal numbers
static void printOctal(char* input, char* temp, int i, int j){

  while(input[i] != '\0' && input[i] != ' ' && input[i] != '\t' && input[i] != '\v' && input[i] != '\f' && input[i] != '\n' && input[i] != '\r'){
    //covers case when input is "03.4"
    if(input[i] == '.' && isdigit(input[i+1]) != 0){
      printFloat(input, temp, i, j);
      return;
    }
    
    if(isdigit(input[i]) == 0){
        break;
    }
    temp[j] = input[i];
    i++;
    j++;
    if(input[i+1] == '8' || input[i+1] == '9'){
      temp[j] = input[i];
      i++;
      break;
    }
  }
  lastToken = 1;
  printf("octal integer: \"%s\"\n", temp);
  arrLocation = i;

}


static bool isSimpleOperator(char c){//checks if a char is a simple operator ie requires only 1 char.

  if(c == '(' || c == ')' || c == '[' || c == ']' || c == '.' || c == ',' || c == '~' || c == '?' || c == ':' ){
    return true;
  }
return false;
}

static bool couldBeComplex(char c){//checks if a char could be a complex operator ie require multiple chars.
  
  if(c == '-' || c == '+' || c == '<' || c == '>' || c == '|' || c == '&' || c == '=' || c == '!' || c == '*' || c == '/' || c == '%' || c == '^' ){
    return true;
  }
return false;
}

static bool isDelim(char c){//checks if a character is a delimitor
  if(c != '\0' && c != ' ' && c != '\t' && c != '\v' && c != '\f' && c != '\n' && c != '\r'){
    return false;
  }
  return true;
}

static bool isHexVal(char c){
  if(c == 'A' || c == 'a' || c == 'B' || c == 'b' || c == 'C' || c == 'c' || c == 'D' || c == 'd' || c == 'E' || c == 'e' || c == 'F' || c == 'f' || c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9'){
    return true;
  }
  return false;
}

//handles printing out hexadecimal numbers
static void printHex(char* input, char* temp, int i, int j){

  while(input[i] != '\0' && input[i] != ' ' && input[i] != '\t' && input[i] != '\v' && input[i] != '\f' && input[i] != '\n' && input[i] != '\r'){
    if(isSimpleOperator(input[i]) || couldBeComplex(input[i])){
      break;
    }
    if(j > 1 && isHexVal(input[i]) == false){
      break;
    }
    temp[j] = input[i];
    i++;
    j++;
    
    lastToken = 2;
  }
  printf("hexadecimal integer: \"%s\"\n", temp);
  arrLocation = i;
  
}

static void printSizeOf(char* input, int i){//checks if an 's' character could be a sizeof operator call and prints it if it is.
  
  if((!isDelim(input[i])) && (input[i] == 's')){
    if((!isDelim(input[i+1])) && (input[i+1] == 'i')){
      if((!isDelim(input[i+2])) && (input[i+2] == 'z')){
        if((!isDelim(input[i+3])) && (input[i+3] == 'e')){
          if((!isDelim(input[i+4])) && (input[i+4] == 'o')){
            if((!isDelim(input[i+5])) && (input[i+5] == 'f')){
              printf("sizeof: \"sizeof\"\n");
              i = i + 6;
              arrLocation = i;
              lastToken = 5;
            }    
          }   
        }    
      }
    }
  }
  else{
    printf("else");
    return;
  }
  return;
}


//
static void printOperator(char* input, int i){//handles printing of each operator function and cases where they could be multiple different operators.
  while(!isDelim(input[i])){
    if(isSimpleOperator(input[i])){//handles printing of simple operators  
      if(input[i] != '.'){
        lastToken = 5;
      } 
      switch(input[i]) {
        case '(' :
          printf("left parenthesis: \"(\"\n");
          i++;
          arrLocation = i;
          return;
        case ')' :
          printf("right parenthesis: \")\"\n");
          i++;
          arrLocation = i;
          return;        
        case '.' :
          if(isDelim(input[i+1]) || isdigit(input[i+1]) == 0){
            printf("structure member: \".\"\n");
            i++;
            arrLocation = i;
            return;
          }
          else if(lastToken != -1 && lastToken != 0){
            printf("structure member: \".\"\n");
            i++;
            lastToken = 5;
            arrLocation = i;
            return;
          }
          return;
        case ',' :
          printf("comma: \",\"\n");
          i++;
          arrLocation = i;
          return;
        case '~' :
          printf("1s complement: \"~\"\n");
          i++;
          arrLocation = i;
          return;
        case ':' :
          printf("conditional false: \":\"\n");
          i++;
          arrLocation = i;
          return;
        case '?' :
          printf("conditional true: \"?\"\n");
          i++;
          arrLocation = i;
          return;
        case ']' :
          printf("right bracket: \"]\"\n");
          i++;
          arrLocation = i;
          return;
        case '[' :
          printf("left bracket: \"[\"\n");
          i++;
          arrLocation = i;
          return;
        default :
          printf("reached end of simple.");
          return;
      }
    }

    else if(couldBeComplex(input[i])){
      lastToken = 5;
      if(input[i] == '-'){
        if(input[i+1] == '>'){
          printf("structure pointer: \"->\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '-'){
          printf("decrement: \"--\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("minus equals: \"-=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("minus/subtract operator: \"-\"\n");
          i++;
          arrLocation = i;
          break;
        }
      }

      if(input[i] == '+'){
        if(input[i+1] == '+'){
          printf("increment: \"++\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("plus equals: \"+=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("addition: \"+\"\n");
          i++;
          arrLocation = i;
          break;
        }
      }

      if(input[i] == '|'){
        if(input[i+1] == '|'){
          printf("logical OR: \"||\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("bitwise OR equals: \"|=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("bitwise OR \"|\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '&'){
        if(input[i+1] == '&'){
          printf("logical AND: \"&&\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("bitwise AND equals: \"&=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("AND/address operator: \"&\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '!'){
        if(input[i+1] == '='){
          printf("inequality test: \"!=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("negate: \"!\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '*'){
        if(input[i+1] == '='){
          printf("times equals: \"*=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("multiply/dereference operator: \"*\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '/'){
        if(input[i+1] == '='){
          printf("divide equals: \"/=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("division \"/\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '='){ 
        if(input[i+1] == '='){
          printf("equality test: \"==\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("assignment: \"=\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '%'){ 
        if(input[i+1] == '='){
          printf("mod equals: \"%c\"\n", 37);
          i=i+2;
          arrLocation = i;
          break;
        }
        else{
          printf("modulus operator \"%c\"\n", 37);
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(input[i] == '^'){
        if(input[i+1] == '='){
          printf("bitwise XOR equals: \"^=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("bitwise XOR \"^\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(!isDelim(input[i+2]) && (input[i] == '>')){
        if(input[i+1] == '>' && input[i+2] == '='){ 
          printf("shift right equals: \">>=\"\n");
          i = i + 3;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '>' && input[i+2] != '='){ 
          printf("shift right: \">>\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("greater than or equal test: \">=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("greater than test: \">\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(isDelim(input[i+2]) && (input[i] == '>')){
        if(input[i+1] == '>'){ 
          printf("shift right: \">>\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("greater than or equal test: \">=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("greater than test: \">\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

    
    
      if(!isDelim(input[i+2]) && (input[i] == '<')){//handles cases for operators that begin with < of length 3
        if(input[i+1] == '<' && input[i+2] == '='){ 
          printf("shift left equals: \"<<=\"\n");
          i = i + 3;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '<' && input[i+2] != '='){ 
          printf("shift left: \"<<\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("less than or equal test: \"<=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("less than test: \"<\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }

      if(isDelim(input[i+2]) && (input[i] == '<')){//handles cases for operators that begin with > of length 2
        if(input[i+1] == '<'){ 
          printf("shift left: \"<<\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else if(input[i+1] == '='){
          printf("less than or equal test: \"<=\"\n");
          i = i + 2;
          arrLocation = i;
          break;
        }
        else{
          printf("less than test: \"<\"\n");
          i++;
          arrLocation = i;
          break;
        }
        break;
      }
    }
  }
}

//handles printing decimals, octals, hexadecimals, and floating point numbers
static void printNum(char* input, int i){
  char* temp = (char*)malloc(strlen(input));
  int j = 0;
  bool floatCheck = false;

  while(input[i] != '\0' && input[i] != ' ' && input[i] != '\t' && input[i] != '\v' && input[i] != '\f' && input[i] != '\n' && input[i] != '\r'){
    if(input[i] == '.' && isdigit(input[i+1]) != 0 && (lastToken == -1 || lastToken == 0 || lastToken == 5)){
      printFloat(input, temp, i, j);
      free(temp);
      return;
    }
    if(input[i+1] != '\0' && input[i] == '0'){
      if((input[i+1] == 'x' || input[i+1] == 'X')){
        printHex(input, temp, i, j);
        free(temp);
        return;
      }
      if((input[i+1] != '8' && input[i+1] != '9') && lastToken != 0){
        printOctal(input, temp, i, j);
        free(temp);
        return;
      }
    }
    if(isdigit(input[i]) == 0){
        break;
    }
    temp[j] = input[i];
    i++;
    j++;
  }

  lastToken = 0;
  printf("decimal integar: \"%s\"\n", temp);
  
  arrLocation = i;
  free(temp);
}

//handles printing out words and checking if there are any operators within those words
static void printWord(char* input, int i){
  char* temp = (char*)malloc(strlen(input));
  int j = 0;

  while(input[i] != '\0' && input[i] != ' ' && input[i] != '\t' && input[i] != '\v' && input[i] != '\f' && input[i] != '\n' && input[i] != '\r' && !isSimpleOperator(input[i]) && !couldBeComplex(input[i])){
      
    temp[j] = input[i];
    i++;
    j++;  

  }
  lastToken = 4;
  printf("word: \"%s\"\n", temp);
  arrLocation = i;
  free(temp);
}

int main(int argc, char *argv[]) {

  char* input = argv[1];

  int i = 0;
  arrLocation = 0;
  lastToken = -1;
  while(input[i] != '\0'){
    
    //printf("input[i] is = %c\n", input[i]);
    if(input[i] == ' '){
      arrLocation++;
      i++;
      continue;
    }
    if(isSimpleOperator(input[i]) || (couldBeComplex(input[i]))){
      printOperator(input, i);
      i = arrLocation;
    }
    if(input[i] == 's'){
      printSizeOf(input, i);
      i = arrLocation;
    }
    if(input[i] == '.' && (lastToken == -1 || lastToken == 0)){
      printNum(input,i);
      i = arrLocation;
    }
    if(input[i] == '.'){
      printOperator(input, i);
      i = arrLocation;
    } 
    if(isdigit(input[i]) != 0){
      printNum(input, i);
      i = arrLocation;
    }    
    if(isalpha(input[i]) != 0){
      printWord(input, i);
      i = arrLocation;
      
    } 
  }

  return 0;
}
