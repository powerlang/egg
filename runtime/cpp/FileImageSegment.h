/*
    Copyright (c) 2019-2026 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#ifndef _FILE_IMAGE_SEGMENT_H_
#define _FILE_IMAGE_SEGMENT_H_

#include <iostream>
#include <vector>

#include "ImageSegment.h"

namespace Egg
{

/**
 * An ImageSegment loaded from an .ems file on disk.
 * Handles reading, pointer relocation, and import resolution.
 */
class FileImageSegment : public ImageSegment
{
  public:
    std::vector<std::string> _importStrings;
    std::vector<std::vector<uint32_t>> _importDescriptors;

    FileImageSegment(std::istream* data);

    /**
     * Allocate a new segment of given `size` at given `base` address.
     * Contents of the segment is zeroed.
     * Return value is address allocated when passed null as base.
     */
    uintptr_t alloc(uintptr_t base, size_t size);

    /**
     * Traverses the image segment space looking for pointers.
     *  - References to other objects in same space need to be relocated.
     *  - References to imports (last two bits are 10b) are indices in import table,
     *    and need to be changed to actual object addresses.
     */
    void fixPointerSlots(const std::vector<Object*> &imports);

    /**
     * The two halves of fixPointerSlots, for linking several segments against
     * each other: rebase every segment first, then bind their imports.
     */
    void relocate();
    void bindImports(const std::vector<Object*> &imports);

    /**
     * How a slot or behavior of a segment is encoded: internal references
     * (low two bits 00b) point into the segment, external ones (10b) are an
     * index into its import table.
     */
    static bool isInternalReference(uintptr_t reference);
    static bool isExternalReference(uintptr_t reference);
    static uint32_t externalIndexOf(uintptr_t reference);

    std::string& importStringAt_(uint32_t index);
    HeapObject* relocatedAddress_(const HeapObject* object);

   private:
    void load(std::istream* data);
    void relocateObjects(uintptr_t start, uintptr_t limit);
    void bindImportsOf(uintptr_t start, uintptr_t limit, const std::vector<Object*>& imports);
    void readImportStrings(std::istream *data);
    void readImportDescriptors(std::istream *data);
    void readExports(std::istream *data);
};

} // namespace Egg

#endif // _FILE_IMAGE_SEGMENT_H_
