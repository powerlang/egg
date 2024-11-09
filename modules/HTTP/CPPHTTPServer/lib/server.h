
#ifndef _SERVER_H_
#define _SERVER_H_

extern "C" {

void* Server_New();
void Server_Get(void *cserver, char *url, void *ccallback);
void Server_Start(void *cserver);
void Server_Delete(void *cserver);
void Response_SetContent(void *cres, char *content, char *type);

}

#endif // _SERVER_H_

