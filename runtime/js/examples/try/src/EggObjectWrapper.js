import EggByteObject from "./eggjs/interpreter/EggByteObject.js";
import EggObject from "./eggjs/interpreter/EggObject.js";
import EggSmallInteger from "./eggjs/interpreter/EggSmallInteger.js";

let selectorFor = function (selector, args) {
	if (args.length == 0) return selector;
	if (args.length == 1) return selector + ":";

	throw "should be implemented";
};

let EggObjectWrapper = class {
	/*				if (typeof prop == "function")
						return function(...args) {
							return prop.call(args);
						}
	*/

	constructor() {
		this._wrappee = nil;
		this._runtime = nil;
		return new Proxy(this, {
			get(target, p) {
				if (p in target) {
					return target[p];
				} else {
					return function (...args) {
						return target.doesNotUnderstand_(
							selectorFor(p, args),
							args
						);
					};
				}
			},
		});
	}

	static wrap(object, runtime) {
		const type =
			runtime.sendLocal_to_("isSpecies", object) === runtime.true()
				? EggSpeciesWrapper
				: runtime.sendLocal_to_("isModule", object) === runtime.true()
				? EggModuleWrapper
				: EggObjectWrapper;
		return type.on_runtime_(object, runtime);
	}

	static wrapCollection(collection, runtime) {
		return collection
			.asArray()
			.wrappee()
			.slots()
			.map((e) => this.wrap(e, runtime));
	}

	initialize() {}

	static on_runtime_(anEggObject, anEggRuntime) {
		let res = this.new();
		res.wrappee_(anEggObject);
		res.runtime_(anEggRuntime);
		return res;
	}

	static on_runtime_id_(anEggObject, anEggRuntime, id) {
		let res = this.on_runtime_(anEggObject, anEggRuntime);
		res._id = id;
		return res;
	}

	wrap(object) {
		return EggObjectWrapper.wrap(object, this._runtime);
	}

	wrapCollection(collection) {
		return EggObjectWrapper.wrapCollection(collection, this._runtime);
	}

	_equal(anObject) {
		let object =
			anObject instanceof EggObjectWrapper
				? anObject.wrappee()
				: anObject;
		return this._wrappee == object;
	}

	asLocalObject() {
		if (this._wrappee === this._runtime.nil()) return nil;
		if (this._wrappee === this._runtime.true()) return true;
		if (this._wrappee === this._runtime.false()) return false;
		if (this._wrappee.class() === EggSmallInteger)
			return this._wrappee.value();
		if (this._wrappee.class() === EggByteObject)
			return this._wrappee.asLocalString();
		this.error_(
			"Cannot determine local equivalent of "._comma(
				this._wrappee.printString()
			)
		);
		return nil;
	}

	printString() {
		let print;
		try {
			print = this.send("printString").asLocalObject();
		} catch (error) {
			print = "Cannot print object";
		}
		return print;
	}

	asWebsideJson() {
		let json = { id: this._id, printString: this.printString() };
		try {
			let species = this.objectClass();
			let variable = species.isVariable();
			json.class = species.name();
			json.indexable = variable;
			json.size = variable ? this.size().wrappee().value() : 0;
			json.hasNamedSlots = species
				.instancesHavePointers()
				.asLocalObject();
			json.hasIndexedSlots = this.hasIndexedSlots().asLocalObject();
		} catch (error) {
			json.error = error.message;
		}
		return json;
	}

	displayString() {
		return this.printString();
	}

	doesNotUnderstand_(selector, args) {
		return this.send(selector, args);
	}

	send(selector, args = []) {
		let _arguments, result, _class;
		_arguments = args.map((a) => {
			return a instanceof EggObjectWrapper ? a.wrappee() : a;
		});
		result = this._runtime.sendLocal_to_with_(
			selector,
			this._wrappee,
			_arguments
		);
		if (!(result instanceof EggObject)) return result;
		_class =
			this._runtime.sendLocal_to_("isSpecies", result) ===
			this._runtime.true()
				? EggSpeciesWrapper
				: EggObjectWrapper;
		return _class.on_runtime_(result, this._runtime);
	}

	hash() {
		return this._wrappee.hash();
	}

	inspect() {
		return this._wrappee.inspect();
	}

	isKindOf_(aClass) {
		return this instanceof aClass;
	}

	isNil() {
		return this._wrappee === this._runtime.nil();
	}

	notNil() {
		return !this.isNil();
	}

	object() {
		return this._wrappee;
	}

	objectClass() {
		let _class = this._runtime.sendLocal_to_("class", this._wrappee);
		return EggSpeciesWrapper.on_runtime_(_class, this._runtime);
	}

	respondsTo(aSymbol) {
		return this.objectClass().canUnderstand(aSymbol);
	}

	runtime_(anEggRuntime) {
		this._runtime = anEggRuntime;
		return this;
	}

	slotAt_(index) {
		return this.class().on_runtime_(
			this._wrappee.slotAt_(index),
			this._runtime
		);
	}

	wrappee() {
		return this._wrappee;
	}

	wrappee_(anEggObject) {
		this._wrappee = anEggObject;
		return this;
	}
};

