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
    std::map<std::string, HeapObject*> exports;
  public:
    ImageSegment(std::istream* data) { this->load(data); }

    /**
     * Allocate a new segment of given `size` at given `base` address.
     * Contents of the segment is zeroed.
     */
    void alloc(uintptr_t base, size_t size);

    /**
     * Load a segment from given stream and return it. The stream should
     * be positioned to the beginning of segment prior calling load()
     */
    void load(std::istream* data);

private:
    void readExports(std::istream *data);
};

} // namespace Egg

#endif // _IMAGE_SEGMENT_H_