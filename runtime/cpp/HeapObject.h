/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.

 *
 * Here we define the most basic thing of the VM: the format of objects in the heap.
 * This is an initial implementation, we expect to allow for different formats in the future.
 *
 * This file defines the HeapObject struct, which contains nested definition of SmallHeader,
 * LargeHeader and ObjectHeader (abstract struct that can be small or large).
 * The HeapObject struct provides an API to allow access to object headers and slots.
 
 */

#ifndef _HEAPOBJECT_H_
#define _HEAPOBJECT_H_

#include <string>

#include "Object.h"
#include "SmallInteger.h"
#include "Util.h"
#include "Egg.h"

namespace Egg {

/**
 * struct `HeapObject` represents a Smalltalk object on an object heap
 * and provides very basic API to query object type and contents.
 */
struct HeapObject
{
#pragma pack (push,1)

    struct SmallHeader
    {
    	uint16_t hash;
    	uint8_t size;
    	uint8_t flags;
    	uint32_t behavior;

      typedef enum
      {
          IsBytes      = 0x01,
          IsArrayed    = 0x02,
          IsNamed      = 0x04,
          IsRemembered = 0x08,
          IsSpecial    = 0x10,
          HasBeenSeen  = 0x20,
          IsSecondGen  = 0x40,
          IsSmall      = 0x80,
          AllOn        = 0xFF
      } Flags;


      static SmallHeader* at(void* buffer) /// just a cast
        { return (SmallHeader*)buffer; }


      HeapObject* object() /// a HeapObject pointer to the object that corresponds to this header
        { return (HeapObject*)(((uintptr_t)this) + sizeof(SmallHeader)); }


      bool testFlags (const uint8_t flag) const;
      void setFlags  (const uint8_t flag);
      void unsetFlags(const uint8_t flag);

    };
    
    static const int MAX_SMALL_SIZE = 0xFF;


    struct LargeHeader
    {
    	uint32_t size;
    	uint32_t padding;
    	SmallHeader smallHeader;

      static LargeHeader* at(void* buffer) /// just a cast
        { return (LargeHeader*)buffer; }

      HeapObject* object() /// a pointer to the object that corresponds to this header
        { return smallHeader.object(); }
    };

    /**
     * struct `ObjectHeader` is an opaque handle to a header, in a similar
     * sense as Object: it represents the start of a header, and you have
     * to use its helpers to access the actual headers.
     **/
    struct ObjectHeader {

      static ObjectHeader* at(void* buffer) // just a cast
        { return (ObjectHeader*)buffer; } 

      SmallHeader* smallHeader() // Determines whether this corresponds to a small or large header and returns the SmallHeader part.
      {
        auto small = SmallHeader::at((void*)this);
        return (small->flags & SmallHeader::IsSmall) ? small : &((LargeHeader*)(this))->smallHeader;
      }

      /**
       * Returns a reference to the HeapObject that corresponds to this header.
       * I check whether the header is large or small to add the corresponding
       * offset.
       **/
      HeapObject* object() { return this->smallHeader()->object(); }

    };

#pragma pack (pop)
  protected:
 

    const SmallHeader* smallHeader() const { return (const SmallHeader*)((uintptr_t)this - sizeof(SmallHeader)); }
    SmallHeader* smallHeader() { return (SmallHeader*)((uintptr_t)this - sizeof(SmallHeader)); }

    const LargeHeader* largeHeader() const {
      ASSERT(this->isLarge());
    	return (const LargeHeader*)((uintptr_t)this - sizeof(LargeHeader));
    }
    LargeHeader* largeHeader() {
      ASSERT(this->isLarge());
    	return (LargeHeader*)((uintptr_t)this - sizeof(LargeHeader));
    }

      bool testFlags (const uint8_t flag) const;
      void setFlags  (const uint8_t flag);
      void unsetFlags(const uint8_t flag);

  public:
      SmallHeader::Flags flags()
      {
          return (SmallHeader::Flags)this->smallHeader()->flags;
      }
      
      /// ~ header bits getters ~

      bool isBytes() const; // `true` means this object is byte-indexed, `false` that its slots contain Object pointers.
      bool isPointers() const; // Opposite of isBytes.
      bool isArrayed() const; // `true` means there are indexed slots in this object
      bool isNamed() const; // `true` means this object contains named lots (like Point). This is orthogonal to being arrayed
      bool isRemembered() const; // `true` means this object has been added to the rememberedSet
      bool isSpecial() const; // Can mean different things, usually that the object contains weak references or that it is a stack object
      bool hasBeenSeen() const; // Used as mark bit for GC
      bool isSecondGeneration() const; // Used to determine whether object should be tenured after a couple of scavenges
      bool isSmall() const; // If `true` the object only has a small header. Usually small objects have small headers only, but that is not a requirement
      bool isLarge() const; /// Opposite of isSmall


      /// ~ header bits setters ~

