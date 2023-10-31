import PowerlangMethodWrapper from "./PowerlangMethodWrapper.js";
import PowerlangObjectWrapper from "./PowerlangObjectWrapper.js";
//import SCompiler from './SCompiler.js';
const cachedSymbols = {};

let PowerlangSpeciesWrapper = class extends PowerlangObjectWrapper {
	_shiftRight(aSymbol) {
		let symbol;
		symbol = this._runtime.symbolFromLocal_(aSymbol);
		return PowerlangMethodWrapper.on_runtime_(
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
			PowerlangSpeciesWrapper.on_runtime_(c, this._runtime)
		);

		return mapped;
	}

	allSubspecies() {
		const slots = this.send("allSubspecies").asArray().wrappee().slots();
		const mapped = slots.map((c) =>
			PowerlangSpeciesWrapper.on_runtime_(c, this._runtime)
		);

		return mapped;
	}

	allSuperclasses() {
		return this.send("allSuperclasses")
			.asArray()
			.wrappee()
			.slots()
			.map((c) => PowerlangSpeciesWrapper.on_runtime_(c, this._runtime));
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
		json["project"] = "";
		return json;
	}

	categories() {
		return this.send("categories")
			.asArray()
			.wrappee()
			.slots()
			.map((c) => c.asLocalString());
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
				_recv.store_(this.name());
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("instanceVariableNames: ");
				_recv.store_(this.instanceVariablesString());
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("classVariableNames: ");
				_recv.store_(this.classVariablesString());
				_recv.cr();
				_recv.tab();
				_recv.nextPutAll_("poolDictionaries: ");
				_recv.store_(this.sharedPoolsString());
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

	includesSelector_(aSymbol) {
		let symbol;
		symbol = cachedSymbols[aSymbol];
		if (!symbol) {
			symbol = this._runtime.addSymbol_(aSymbol);
			cachedSymbols[aSymbol] = symbol;
		}
		return this.send("includesSelector:", [symbol]).asLocalObject();
	}

	methodFor_(aSymbol) {
		let symbol;
		symbol = cachedSymbols[aSymbol];
		if (!symbol) {
			symbol = this._runtime.addSymbol_(aSymbol);
			cachedSymbols[aSymbol] = symbol;
		}
		let method = this.send(">>", [symbol]);
		return PowerlangMethodWrapper.on_runtime_(
			method.wrappee(),
			this._runtime
		);
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
			.map((m) => PowerlangMethodWrapper.on_runtime_(m, this._runtime));
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
			.map((c) => PowerlangSpeciesWrapper.on_runtime_(c, this._runtime));
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

PowerlangObjectWrapper.setPowerlangSpeciesWrapper(PowerlangSpeciesWrapper);

export default PowerlangSpeciesWrapper;
