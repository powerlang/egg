/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
*/
#ifndef _SCOMPILEDMETHOD_H_
#define _SCOMPILEDMETHOD_H_
#include <vector>
#include <string>
#include <cstdint>
#include "../LiteralValue.h"

namespace Egg {

class SCompiledBlock;
class TreecodeEncoder;

/**
 * Compiled method representation
 * Corresponds to SCompiledMethod in Smalltalk
 * 
 * In C++, this stores a vector<LiteralValue> typed literal pool,
 * while maintaining the format and other metadata separately.
 */
class SCompiledMethod {
private:
    std::vector<LiteralValue> _literals;  // Typed literal pool
    uint32_t _format;
    void* _optimizedCode;
    std::vector<uint8_t> _treecodes;
    void* _classBinding;
    Egg::string _selector;
    Egg::string _source;
    Egg::string _methodClassname = "CompiledMethod";
    
    // Format bit layout matching Smalltalk CompiledMethod>>initializeFormatFlags:
    // ArgCount:       bits 0-5   (6 bits)
    // BlockCount:     bits 6-12  (7 bits)
    // TempCount:      bits 13-20 (8 bits)
    // CapturesSelf:   bit 21
    // HasEnvironment: bit 22
    // HasFrame:       bit 23
    // Debuggable:     bit 24
    // EnvCount:       bits 25-30 (6 bits)
    // IsExtension:    bit 31
    static constexpr uint32_t ArgCount_Shift = 0;
    static constexpr uint32_t ArgCount_Mask = 0x3F;    // 6 bits
    static constexpr uint32_t BlockCount_Shift = 6;
    static constexpr uint32_t BlockCount_Mask = 0x7F;   // 7 bits
    static constexpr uint32_t TempCount_Shift = 13;
    static constexpr uint32_t TempCount_Mask = 0xFF;    // 8 bits
    static constexpr uint32_t EnvCount_Shift = 25;
    static constexpr uint32_t EnvCount_Mask = 0x3F;    // 6 bits
    
    static constexpr uint32_t CapturesSelf = 1 << 21;
    static constexpr uint32_t HasEnvironment = 1 << 22;
    static constexpr uint32_t HasFrame = 1 << 23;
    static constexpr uint32_t Debuggable = 1 << 24;
    static constexpr uint32_t IsExtension = 1u << 31;

public:
    SCompiledMethod(std::vector<LiteralValue> literals = {});
    virtual ~SCompiledMethod();
    
    static SCompiledMethod* withAll(const std::vector<LiteralValue>& literals);
    
    uint32_t argumentCount() const;
    void argumentCount_(uint32_t count);
    
    uint32_t blockCount() const;
    void blockCount_(uint32_t count);
    
    uint32_t tempCount() const;
    void tempCount_(uint32_t count);
    
    uint32_t environmentCount() const;
    void environmentCount_(uint32_t count);
    
    bool capturesSelf() const;
    void capturesSelf_(bool value);
    
    bool hasEnvironment() const;
    void hasEnvironment_(bool value);
    
    bool hasFrame() const;
    void hasFrame_(bool value);
    
    bool isDebuggable() const;
    void beDebuggable_();
    
    Egg::string selector() const { return _selector; }
    void selector_(const Egg::string& sel) { _selector = sel; }
    
    Egg::string source() const { return _source; }
    void source_(const Egg::string& src) { _source = src; }
    
    void* classBinding() const { return _classBinding; }
    void classBinding_(void* binding) { _classBinding = binding; }
    
    const std::vector<uint8_t>& treecodes() const { return _treecodes; }
    void treecodes_(const std::vector<uint8_t>& codes) { _treecodes = codes; }
    
    uint32_t format() const { return _format; }
    void format_(uint32_t fmt) { _format = fmt; }
    
    const std::vector<LiteralValue>& literals() const { return _literals; }
    
    int indexOf(const LiteralValue& lit) const {
        for (size_t i = 0; i < _literals.size(); i++) {
            if (_literals[i] == lit) return static_cast<int>(i + 1); // 1-based
        }
        return 0;
    }
    
    std::vector<SCompiledBlock*> blocks() const;
    
    void pragma_(void* pragma) { /* TODO */ }

    Egg::string methodClassname() const { return _methodClassname; }
    void methodClassname_(const Egg::string& name) { _methodClassname = name; }

    void* optimizedCode() const { return _optimizedCode; }
    void optimizedCode_(void* code) { _optimizedCode = code; }
    
private:
    uint32_t getBits_(uint32_t shift, uint32_t mask) const;
    void setBits_(uint32_t shift, uint32_t mask, uint32_t value);
};

} // namespace Egg

#endif // _SCOMPILEDMETHOD_H_
