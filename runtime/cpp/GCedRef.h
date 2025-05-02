
#ifndef _GCEDREF_H_
#define _GCEDREF_H_

#include "Egg.h"

namespace Egg {

class Runtime;

class GCedRef
{
public:
    /* Create a new NULL reference.  */
    GCedRef(Object *object, uintptr_t index);
    GCedRef(Object *object);

    /* Create a new reference from another reference */
    GCedRef(GCedRef &other);

    // we allow moving ownership of one ref to another
    //GCedRef(GCedRef &&other);
    //GCedRef& operator=(GCedRef&& other);

    ~GCedRef();

    Object *get();
    const Object* get() const { return _object; };
    void set_(Object *object) { _object = object; };
    uintptr_t index();

    Object **getRaw() { return &_object; }

    // Comparator for GCedRef* that allows comparisons with HeapObject*
    struct Comparator {
        using is_transparent = void;
        uintptr_t hash(const GCedRef *obj) const;
        uintptr_t hash(const Object *obj) const;

        bool operator()(const GCedRef* lhs, const GCedRef* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        bool operator()(const GCedRef* lhs, const Object* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        bool operator()(const Object* lhs, const GCedRef* rhs) const {
            return hash(lhs) <= hash(rhs);
        }

        // comparisons for pairs of GCedRef*
        bool operator()(const std::pair<GCedRef*, GCedRef*>& lhs, const std::pair<GCedRef*, GCedRef*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        // Compare two std::pair<HeapObject*, HeapObject*>
        bool operator()(const std::pair<Object*, Object*>& lhs, const std::pair<Object*, Object*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        // Compare pairs of HeapObject with pairs of GCedRef
        bool operator()(const std::pair<GCedRef*, GCedRef*>& lhs,
                        const std::pair<Object*, Object*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }

        bool operator()(const std::pair<Object*, Object*>& lhs,
                        const std::pair<GCedRef*, GCedRef*>& rhs) const {
            auto lhs1 = hash(lhs.first), lhs2 = hash(lhs.second);
            auto rhs1 = hash(rhs.first), rhs2 = hash(rhs.second);
            return std::tie(lhs1, lhs2) <= std::tie(rhs1, rhs2);
        }
    };

private:
    GCedRef(const GCedRef &other) = delete; // not allowed, to prevent aliasing
    GCedRef& operator=(const GCedRef &other) = delete;

    Object *_object;
    uintptr_t _index;
    //static Runtime *_runtime;
};

}

#endif // ~ _GCEDREF_H_ ~
