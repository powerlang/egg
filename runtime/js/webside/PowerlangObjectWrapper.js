import LMRByteObject from "../interpreter/LMRByteObject.js";
import LMRObject from "../interpreter/LMRObject.js";
import LMRSmallInteger from "../interpreter/LMRSmallInteger.js";

let PowerlangSpeciesWrapper;

let selectorFor = function (selector, args) {
	if (args.length == 0) return selector;
	if (args.length == 1) return selector + ":";

	throw "should be implemented";
};

let PowerlangObjectWrapper = class {
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

	static setPowerlangSpeciesWrapper(obj) {
		PowerlangSpeciesWrapper = obj;
	}

	initialize() {}

	static on_runtime_(anLMRObject, aPowerlangLMR) {
		let res = this.new();
		res.wrappee_(anLMRObject);
		res.runtime_(aPowerlangLMR);
		return res;
	}

	_equal(anObject) {
		let object =
			anObject instanceof PowerlangObjectWrapper
				? anObject.wrappee()
				: anObject;
		return this._wrappee == object;
	}

	asLocalObject() {
		if (this._wrappee === this._runtime.nil()) return nil;
		if (this._wrappee === this._runtime.true()) return true;
		if (this._wrappee === this._runtime.false()) return false;
		if (this._wrappee.class() === LMRSmallInteger)
			return this._wrappee.value();
		if (this._wrappee.class() === LMRByteObject)
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
		let json = { id: this.id, printString: this.printString() };
		try {
			let species = this.objectClass();
			let variable = species.isVariable();
			json.class = species.name();
			json.indexable = variable;
			json.size = variable ? this.size().wrappee().value() : 0;
			json.hasNamedSlots = species.instancesHavePointers().asLocalObject();
			json.hasIndexedSlots = this.hasIndexedSlots().asLocalObject();
		}
		catch (error) { json.error = error.message }
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
			return a instanceof PowerlangObjectWrapper ? a.wrappee() : a;
		});
		result = this._runtime.sendLocal_to_with_(
			selector,
			this._wrappee,
			_arguments
		);
		if (!(result instanceof LMRObject)) return result;
		_class =
			this._runtime.sendLocal_to_("isSpecies", result) === this._runtime.true() ?
				PowerlangSpeciesWrapper
				: PowerlangObjectWrapper;
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

	notNil() {
		return this._runtime
			.sendLocal_to_("notNil", this._wrappee)
			._notEqual(this._runtime.nil());
	}

	object() {
		return this._wrappee;
	}

	objectClass() {
		let _class = this._runtime.sendLocal_to_("class", this._wrappee);
		return PowerlangSpeciesWrapper.on_runtime_(_class, this._runtime);
	}

	respondsTo_(aSymbol) {
		return this.class().canUnderstand_(aSymbol);
	}

	runtime_(aPowerlangLMR) {
		this._runtime = aPowerlangLMR;
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

	wrappee_(anLMRObject) {
		this._wrappee = anLMRObject;
		return this;
	}
};

export default PowerlangObjectWrapper;
