/*
    Copyright (c) 2019-2023 Javier Pimás. 
    Copyright (c) 2019 Jan Vrany.
    See (MIT) license in root directory.
 */

#include <sys/mman.h>
#include <unistd.h>
#include <cstring>
#include <iostream>


#include "Util.h"
#include "ImageSegment.h"
#include "Memory.h"


namespace Egg
{


void
ImageSegment::alloc(uintptr_t base, size_t size)
{
    ASSERT(base == pagealign(base));
    auto ptr = ReserveMemory(base, size);
    CommitMemory(ptr, size);
    ASSERT(base == ptr);
}

void
ImageSegment::load(std::istream* data)
{
    data->read(reinterpret_cast<char*>(&header), sizeof(header));

    if (strncmp((char*)&header.signature, "EGG_IS\n", 8) != 0)
        error("wrong image segment signature");

    this->alloc(header.baseAddress, header.reservedSize);

    data->seekg(0, data->beg);
    data->read(reinterpret_cast<char*>(header.baseAddress), header.size);

    this->readExports(data);
    
}

void ImageSegment::readExports(std::istream *data)
{
    while (data->peek() != EOF) {
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
        exports[exportName] = reinterpret_cast<HeapObject*>(exportHeapAddress);
    }
}

} // namespace Egg