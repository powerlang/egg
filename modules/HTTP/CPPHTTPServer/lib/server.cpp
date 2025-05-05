#define CPPHTTPLIB_OPENSSL_SUPPORT
#include "httplib.h"

typedef void(*server_callback)(const void *, const void *);

// in our uri convention we use {var} to denote a variable, but httplib uses :var
static std::string translateUriFormat(const std::string& uri) {
    static const std::regex varPattern(R"(\{([a-zA-Z_][a-zA-Z0-9_]*)\})");
    return std::regex_replace(uri, varPattern, ":$1");
}

extern "C" {

void* Server_New()
{
    return new httplib::Server;
}

void Server_Get(void *cserver, char *url, void *ccallback)
{
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    server_callback callback = reinterpret_cast<server_callback>(ccallback);
    server->Get(translateUriFormat(url), [callback](const httplib::Request &req, httplib::Response &res) {
        callback(&req, &res);
    });
}

void Server_Start(void *cserver) {
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    server->new_task_queue = []() { return new httplib::ThreadPool(1); }; // assure no multithreading goes on, as egg does not support it
    server->listen("0.0.0.0", 8080);
}

void Server_Delete(void *cserver) {
    httplib::Server *server = reinterpret_cast<httplib::Server*>(cserver);
    delete server;
}

char* Request_HeadersAt(void *creq, char *key, char *type)
{
    httplib::Request *req = reinterpret_cast<httplib::Request*>(creq);

    auto &headers = req->headers;
    auto it = headers.find(key);
    if (it == headers.end())
        return nullptr;

    return const_cast<char*>(it->second.c_str());
}

char* Request_ParamAt(void *creq, char *key, char *type)
{
    httplib::Request *req = reinterpret_cast<httplib::Request*>(creq);

    auto &params = req->path_params;
    auto it = params.find(key);
    return it != params.end() ? (char*)it->second.c_str() : nullptr;
}

void Response_HeadersAtPut(void *cres, char *key, char *value)
{
    httplib::Response *res = reinterpret_cast<httplib::Response*>(cres);
    res->set_header(key, value);
}

void Response_SetContent(void *cres, char *content, char *type)
{
    httplib::Response *res = reinterpret_cast<httplib::Response*>(cres);
    res->set_content(content, type);
}

void Response_SetStatus(void *cres, int status)
{
    httplib::Response *res = reinterpret_cast<httplib::Response*>(cres);
    res->status = status;
}


}