      void beBytes();
      void beArrayed();
      void beNamed();

      void beRemembered();
      void beNotRemembered();
      
      void beSecondGeneration();

      void beSmall();
      void beLarge();

      void beNotSpecial();
      void beStrong();

      void beSeen();
      void beUnseen();


     /// ~ behavior and hash

      /** 32-bit behavior field as-is*/
      uint32_t basicBehavior();

      /** behavior adjusted to behavior zone start */
      HeapObject* behavior();
      void behavior(HeapObject *behavior);



      uint16_t hash() const;
      void hash(uint16_t hash);

      /// ~ object sizes ~

      uint8_t  smallSize() const;  // the size field of the small header part
      void     smallSize(uint8_t size);
      uint32_t largeSize() const; // the size field of the large header part (the object must have a large header)
      void     largeSize(uint32_t size);
      void     size(uint32_t size)  // sets the small or large size field according to its small flag
      {
        if (this->isSmall()) 
            smallSize(size);
        else
            largeSize(size);
      };

      uint32_t size() const; // the small size field if the object is marked as small, the large size field otherwise
      uint32_t bodySizeInBytes() const; // the size in bytes of the buffer used for the body of this object (buffer sizes are aligned to pointer size)
      uint32_t bodySizeInSlots() const; // the size in slots of the buffer used for the body of this object (buffer sizes are aligned to pointer size)
      uint32_t headerSizeInBytes() const; // 8 or 16 depending if the object is small or large

      uint32_t pointersSize() const ; // bodySizeInSlots if the object is marked as slots, 0 if marked as bytes
      uint32_t strongPointersSize() const;

      /// ~ object slots ~

      typedef Object* ObjectSlot;
      ObjectSlot &slot(const uint32_t subscript); // return a reference to a slot of
                                                  // this object. `index` is 0-based
      ObjectSlot &untypedSlot(const uint32_t subscript); // same but without checking that the object has pointers


      ObjectSlot& slotAt_(uint32_t index) { return slot(index - 1); }; // 1-based slot for compatibility reasons
      ObjectSlot& untypedSlotAt_(uint32_t index) { return untypedSlot(index - 1); }; // 1-based slot for compatibility reasons

      uint8_t& byte(const uint32_t subscript);       /// Return a byte of this object at 0-based `subscript`
      uint8_t& unsafeByte(const uint32_t subscript);       /// same but without checking bounds and being of bytes type

      uint8_t& byteAt_(uint32_t index) { return byte(index - 1); }; // 1-based index for compatibility reasons
      uint8_t& unsafeByteAt_(uint32_t index) { return unsafeByte(index - 1); }; // 1-based index for compatibility reasons

      uint16_t& uint16offset(const uint32_t subscript);       /// Return a 16-bit uint of this object at 0-based `subscript`
      uint16_t& unsignedShortAt_(uint32_t index) { return uint16offset((index - 1) * 2); }; // 1-based index for compatibility reasons

      uint32_t& uint32offset(const uint32_t subscript);       /// Return a 32-bit uint of this object at 0-based `subscript`
      uint32_t& unsignedLongAt_(uint32_t index) { return uint32offset((index - 1) * 4); }; // 1-based index for compatibility reasons

      uint64_t& uint64offset(const uint32_t subscript);       /// Return a 64-bit uint of this object at 0-based `subscript`
      uint64_t& unsignedLargeAt_(uint32_t index) { return uint64offset((index - 1) * 8); }; // 1-based index for compatibility reasons

    /// ~ copying ~
    void copyFrom_headerSize_bodySize_(HeapObject *object, uintptr_t headerSize, uintptr_t bodySize);

    /// ~ object bytes ~
      void replaceBytesFrom_to_with_startingAt_(
          const uintptr_t from,
          const uintptr_t to,
          HeapObject *anObject,
          const uintptr_t startingAt);

    /**
     * Returns a pointer to the header of the object immediately after the
     * receiver. It is of an abstract type, as we don't know beforehand if it is small
     * or large.
     **/
    ObjectHeader* nextHeader()
    {
      uintptr_t nextHeader = (uintptr_t)this + this->bodySizeInBytes();

      return ObjectHeader::at((void*)nextHeader);
    }

    HeapObject* nextObject() /// A pointer to the object corresponding to the next header
    {
      return this->nextHeader()->object();
    }

    /// temporary stuff for debugging or to be refactored
  	HeapObject* klass();

    std::string printString();

    std::string stringVal();
    std::string asLocalString();
    bool sameBytesThan(const std::string &string);
    bool sameBytesThan(const HeapObject *object);

};

// Here we just need to make sure the struct HeapObject is empty.
// However, in C++, size of an empty struct / class is 1 byte,
// hence the `... == 1`
static_assert(sizeof(HeapObject) == 1);

} // namespace Egg

#endif /* _HEAPOBJECT_H_ */
