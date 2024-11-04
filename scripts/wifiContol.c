#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STR_LEN 200

void stripnl(char* str){
	int i = 0;

	while(str[i] != '\0' && str[i] != '\n'){ 
    i++;
  }

  str[i] = '\0';
  
}

int main(int argc, char *argv[])
{
  int mode;
  char passwd[MAX_STR_LEN], ssid[MAX_STR_LEN], user[MAX_STR_LEN], command[MAX_STR_LEN];

  printf("WiFi Simple interface.\n1. Setup WPA-2-Enterprise\n2. Setup WPA-2\n3. Exit\n");
  scanf("%d", &mode);
  
  while(getchar() != '\n');

  switch(mode){
    case 1:
      printf("Insert SSID:");
      fgets(ssid, MAX_STR_LEN, stdin);
      ssid[strlen(ssid)-1] = 0;
      printf("Insert User:");
      fgets(user, MAX_STR_LEN, stdin);
      stripnl(user);
      printf("Insert Pwd:");
      fgets(passwd, MAX_STR_LEN, stdin);
      stripnl(passwd);
      printf("ID:%s User:%s PWD:%s",ssid, user, passwd);

      sprintf(command, "nmcli connection add type wifi con-name \"%s_CONN\" ifname wlp2s0 ssid \"%s\" wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls 802-1x.phase2-auth mschapv2 802-1x.identity \"%s\" 802-1x.password \"%s\"", ssid, ssid, user, passwd );
      system(command);
      break;
    case 2:
      printf("Insert SSID:");
      fgets(ssid, MAX_STR_LEN, stdin);
      ssid[strlen(ssid)-2] = 0;
      printf("Insert Pwd:");
      fgets(passwd, MAX_STR_LEN, stdin);
      ssid[strlen(passwd)-2] = 0;
      sprintf(command, "nmcli connection add type wifi con-name \"%s_CONN\" ifname wlp2s0 ssid \"%s\"", ssid, ssid );
      system(command);
      break;
    default:
      return 0;
  }

  return 0;
}
