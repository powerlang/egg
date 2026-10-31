/*
    Copyright (c) 2019-2026 Javier Pimás. 
    Copyright (c) 2019 Jan Vrany.
    See (MIT) license in root directory.
 */

#include <cstring>
#include <iostream>
#include <algorithm>
#include <vector>
#include <string>

#include "Util.h"
#include "FileImageSegment.h"
#include "Allocator/Memory.h"

namespace Egg
{

FileImageSegment::FileImageSegment(std::istream* data)
{
    this->load(data);
}

uintptr_t
FileImageSegment::alloc(uintptr_t base, size_t size)
{
    ASSERT(base == pagealign(base));
    auto ptr = ReserveMemory(base, size);
    CommitMemory(ptr, size);
    return ptr;
}

void
FileImageSegment::load(std::istream *data)
{
    data->read(reinterpret_cast<char*>(&header), sizeof(header));

    if (strncmp((char*)&header.signature, "EGG_IS\n", 8) != 0)
        error("wrong image segment signature");

    _currentBase = this->alloc(header.baseAddress, header.reservedSize);

    auto stored = header.codeSize == 0 ? header.size : this->codeEnd() - _currentBase;
    data->seekg(0, std::ios::beg);
    data->read(reinterpret_cast<char*>(_currentBase), stored);

    if (data->fail())
        error("error reading image segment");

    this->readImportStrings(data);
    this->readImportDescriptors(data);
    this->readExports(data);
}

void FileImageSegment::fixPointerSlots(const std::vector<Object*>& imports)
{
    this->fixPointerSlotsFrom(this->spaceStart(), this->spaceEnd(), imports);
    if (header.codeSize != 0)
        this->fixPointerSlotsFrom(this->codeStart(), this->codeEnd(), imports);
    header.module = relocatedAddress_(header.module);
}

void FileImageSegment::fixPointerSlotsFrom(uintptr_t start, uintptr_t limit, const std::vector<Object*>& imports)
{
    intptr_t delta = this->_currentBase - this->header.baseAddress;
    uintptr_t oldBehaviorBase = this->header.baseAddress & (((uintptr_t)-1) << 32); // discards lower 32 bits
    auto current = ((HeapObject::ObjectHeader*)start)->object();
    auto end = (HeapObject*)limit;
    while (current < end)
    {
        auto behavior = current->basicBehavior();
        if (((uintptr_t)behavior & 0x3) == 0x0) // if an oop
        {
            auto newBehavior = oldBehaviorBase + (intptr_t)behavior + delta;
            current->behavior((HeapObject*)newBehavior);
        }
        else if (((uintptr_t)behavior & 0x3) == 0x2) // if an import
        {
            current->behavior(imports[((uintptr_t)behavior)>>2]->asHeapObject());
        }

        for (uintptr_t i = 0; i < current->pointersSize(); i++)
        {
            auto &slot = current->slot(i);
            if (((uintptr_t)slot & 0x3) == 0x0)
            {
                slot = (Object*)(((intptr_t)slot) + delta);
            }
            else if (((uintptr_t)slot & 0x3) == 0x2)
            {
                slot = imports[((uintptr_t)slot)>>2];
            }
        }
        current = current->nextObject();
    }
}

std::string& FileImageSegment::importStringAt_(uint32_t index)
{
    return _importStrings[index];
}

HeapObject* FileImageSegment::relocatedAddress_(const HeapObject* object)
{
    uintptr_t delta = _currentBase - header.baseAddress;
    return (HeapObject*)((uintptr_t)object + delta);
}

void FileImageSegment::readImportStrings(std::istream *data)
{
    uint32_t importStringsSize;
    data->read((char*)&importStringsSize, sizeof(importStringsSize));

    uint32_t bufferSize = 1000;
    char *buffer = new char[bufferSize];
    for (int i = 0; i < importStringsSize; i++)
    {
        uint32_t stringSize;
        data->read((char*)&stringSize, sizeof(stringSize));
        if (stringSize > bufferSize)
        {
            delete[] buffer;
            bufferSize = std::max(stringSize, bufferSize * 2);
            buffer = new char[bufferSize];
        }
        data->read(buffer, stringSize);

        _importStrings.push_back(std::string(buffer, stringSize));
    }
    delete[] buffer;
}

void FileImageSegment::readImportDescriptors(std::istream *data)
{
    uint32_t importDescriptorsSize;
    data->read((char*)&importDescriptorsSize, sizeof(importDescriptorsSize));

    for (int i = 0; i < importDescriptorsSize; i++)
    {
        uint32_t descriptorSize;
        data->read((char*)&descriptorSize, sizeof(descriptorSize));
        std::vector<uint32_t> descriptor;
        descriptor.resize(descriptorSize);
        data->read((char*)&descriptor[0], descriptorSize * sizeof(uint32_t));

        _importDescriptors.push_back(descriptor);
    }
}

void FileImageSegment::readExports(std::istream *data)
{
    uint32_t exportDescriptorsSize;
    data->read((char*)&exportDescriptorsSize, sizeof(exportDescriptorsSize));
    for (int i = 0; i < exportDescriptorsSize; i++)
    {
        uint64_t exportHeapAddress;
        uint64_t exportSizeOfName;

        data->read(reinterpret_cast<char*>(&exportHeapAddress), sizeof(exportHeapAddress));
        data->read(reinterpret_cast<char*>(&exportSizeOfName), sizeof(exportSizeOfName));

        std::string exportName;
        exportName.resize(exportSizeOfName);
        data->read(&exportName[0], exportSizeOfName);

        _exports[exportName] = this->relocatedAddress_(reinterpret_cast<HeapObject*>(exportHeapAddress));
    }
    ASSERT(data->peek() == EOF);
}

} // namespace Egg
