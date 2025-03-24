#ifndef _EGG_H_
#define _EGG_H_

#include <cstdint>
#include <cinttypes>
#include <string>

typedef unsigned long ulong;
typedef unsigned short ushort;
typedef unsigned char uchar;

namespace Egg {

constexpr uintptr_t WORD_SIZE = sizeof(uintptr_t);
constexpr uintptr_t WORD_SIZE_SHIFT = WORD_SIZE == 4 ? 2 : 3;

constexpr uintptr_t KB = 1024;
constexpr uintptr_t MB = 1024 * 1024;

struct Object;
struct HeapObject;
struct SmallInteger;

void Initialize();
void osError();
void error(const char *message);
void error_(const std::string &message);
void warning(const char *message);
void warning_(const std::string &message);

}

#endif // _EGG_H_
