/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _EGG_ORDERED_MAP_H_
#define _EGG_ORDERED_MAP_H_

#include <unordered_map>
#include <utility>
#include <vector>

namespace Egg {

/**
 * A map that iterates in insertion order, like OrderedDictionary in Smalltalk.
 */
template <typename Key, typename Value>
class ordered_map {
    std::vector<std::pair<Key, Value>> _pairs;
    std::unordered_map<Key, size_t> _positions;

public:
    using iterator = typename std::vector<std::pair<Key, Value>>::iterator;

    iterator begin() { return _pairs.begin(); }
    iterator end() { return _pairs.end(); }

    iterator find(const Key& key) {
        auto it = _positions.find(key);
        return it == _positions.end() ? end() : begin() + it->second;
    }

    Value& operator[](const Key& key) {
        auto [it, added] = _positions.try_emplace(key, _pairs.size());
        if (added)
            _pairs.emplace_back(key, Value());
        return _pairs[it->second].second;
    }
};

} // namespace Egg

#endif // _EGG_ORDERED_MAP_H_
