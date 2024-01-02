'use strict';

import './lmr.js';
import PowertalkLMR from "./interpreter/PowertalkLMR.js";

import ImageSegmentReader from "./ImageSegmentReader.js"

import path from 'path';
import fs from 'fs';


let Bootstrapper = class {
	constructor()
	{
		this.modules = new Map;
		this.runtime = PowertalkLMR.new();
	}

	loadKernelFile(kernelPath = 'Kernel.json')
	{
		const module = this.loadModuleFromFile(kernelPath, false);
		this.initializeKernel(module);
	}

	initializeKernel(module)
	{
		this.kernel = module;
		this.runtime.bootstrapper_(this);
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

	loadModule_(name) {

		const reader = this.loadModuleFromFile(name + '.json');
		return reader.exports["__module__"];
	}

	bindModuleImports(reader)
	{
		reader.imports = reader.data.imports.map(descriptor => this.bindModuleImport(descriptor));
	}

	bindModuleImport(descriptor)
	{
		const token = this.transferImportLiteral(descriptor[0]);
		const linker = descriptor[1] ? this.transferImportLiteral(descriptor[1]) : this.kernel.exports["nil"];
		
		const ref = this.runtime.sendLocal_to_with_("token:linker:", this.kernel.exports["SymbolicReference"], [token, linker]);
		return this.runtime.sendLocal_to_("link", ref);
	}

	transferImportLiteral(anObject)
	{
		if (Number.isInteger(anObject))
			return this.runtime.newInteger_(anObject);

		if (typeof anObject === 'string')
			return this.runtime.addSymbol_(anObject);

		if (Array.isArray(anObject))
		{
			let transferred = anObject.map(o => this.transferImportLiteral(o));
			return this.runtime.newArray_(transferred);
		}

		debugger
	}

	loadModuleFromFile(filename, sendJustLoaded = true)
	{
		const filepath = this.findInPath(filename);
		if (filepath === undefined) {
			throw new Error(`Failed to load ${filename}`);
		}
		const reader = new ImageSegmentReader();
		reader.loadFile(filepath);
		this.bindModuleImports(reader);
		reader.loadObjects();
		if (sendJustLoaded) {
			const module_ = reader.exports["__module__"];
			this.runtime.sendLocal_to_("justLoaded", module_);
		} 
		return reader;
	}

	findInPath(imageSegmentFile)
	{
		const dirs = ['./', '../'];
		const searched = 'image-segments/' + imageSegmentFile;
		for (const dir of dirs) {
			const filePath = path.join(dir, searched);

			try {
				const stats = fs.statSync(filePath);

				if (stats.isFile()) {
					return filePath;
				}
			} catch (err) { continue; }
		}
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
			_largePositiveIntegerClass: this.kernel.exports["LargePositiveInteger"],
			_largeNegativeIntegerClass: this.kernel.exports["LargeNegativeInteger"],
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
			_compiledCodeExecutableCodeIndex: 2,
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

