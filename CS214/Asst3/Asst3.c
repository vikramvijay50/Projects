#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>
#include <pthread.h>

#define BACKLOG 5

struct connection {
    struct sockaddr_storage addr;
    socklen_t addr_len;
    int fd;
};

int server(char *port);
void *messageReceiver(void *arg);
int messageChecker(char* message, int messageNum);
void errorMessager(char* message, int messageNum);

int main(int argc, char **argv){

	if (argc != 2) {
		printf("Usage: %s [port]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

    (void) server(argv[1]);
    return EXIT_SUCCESS;
}


int server(char *port){

    struct addrinfo hint, *address_list, *addr;
    struct connection *con;
    int error, sfd;
    pthread_t tid;

    memset(&hint, 0, sizeof(struct addrinfo));
    hint.ai_family = AF_UNSPEC;
    hint.ai_socktype = SOCK_STREAM;
    hint.ai_flags = AI_PASSIVE;

    error = getaddrinfo(NULL, port, &hint, &address_list);
    if (error != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(error));
        return -1;
    }

    for (addr = address_list; addr != NULL; addr = addr->ai_next) {
        sfd = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
 
        if (sfd == -1) {
            continue;
        }

        if ((bind(sfd, addr->ai_addr, addr->ai_addrlen) == 0) &&
            (listen(sfd, BACKLOG) == 0)) {
            break;
        }

        close(sfd);
    }

    if (addr == NULL) {
        fprintf(stderr, "Could not bind\n");
        return -1;
    }

    freeaddrinfo(address_list);

    printf("Waiting for connection\n");
    for (;;) {

		con = malloc(sizeof(struct connection));
        con->addr_len = sizeof(struct sockaddr_storage);

        con->fd = accept(sfd, (struct sockaddr *) &con->addr, &con->addr_len);

        if (con->fd == -1) {
            perror("accept");
            continue;
        }

        error = pthread_create(&tid, NULL, messageReceiver, con);

        if (error != 0) {
            fprintf(stderr, "Unable to create thread: %d\n", error);
            close(con->fd);
            free(con);
            continue;
        }

        pthread_detach(tid);

    }

    return 0;
}

void *messageReceiver(void *arg){
    char host[100], port[10], buf[101];
    struct connection *c = (struct connection *) arg;
    int error, nread;
    int bar;
    int totread;

    error = getnameinfo((struct sockaddr *) &c->addr, c->addr_len, host, 100, port, 10, NI_NUMERICSERV);

    if (error != 0) {
        fprintf(stderr, "getnameinfo: %s", gai_strerror(error));
        close(c->fd);
        return NULL;
    }

    printf("[%s:%s] connection\n", host, port);

    char message[23] = "REG|13|Knock, knock.|";
    char message2[12] = "REG|3|Wa.|";
    char message3[40] = "REG|31|What are you so excited about?!|";
    int check;

    write(c->fd, message, strlen(message));
    usleep(50 * 1000);

    bar = 0;
    totread = 0;
    while(bar < 3){
        char newbuf[101];
        int currRead = read(c->fd, newbuf, 100);
        newbuf[currRead] = '\0';
        totread += currRead;
        for(int i = 0; i < strlen(newbuf); i++){
            if(newbuf[i] == '|'){
                bar++;
            }
        }
        strcat(buf, newbuf);
    }
    buf[totread] = '\0';
    check = messageChecker(buf, 0);
    if(check == -1){
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -2){
        write(c->fd, "ERR|M1FT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -3){
        write(c->fd, "ERR|M1LN|", 9);
        close(c->fd);
        free(c);
        return NULL;        
    } else if(check == -4){
        write(c->fd, "ERR|M1CT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    }
    buf[0] = '\0';

    write(c->fd, message2, strlen(message2));
    usleep(50 * 1000);

    bar = 0;
    totread = 0;
    while(bar < 3){
        char newbuf[101];
        int currRead = read(c->fd, newbuf, 100);
        newbuf[currRead] = '\0';
        totread += currRead;
        for(int i = 0; i < strlen(newbuf); i++){
            if(newbuf[i] == '|'){
                bar++;
            }
        }
        strcat(buf, newbuf);
    }
    buf[totread] = '\0';
    check = messageChecker(buf, 2);
    if(check == -1){
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -2){
        write(c->fd, "ERR|M3FT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -3){
        write(c->fd, "ERR|M3LN|", 9);
        close(c->fd);
        free(c);
        return NULL;        
    } else if(check == -4){
        write(c->fd, "ERR|M3CT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    }
    buf[0] = '\0';

    write(c->fd, message3, strlen(message3));
    usleep(50 * 1000);

    bar = 0;
    totread = 0;
    while(bar < 3){
        char newbuf[101];
        int currRead = read(c->fd, newbuf, 100);
        newbuf[currRead] = '\0';
        totread += currRead;
        for(int i = 0; i < strlen(newbuf); i++){
            if(newbuf[i] == '|'){
                bar++;
            }
        }
        strcat(buf, newbuf);
    }
    buf[totread] = '\0';
    check = messageChecker(buf, 4);
    if(check == -1){
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -2){
        write(c->fd, "ERR|M5FT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    } else if(check == -3){
        write(c->fd, "ERR|M3LN|", 9);
        close(c->fd);
        free(c);
        return NULL;        
    } else if(check == -4){
        write(c->fd, "ERR|M5CT|", 9);
        close(c->fd);
        free(c);
        return NULL;
    }
    buf[0] = '\0';

    printf("[%s:%s] got EOF\n", host, port);

    close(c->fd);
    free(c);
    return NULL;
}

int messageChecker(char* message, int messageNum){
    char wordType[3];
    char wordLen[3];
    char *word = malloc(strlen(message));
    int wordLenNum = 0;
    int i = 0;

    for(i; i < 3; i++){
        wordType[i] = message[i];
    }

    wordType[3] = '\0';

    if(strcmp(wordType,"REG") != 0){
        errorMessager(message, messageNum);
        usleep(50 * 1000);
        return -1;
    } else{
        i++;
    }

    int k = 0;
    for(i; i < strlen(message); i++){
        if(message[i] == '|'){
            i++;
            break;
        } else{
            wordLen[k] = message[i];
            k++;
            continue;
        }
    }
    wordLen[k] = '\0';
    wordLenNum = atoi(wordLen);

    int j = 0;
    for(i; i < strlen(message)-1; i++){
        word[j] = message[i];
        j++;
    }
    word[j] = '\0';

    if(strcmp(message, "REG|12|Who's there?|") != 0 && strcmp(message, "REG|8|Wa, who?|") != 0 && strcmp(message, "REG|14|Argh terrible!|") != 0){
        return -2;
    } else if(wordLenNum != j){
        return -3;
    } else if(strcmp(word, "Who's there?") != 0 && strcmp(word, "Wa, who?") != 0 && strcmp(word, "Argh terrible!") != 0){
        return -4;
    } else{
        printf("%s\n", word);
        return 0;
    }

    free(word);

}

void errorMessager(char* message, int messageNum){
    char type[3];

    type[0] = message[6];
    type[1] = message[7];
    type[2] = '\0';

    if(strcmp(type, "CT") == 0){
        printf("Error: Message %d content was incorrect\n", messageNum);
        return;
    } else if(strcmp(type, "LN") == 0){
        printf("Error: Message %d value was incorrect\n", messageNum);
        return;
    } else if(strcmp(type, "FT") == 0){
        printf("Error: Message %d format was broken\n", messageNum);
        return;
    } else{
        printf("Error: Message %d unknown error\n", messageNum);
        return;
    }
    
}