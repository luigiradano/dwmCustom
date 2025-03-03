#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#define MAX_STR_LEN 100
#define MAX_SEN_TO_LOG 10
#define ERROR 1
#define NO_ERROR 0

enum {
  SENSOR_NAMES,
  SENSOR_COUNT,
  CAPT_FREQ,
};

typedef struct InputArgs{
  char sensorNames[MAX_SEN_TO_LOG][MAX_STR_LEN];
  uint32_t sensorsToLog;
  uint32_t updateFrequency;
} InputArgs_t;

void printFixedLen(char *strIn, int maxLen);
int parseArgs(int argc, char *argv[], InputArgs_t* out);

int main(int argc, char *argv[])
{

  char tmpString[MAX_STR_LEN], cmdStr[MAX_STR_LEN];
  InputArgs_t data;
  time_t now, nextRun = 0;
  int i;

  parseArgs(argc, argv, &data);
  
  printFixedLen("|Timestamp", 20);
  
  for(i = 0; i < data.sensorsToLog; i ++){
    printf("|");
    printFixedLen(data.sensorNames[i], 20);
  }
  
  printf("\n");

  while(1){
    time(&now);
    if(now - nextRun >= data.updateFrequency){
      struct tm* info;

      info = localtime(&now);

      strftime(tmpString, MAX_STR_LEN, "%d/%m/%y %H:%M:%S", info);
      nextRun = now;
      printf("|");
      printFixedLen(tmpString, 19);
      printf("|");

      for(i = 0; i < data.sensorsToLog; i ++){
        sprintf(cmdStr, "/usr/bin/sensors | grep %s | awk \'{print $2 $3}\'", data.sensorNames[i]);
      
        FILE* fp = popen(cmdStr, "r");

        if(fp == NULL)
          exit(1);

        fgets(tmpString, MAX_STR_LEN, fp);
        tmpString[strlen(tmpString)-1] = '\0'; //Clean ending \n

        printFixedLen(tmpString, 20);
        printf("|");

        pclose(fp);
      }
      printf("\n");
    }

  }

  return EXIT_SUCCESS;
}

  void printFixedLen(char *strIn, int maxLen){
    int spaces = maxLen - strlen(strIn);

    fprintf(stdout, "%s", strIn);
    while(spaces > 0){
      fprintf(stdout, " ");
      spaces--;
    }


  }

  int parseArgs(int argc, char *argv[], InputArgs_t* out){
    char splitString[MAX_STR_LEN];
    int i, argChoose = -1, j = 0;

    for(i = 0; i < argc; i ++){

      if(strcmp(argv[i], "--freq") == 0)
        argChoose = CAPT_FREQ;
      else if(strcmp(argv[i], "--names") == 0)
        argChoose = SENSOR_NAMES;
      else{
        switch(argChoose){
          case CAPT_FREQ:
            sscanf(argv[i], "%d", &out->updateFrequency);
            break;
          case SENSOR_NAMES:
            sscanf(argv[i], "%s", out->sensorNames[j]);
            j++;
            out->sensorsToLog = j;
            break;
          default:
        }
      }
    }
  }