const cachedSymbols = {};

let EggSpeciesWrapper = class extends EggObjectWrapper {
	_shiftRight(aSymbol) {
		let symbol;
		symbol = this._runtime.symbolFromLocal_(aSymbol);
		return EggMethodWrapper.on_runtime_(
			this.send("shiftRight", [symbol]).wrappee(),
			this._runtime
		);
	}

	allInstVarNames() {
		return this.send("allInstVarNames")
			.asArray()
			.wrappee()
			.slots()
			.map((s) => s.asLocalString());
	}

	allSubclasses() {
		const slots = this.send("allSubclasses").asArray().wrappee().slots();
		const mapped = slots.map((c) =>
			EggSpeciesWrapper.on_runtime_(c, this._runtime)
		);

		return mapped;
	}

	allSubspecies() {
		const slots = this.send("allSubspecies").asArray().wrappee().slots();
		const mapped = slots.map((c) =>
			EggSpeciesWrapper.on_runtime_(c, this._runtime)
		);

		return mapped;
	}

	allSuperclasses() {
		return this.send("allSuperclasses")
			.asArray()
			.wrappee()
			.slots()
			.map((c) => EggSpeciesWrapper.on_runtime_(c, this._runtime));
	}

	asWebsideJson() {
		let json = super.asWebsideJson();
		json["name"] = this.name();
		json["definition"] = this.definition();
		json["superclass"] =
			this.superclass().wrappee() !== this._runtime.nil()
				? this.superclass().name()
				: null;
		json["comment"] = this.instanceClass().comment();
		json["variable"] = false;
		const module = this.module();
		json["package"] = module.notNil() ? module.name().asLocalObject() : "";
		return json;
	}

	categories() {
		return this.send("categories")
			.asArray()
			.wrappee()
			.slots()
			.map((c) => c.asLocalString());
	}

	cachedSymbolFor(string) {
		let symbol;
		symbol = cachedSymbols[string];
		if (!symbol || typeof symbol !== "object") {
			symbol = this._runtime.addSymbol_(string);
			cachedSymbols[string] = symbol;
		}
		return symbol;
	}

	classVarNames() {
		return this.send("classVarNames")
			.asArray()
			.wrappee()
			.slots()
			.map((s) => s.asLocalString());
	}

	classVariablesString() {
		return String.streamContents_((s) => {
			return this.classVarNames().do_separatedBy_(
				(n) => {
					return s.nextPutAll_(n);
				},
				() => {
					return s.space();
				}
			);
		});
	}

	comment() {
		return this.send("comment").wrappee().asLocalString();
	}

	compile_(aString) {
		let local,
			size,
			kernel,
			name,
			_class,
			method,
			astcodes,
			selector,
			format,
			code,
			md;
		debugger;
		/*		local = SCompiler.new().compile_(aString);
		size = this._runtime.newInteger_(local.size());
		kernel = this._runtime.sendLocal_to_("namespace", this._runtime.kernel());
		name = this._runtime.symbolFromLocal_("CompiledMethod");
		_class = this._runtime.sendLocal_to_with_("at:", kernel, [name]);
		method = this._runtime.sendLocal_to_with_("new:", _class, [size]);
		astcodes = this._runtime.newByteArray_(local.astcodes());
		selector = this._runtime.addSymbol_(local.selector());
		format = this._runtime.newInteger_(local.format());
		code = this._runtime.newString_(local.source());
		_cascade(this._runtime, (_recv) => {
			_recv.sendLocal_to_with_("astcodes:", method, [astcodes]);
			_recv.sendLocal_to_with_("classBinding:", method, [this._wrappee]);
			_recv.sendLocal_to_with_("selector:", method, [selector]);
			_recv.sendLocal_to_with_("format:", method, [format]);
			return _recv.sendLocal_to_with_("sourceObject:", method, [code]);});
		local.withIndexDo_((literal, i) => {
			tliteral = this._runtime.bootstrapper().transferLiteral_(literal);
			return method.at_put_(i, tliteral)
		});
		md = this._runtime.sendLocal_to_("methodDictionary", this._wrappee);
		this._runtime.sendLocal_to_with_("at:put:", md, [selector, method]);
		return method;
	*/
	}

	definition() {
		let highest;
		return String.streamContents_((strm) => {
			highest = this.superclass().wrappee()._equal(this._runtime.nil());
			highest.ifTrue_ifFalse_(
				() => {
					return strm.nextPutAll_("ProtoObject");
				},
				() => {
					return strm.nextPutAll_(this.superclass().name());
				}
			);
			_cascade(strm, (_recv) => {
				_recv.space();
				_recv.nextPutAll_(
					this.kindOfSubclass().wrappee().asLocalString()
				);
				_recv.space();
				_recv.nextPutAll_("#");
				_recv.nextPutAll_(this.name());
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("instanceVariableNames: '");
				_recv.nextPutAll_(this.instanceVariablesString());
				_recv.nextPutAll_("'");
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("classVariableNames: '");
				_recv.nextPutAll_(this.classVariablesString());
				_recv.nextPutAll_("'");
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("poolDictionaries: '");
				_recv.nextPutAll_(this.sharedPoolsString());
				_recv.nextPutAll_("'");
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("category: ");
				return _recv.store_("");
			});
			return highest.ifTrue_(() => {
				return _cascade(strm, (_recv) => {
					_recv.nextPutAll_(".");
					_recv.cr();
					_recv.nextPutAll_(this.name());
					_recv.space();
					return _recv.nextPutAll_("superclass: nil");
				});
			});
		});
	}

	canUnderstand(aSymbol) {
		let symbol = this.cachedSymbolFor(aSymbol);
		return this.send("canUnderstand:", [symbol]).asLocalObject();
	}

	includesSelector(aSymbol) {
		let symbol = this.cachedSymbolFor(aSymbol);
		return this.send("includesSelector:", [symbol]).asLocalObject();
	}

	isVariable() {
		return this.send("isVariable").asLocalObject();
	}

	methodFor(aSymbol) {
		let symbol = this.cachedSymbolFor(aSymbol);
		let method = this.send(">>", [symbol]);
		return EggMethodWrapper.on_runtime_(method.wrappee(), this._runtime);
	}

	instVarNames() {
		return this.send("instVarNames")
			.asArray()
			.wrappee()
			.slots()
			.map((s) => s.asLocalString());
	}

	instanceVariablesString() {
		return String.streamContents_((s) => {
			return this.instVarNames().do_separatedBy_(
				(n) => {
					return s.nextPutAll_(n);
				},
				() => {
					return s.space();
				}
			);
		});
	}

	metaclass() {
		return this.class().on_runtime_(
			this._runtime.sendLocal_to_("class", this._wrappee),
			this._runtime
		);
	}

	methods() {
		let md;
		md = this.methodDictionary();
		return md
			.values()
			.asSet()
			.asArray()
			.wrappee()
			.slots()
			.map((m) => EggMethodWrapper.on_runtime_(m, this._runtime));
	}

	name() {
		return this.send("name").wrappee().asLocalString();
	}

	removeSelector_(aSymbol) {
		let symbol;
		symbol = this._runtime.symbolFromLocal_(aSymbol);
		this.send("removeSelector:", [symbol]);
		return this;
	}

	sharedPoolsString() {
		return "";
	}

	subclasses() {
		return this.send("subclasses")
			.asArray()
			.wrappee()
			.slots()
			.map((c) => EggSpeciesWrapper.on_runtime_(c, this._runtime));
	}

	withAllSubclasses() {
		return [this].concat(this.allSubclasses());
	}

	withAllSubspecies() {
		return [this].concat(this.allSubspecies());
	}

	withAllSuperclasses() {
		return [this].concat(this.allSuperclasses());
	}
};

