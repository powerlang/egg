'use strict';

import './lmr.js';
import PowertalkLMR from "./interpreter/PowertalkLMR.js";

import ModuleReader from "./ModuleReader.js"



let Bootstrapper = class {
	constructor()
	{
		this.modules = new Map;
		this.runtime = PowertalkLMR.new();
	}

	loadKernelFile(kernelPath = 'Kernel.json')
	{
		const module = this.loadModuleFromFile(kernelPath);
		this.initializeKernel(module);
	}

	initializeKernel(module)
	{
		this.kernel = module;
		//Object.assign(this.runtime, this.kernel.meta);
		Object.assign(this.runtime, this.kernelMeta());
		Object.assign(this.runtime, this.kernelObjects());
		const symbols = this.kernel.exports["KnownSymbols"]._slots.map(symbol => symbol.asLocalString()._arrow(symbol));
		this.initializeSymbolTable();
		this.runtime.knownSymbols_(new Map(Object.entries(symbols)));
		this.runtime.initializeInterpreter();
	}

	initializeSymbolTable()
	{
		const symbol = this.kernel.exports["SymbolTable"];
		this.runtime.symbolTable_(symbol);
	}

	loadModuleFromFile(path)
	{
		const reader = new ModuleReader();
		return this.loadModuleNamed(reader.loadFile(path), path);
	}

	loadModuleNamed(module, name)
	{
		return this.modules[name] = module;
	}

	kernelObjects()
	{
		return {
			_falseObj: this.kernel.exports["false"],
			_trueObj:  this.kernel.exports["true"],
			_nilObj:   this.kernel.exports["nil"],
			_arrayClass:        this.kernel.exports["Array"],
			_metaclassClass:    this.kernel.exports["Metaclass"],
			_methodClass:       this.kernel.exports["CompiledMethod"],
			_smallIntegerClass: this.kernel.exports["SmallInteger"],
			_blockClass:        this.kernel.exports["CompiledBlock"],
			_byteArrayClass:    this.kernel.exports["ByteArray"],
			_stringClass:       this.kernel.exports["String"],
			_closureClass:      this.kernel.exports["Closure"],
			_behaviorClass:     this.kernel.exports["Behavior"]
		};
	}

// TODO:  (difficulty easy)
// this method should not exist, because the image segment should be self-descriptive.
// but that needs to be implemented, meanwhile we resort to hardcoded info
//
	kernelMeta () {
		return {
			_wordSize: 8,
			_behaviorNextIndex: 3,
			_behaviorMethodDictionaryIndex: 2,
			_behaviorClassIndex: 1,
			_classNameIndex: 6,
			_methodFlagsIndex: 1,
			_maxSMI: BigInt("4611686018427387903"),
			_minSMI: BigInt("-4611686018427387904"),
			_speciesInstanceBehaviorIndex: 2,
			_speciesFormatIndex: 3,
			_methodOptimizedCodeIndex: 2,
			_methodAstcodesIndex: 3,
			_methodInstSize: 6,
			_methodClassBindingIndex: 4,
			_speciesSuperclassIndex: 1,
			_speciesIvarsIndex: 5,
			_dictionaryTableIndex: 2,
			_classClassVariablesIndex: 8,
			_metaclassInstanceClassIndex: 6,
			_classNamespacesIndex: 8,
			_classModuleIndex: 9,
			_moduleNamespaceIndex: 4,
			_closureBlockIndex: 1,
			_blockMethodIndex: 3
		};
	}
}

export default Bootstrapper

