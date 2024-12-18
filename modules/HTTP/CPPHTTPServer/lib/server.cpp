#define CPPHTTPLIB_OPENSSL_SUPPORT
#include "httplib.h"

typedef void(*server_callback)(const void *, const void *);

extern "C" {

void* Server_New()
{
    return new httplib::Server;
}

void Server_Get(void *cserver, char *url, void *ccallback)
{
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    server_callback callback = reinterpret_cast<server_callback>(ccallback);
    server->Get(url, [callback](const httplib::Request &req, httplib::Response &res) {
        callback(&req, &res);
    });
}

void Server_Start(void *cserver) {
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    server->listen("0.0.0.0", 8080);
}

void Server_Delete(void *cserver) {
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    delete server;
}


void Response_SetContent(void *cres, char *content, char *type)
{
  httplib::Response *res = reinterpret_cast<httplib::Response*>(cres);
  res->set_content(content, type);
}

}