let EggMethodWrapper = class extends EggObjectWrapper {
	asWebsideJson() {
		let json = super.asWebsideJson();
		try {
			json.selector = this.selector();
		} catch (error) {
			json.selector = "Error retrieving selector: " + error.message;
		}
		let species;
		try {
			species = this.classBinding();
			json.methodClass = species ? species.name() : "Unknown class";
		} catch (error) {
			json.methodClass = "Error retrieving class: " + error.message;
		}
		try {
			json.source = this.sourceCode();
		} catch (error) {
			json.source = "Error retrieving source: " + error.message;
		}
		json.category = "Unknown category";
		json.author = "Unknown author";
		json.timestamp = "Unknown timeStamp";
		json.overriding = false;
		json.overriden = false;
		const module = this.module();
		json["package"] = module.notNil() ? module.name().asLocalObject() : "";
		return json;
	}

	selector() {
		let s;
		if (this.respondsTo("selector")) {
			s = this.send("selector");
		}
		if (s) return s.wrappee().asLocalString();
		//This means the wrappee is a block...
		return "[]";
	}

	sourceCode() {
		let source;
		source = this.sourceObject();
		if (!source) return "no source";
		source = source.wrappee();
		if (source === this._runtime.nil()) return "no source";
		else return source.asLocalString();
	}
};

let EggModuleWrapper = class extends EggObjectWrapper {
	asWebsideJson() {
		let json = super.asWebsideJson();
		let classes = this.classes();
		try {
			json.name = this.name();
		} catch (error) {}
		json.classes = this.wrapCollection(this.classes()).map((c) => c.name());
		json.methods = {};
		let extensions = this.wrapCollection(this.extensions().associations());
		extensions.forEach((a) => {
			let classname = a.key().asLocalObject();
			json.methods[classname] = this.wrapCollection(a.value()).map((m) =>
				m.selector().asLocalObject()
			);
		});
		return json;
	}

	name() {
		return this.send("name").wrappee().asLocalString();
	}
};

export {
	EggObjectWrapper,
	EggSpeciesWrapper,
	EggMethodWrapper,
	EggModuleWrapper,
};
