/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#ifndef _IMAGE_SEGMENT_H_
#define _IMAGE_SEGMENT_H_

#include <cstdint>
#include <iostream>
#include <iterator>
#include <map>
#include <string>
#include <vector>

#include "HeapObject.h"

namespace Egg
{


typedef struct _ImageSegmentHeader
{
    /**
     * Signature of an Egg Image Segment, must be following sequence:
     * { 'E' , 'G', 'G', '_' , 'I', 'S', '\n', '\0' }
     */
    uint8_t signature[8];
    /**
     * Assumed base address at which segment is loaded, including
     * its segment header. Implementations are free to load segment at
     * any other address in which case object references (including the
     * `entry_point_method` reference!) must be relocated prior use.
     */
    uint64_t baseAddress;
    /**
     * Size of a segment including its header
     */
    uint64_t size;
    /**
     * Amount of memory to be reserved when loading the segment
     */
    uint64_t reservedSize;
    /**
     * A reference to Module instance describing this image segment
     */
    HeapObject* module;

} ImageSegmentHeader;

static_assert(sizeof(ImageSegmentHeader) == 40 /*bytes*/,
              "segment_header size not 40 bytes");

class ImageSegment
{
  public:
    ImageSegmentHeader header;
  public:
    uint64_t _currentBase;
    std::map<std::string, HeapObject*> _exports;
    std::vector<std::string> _importStrings;
    std::vector<std::vector<uint32_t>> _importDescriptors;
    ImageSegment(std::istream* data) { this->load(data); }

    /**
     * Allocate a new segment of given `size` at given `base` address.
     * Contents of the segment is zeroed.
     * Return value is address allocated when passed null as base.
     */
    uintptr_t alloc(uintptr_t base, size_t size);

    /**
     * Load a segment from given stream and return it. The stream should
     * be positioned to the beginning of segment prior calling load()
     */
    void load(std::istream* data);

    /**
     * Traverses the image segment space looking for pointers.
     *  - References to other objects in same space need to be relocated.
     *  - References to imports (last two bits are 10b) are indices in import table,
     *    and need to be changed to actual object addresses.
     */
    void fixPointerSlots(const std::vector<Object*> &imports);

    uintptr_t spaceStart();
    uintptr_t spaceEnd();

    std::string& importStringAt_(uint32_t index);
    HeapObject* relocatedAddress_(const HeapObject* object);

    void dumpObjects();

   private:
    void readImportStrings(std::istream *data);
    void readImportDescriptors(std::istream *data);
    void readExports(std::istream *data);
};

} // namespace Egg

#endif // _IMAGE_SEGMENT_H_
