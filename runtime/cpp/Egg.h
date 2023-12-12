#ifndef _EGG_H_
#define _EGG_H_

#include <cstdint>
#include <string>

typedef unsigned long ulong;
typedef unsigned short ushort;
typedef unsigned char uchar;

#define WORD_SIZE 8
#define WORD_SIZE_SHIFT 3

namespace Egg {

struct Object;
struct HeapObject;
struct SmallInteger;

void osError();
void error(const char *message);
void error_(const std::string &message);
void debug(const char *message);

}

#endif // _EGG_H_
