
#ifndef _GCEDREF_H_
#define _GCEDREF_H_

#include "Egg.h"

namespace Egg {

class Runtime;

class GCedRef
{
public:
    /* Create a new NULL reference.  */
    GCedRef(HeapObject *object, uintptr_t index);
    GCedRef(HeapObject *object);

    /* Create a new reference from another reference */
    GCedRef(GCedRef &other);

    ~GCedRef();

    HeapObject *get();
    const HeapObject* get() const { return _object; };
    uintptr_t index();

    HeapObject **getRaw() { return &_object; }

    // Comparator for GCedRef* that allows comparisons with HeapObject*
    struct Comparator {
        using is_transparent = void;
        uintptr_t hash(const GCedRef *obj) const;
        uintptr_t hash(const HeapObject *obj) const;

        bool operator()(const GCedRef* lhs, const GCedRef* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        bool operator()(const GCedRef* lhs, const HeapObject* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        bool operator()(const HeapObject* lhs, const GCedRef* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        // comparisons for pairs of GCedRef*
        bool operator()(const std::pair<GCedRef*, GCedRef*>& lhs, const std::pair<GCedRef*, GCedRef*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        // Compare two std::pair<HeapObject*, HeapObject*>
        bool operator()(const std::pair<HeapObject*, HeapObject*>& lhs, const std::pair<HeapObject*, HeapObject*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        // Compare pairs of HeapObject with pairs of GCedRef
        bool operator()(const std::pair<GCedRef*, GCedRef*>& lhs,
                        const std::pair<HeapObject*, HeapObject*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        bool operator()(const std::pair<HeapObject*, HeapObject*>& lhs,
                        const std::pair<GCedRef*, GCedRef*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }
    };

private:
    GCedRef(const GCedRef &other) = delete; // not allowed, to prevent aliasing
    GCedRef& operator=(const GCedRef &other) = delete;

    HeapObject *_object;
    uintptr_t _index;
    //static Runtime *_runtime;
};

}

#endif // ~ _GCEDREF_H_ ~
