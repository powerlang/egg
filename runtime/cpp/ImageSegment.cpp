/*
    Copyright (c) 2019-2023 Javier Pimás. 
    Copyright (c) 2019 Jan Vrany.
    See (MIT) license in root directory.
 */

#include <unistd.h>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <vector>
#include <string>


#include "Util.h"
#include "ImageSegment.h"

#include <iomanip>

#include "Memory.h"


namespace Egg
{


uintptr_t
ImageSegment::alloc(uintptr_t base, size_t size)
{
    ASSERT(base == pagealign(base));
    auto ptr = ReserveMemory(base, size);
    CommitMemory(ptr, size);
    return ptr;
}

void
ImageSegment::load(std::istream *data)
{
    data->read(reinterpret_cast<char*>(&header), sizeof(header));

    if (strncmp((char*)&header.signature, "EGG_IS\n", 8) != 0)
        error("wrong image segment signature");

    _currentBase = this->alloc(header.baseAddress, header.reservedSize);

    data->seekg(0, data->beg);
    data->read(reinterpret_cast<char*>(_currentBase), header.size);

    this->readImportStrings(data);
    this->readImportDescriptors(data);
    this->readExports(data);
}

std::string& ImageSegment::importStringAt_(uint32_t index)
{
    return _importStrings[index];
}

void ImageSegment::dumpObjects() {
    auto heapStart = _currentBase + sizeof(ImageSegmentHeader);
    auto current = ((HeapObject::ObjectHeader*)heapStart)->object();
    auto end = (HeapObject*)(_currentBase + header.size);
    while (current < end)
    {
        auto behavior = current->behavior();
        std::cout << "obj at: " << current << " (" << current->printString() << ")" << std::endl;
        //std::cout << "behavior: " << behavior->printString() << std::endl;
        std::cout << "size: " << std::dec << current->size() << ", flags: " << current->flags() << std::endl;

        if (current->isBytes()) {
            std::cout << "bytes: ";
            std::for_each((uint8_t*)current, ((uint8_t*)current) + current->size(), [](uint8_t c) {
                std::cout << std::hex << std::setw(2) << std::setfill('0') << (int)c << " ";
            });
            std::cout << std::endl;
        }
        else {
            for (uintptr_t i = 0; i < current->pointersSize(); i++)
            {
                auto &slot = current->slot(i);
                std::cout << slot << " (" << slot->printString() << ")" << std::endl;
            }
        }
        std::cout << "-------------------" << std::endl;
        current = current->nextObject();
    }
}


void ImageSegment::readImportStrings(std::istream *data)
{
    // std::cout << "import strings position: " << data->tellg() << std::endl;
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
            delete buffer;
            bufferSize = std::max(stringSize, bufferSize * 2);
            buffer = new char[bufferSize];
        }
        data->read(buffer, stringSize);

        _importStrings.push_back(std::string(buffer, stringSize));
    }
    delete buffer;
}

void ImageSegment::readImportDescriptors(std::istream *data)
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

        //std::cout << "found descriptor " << i << " - ";
        //for (int j = 0; j < descriptorSize; j++)
        //    std::cout << _importStrings[descriptor[j]] << "(" << descriptor[j] << ") ";
        //std::cout << std::endl;

        _importDescriptors.push_back(descriptor);
    }
}

void ImageSegment::readExports(std::istream *data)
{
    uint32_t exportDescriptorsSize;
    data->read((char*)&exportDescriptorsSize, sizeof(exportDescriptorsSize));
    for (int i = 0; i < exportDescriptorsSize; i++)
    {
        uint64_t exportHeapAddress;
        uint64_t exportSizeOfName;

        // Read the export heap address
        data->read(reinterpret_cast<char*>(&exportHeapAddress), sizeof(exportHeapAddress));

        // Read the size of the export name
        data->read(reinterpret_cast<char*>(&exportSizeOfName), sizeof(exportSizeOfName));

        // Read the export name bytes
        std::string exportName;
        exportName.resize(exportSizeOfName);
        data->read(&exportName[0], exportSizeOfName);

        //std::cout << "Found " << exportName << " at 0x" << std::hex << exportHeapAddress << std::endl;

        // Map the export name to the heap address
        _exports[exportName] = reinterpret_cast<HeapObject*>(exportHeapAddress);
    }
    ASSERT(data->peek() == EOF);

}

} // namespace Egg