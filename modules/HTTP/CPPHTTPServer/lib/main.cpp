// This is a simple server to test the C layer in plain C.
// To compile it use something along this line:
// cc -o main server.cpp main.cpp -lssl -lcrypto

#include <unistd.h>
#include <string>
#include <iostream>

#include "server.h"

typedef void(*server_callback)(const void *, const void *);

extern "C" {

static int i = 1;
void hello(void *req, void *res)
{
    std::cout << "serving hello! " << i << std::endl;

    sleep(i);
    std::string str = "hello! " + std::to_string(i) + "\n";
    Response_SetContent(res, (char*)str.c_str(), (char*)"text/html");

    std::cout << "done serving hello! " << i << std::endl;
    i++;
}

}

int main (int argc, char *argv [])
{
    void *server = Server_New();
    Server_Get(server, (char*)"/hello", (void*)hello);
    Server_Start(server);
    Server_Delete(server);
    return 0;
}
