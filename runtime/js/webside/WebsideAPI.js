import { EggObjectWrapper, EggMethodWrapper } from "./EggObjectWrapper.js";
import * as logo from "./logo.js";

class WebsideAPI extends Object {
	constructor(server, request, response) {
		super();
		this.server = server;
		this.runtime = server.runtime;
		this.request = request;
		this.response = response;
	}

	kernelModule() {
		return this.runtime.bootstrapper().kernel.exports["Kernel"];
	}

	scompiler() {
		let name = this.runtime.addSymbol_("Compiler");
		const module = this.runtime.sendLocal_to_with_(
			"load:",
			this.kernelModule(),
			[name]
		);
		const namespace = this.runtime.sendLocal_to_("namespace", module);
		name = this.runtime.addSymbol_("SCompiler");
		const scompiler = this.runtime.sendLocal_to_with_("at:", namespace, [
			name,
		]);
		return scompiler;
	}

	notFound() {
		this.response.sendStatus(404);
	}

	badRequest(text) {
		this.response.status(400).send(text || "Bad Request");
	}

	error(text) {
		this.response.status(500).send(text || "Internal server error");
	}

	respondWithData(data) {
		this.response.end(data);
	}

	respondWithJson(json) {
		this.response.json(json);
	}

	//General endpoints
	dialect() {
		this.respondWithData("EggJS");
	}

	logo() {
		this.respondWithData(logo.data);
	}

	colors() {
		this.respondWithJson({ primary: "#81C784", secondary: "#2E7D32" });
	}

	//Changes endpoints
	addChange() {
		let change = this.request.body;
		var result;
		switch (change.type) {
			case "AddMethod":
				result = this.applyAddMethod(change);
				break;
			case "RemoveMethod":
				result = this.applyRemoveMethod(change);
				break;
			default:
				this.badRequest(
					"Change type " + change.type + " not supported"
				);
				this.badRequest(
					"Change type " + change.type + " not supported"
				);
		}
		return this.respondWithJson(result);
	}

	applyRemoveMethod(change) {
		return change;
	}

	compile(source, species) {
		const code = this.runtime.newString_(source);
		const method = this.runtime.sendLocal_to_with_(
			"compile:in:",
			this.scompiler(),
			[code, species.wrappee()]
		);
		this.runtime.sendLocal_to_("install", method);
		return method;
	}

	//Code endpoints..."
	package() {
		const pack = this.requestedPackage();
		if (pack.isNil()) return this.notFound();
		this.respondWithJson(pack.asWebsideJson());
	}

	packages() {
		const modules = this.loadedModules();
		if (this.queryAt("names") === "true") {
			const names = modules.map((m) => {
				return m.name().asLocalObject();
			});
			return this.respondWithJson(names);
		}
		this.respondWithJson(modules.map((c) => c.asWebsideJson()));
	}

	packageClasses() {
		const pack = this.requestedPackage();
		if (pack.isNil()) return this.notFound();
		const defined = this.wrapCollection(pack.classes());
		const extended =
			this.queryAt("extended") == "true"
				? this.wrapCollection(pack.extensionClasses())
				: [];
		const all = defined.concat(extended);
		if (this.queryAt("tree") == "true") {
			const tree = this.classTreeFromClasses(all);
			return this.respondWithJson(tree);
		}
		if (this.queryAt("names") == "true") {
			return this.respondWithJson(all.map((c) => c.name()));
		}
		return this.respondWithJson(all.map((c) => c.asWebsideJson()));
	}

	classes() {
		let root = this.queryAt("root");
		if (root) root = this.classNamed(root);
		else root = this.defaultRootClass();
		if (this.queryAt("tree") === "true") {
			let depth = this.queryAt("depth");
			if (depth) depth = parseInt(depth);
			const json = this.classTreeFrom(root, depth);
			return this.respondWithJson([json]);
		}
		const classes = [root].concat(root.allSubclasses());
		if (this.queryAt("names") === "true") {
			const names = classes.map((c) => c.name());
			return this.respondWithJson(names);
		}
		this.respondWithJson(classes.map((c) => c.asWebsideJson()));
	}

	classDefinition() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		this.respondWithJson(species.asWebsideJson());
	}

	classVariables() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		let variables = species.withAllSuperclasses().flatMap((c) =>
			c.classVarNames().map((v) => {
				return { name: v, class: c.name(), type: "class" };
			})
		);
		this.respondWithJson(variables);
	}

	instanceVariables() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		let variables = species.withAllSuperclasses().flatMap((c) => {
			c.instVarNames().map((v) => {
				return { name: v, class: c.name(), type: "instance" };
			});
		});
		this.respondWithJson(variables);
	}

	variables() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		let variables = species.withAllSuperclasses().flatMap((c) => {
			let instance = c.instVarNames().map((v) => {
				return { name: v, class: c.name(), type: "instance" };
			});
			let meta = c.classVarNames().map((v) => {
				return { name: v, class: c.name(), type: "class" };
			});
			return instance.concat(meta);
		});
		this.respondWithJson(variables);
	}

	superclasses() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		let superclasses = species
			.withAllSuperclasses()
			.map((c) => c.asWebsideJson());
		this.respondWithJson(superclasses);
	}

	subclasses() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		let subclasses = species.subclasses().map((c) => c.asWebsideJson());
		this.respondWithJson(subclasses);
	}

	categories() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		this.respondWithJson(species.categories());
	}

	usedCategories() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		this.respondWithJson([]);
	}

	method() {
		const species = this.requestedClass();
		if (!species) return this.notFound();
		const selector = this.requestedSelector();
		if (!selector) return this.notFound();
		if (!species.includesSelector(selector)) return this.notFound();
		const method = species.methodFor(selector);
		this.respondWithJson(method.asWebsideJson());
	}

	methods() {
		let methods;
		let selector = this.queriedSelector();
		if (selector) methods = this.implementorsOf(selector);
		selector = this.queriedSending();
		if (selector) {
			let senders = this.sendersOf(selector);
			methods = methods ? methods.intersection(senders) : senders;
		}
		let global = this.queriedReferencingClass();
		if (global) {
			let references = this.referencesTo(global);
			methods = methods ? methods.intersection(references) : references;
		}
		let species = this.requestedClass();
		if (!species) species = this.queriedClass();
		if (species && methods)
			methods = methods.filter((m) => m.classBinding()._equal(species));
		if (!methods) {
			if (!species) species = this.defaultRootClass();
			methods = species.methods();
		}
		methods = this.filterByCategory(methods);
		methods = this.filterByVariable(methods);
		this.respondWithJson(methods.map((m) => m.asWebsideJson()));
	}

	usualCategories() {
		this.respondWithJson([]);
	}

	compileMethod() {
		let species = this.requestedClass();
		if (!species) return this.notFound();
		const source = this.bodyAt("sourceCode");
		const method = this.compile(source, species);
		const wrapper = EggMethodWrapper.on_runtime_(method, this.runtime);
		return this.respondWithJson(wrapper.asWebsideJson());
	}

	//Objects endpoints..."
	pinnedObjects() {
		let objects = Object.entries(this.server.pinnedObjects).map((e) => {
			let json = e[1].asWebsideJson();
			json.id = e[0].toString();
			return json;
		});
		this.respondWithJson(objects);
	}

	pinnedObject() {
		let id = this.requestedId();
		let object = this.objectWithId(id);
		if (!object) return this.notFound();
		this.respondWithJson(object.asWebsideJson());
	}

	pinnedObjectSlots() {
		let id = this.requestedId();
		let object = this.objectWithId(id);
		if (!object) return this.notFound();
		let path = this.request.path.split("/");
		let index = path.indexOf("objects");
		for (let i = index + 2; i < path.length - 1; i++) {
			object = this.slotOf(path[i], object);
			if (!object) return this.notFound();
		}
		let last = path.pop();
		if (last == "instance-variables") {
			return this.respondWithJson(this.instanceVariablesOf(object));
		}
		if (last == "named-slots") {
			return this.respondWithJson(this.namedSlotsOf(object));
		}
		if (last == "indexed-slots") {
			return this.respondWithJson(this.indexedSlotsOf(object));
		}
		if (last == "custom-presentations") {
			return this.respondWithJson(this.customPresentationsOf(object));
		}
		object = this.slotOf(last, object);
		if (!object) return this.notFound();
		this.respondWithJson(object.asWebsideJson());
	}

	pinSampleObjects() {
		this.server.pinnedObjects[this.server.newId()] = this.wrap(
			this.runtime.nil()
		);
		this.server.pinnedObjects[this.server.newId()] = this.wrap(
			this.runtime.true()
		);
		this.server.pinnedObjects[this.server.newId()] = this.wrap(
			this.runtime.newInteger_(123)
		);
		this.server.pinnedObjects[this.server.newId()] = this.wrap(
			this.runtime.newArray_([
				this.runtime.nil(),
				this.runtime.true(),
				this.runtime.newInteger_(123),
			])
		);
		let x = this.runtime.newInteger_(1);
		let y = this.runtime.newInteger_(2);
		let point = this.runtime.sendLocal_to_with_("@", x, [y]);
		this.server.pinnedObjects[this.server.newId()] = this.wrap(point);
		this.server.pinnedObjects[this.server.newId()] =
			this.classNamed("Point");
	}

	unpinObject() {
		let id = this.requestedId();
		if (!this.server.pinnedObjects.hasOwnProperty(id))
			return this.notFound();
		delete this.server.pinnedObjects[id];
		this.respondWithData(id);
	}

	pinObjectSlot() {
		let slot = this.requestedSlot();
		if (!slot) return this.badRequest("Bad object slot URI");
		// Replace with UUID or the like...
		let id = (Object.keys(this.server.pinnedObjects).length + 1).toString();
		this.server.pinnedObjects[id] = slot;
		let json = slot.asWebsideJson();
		json["id"] = id;
		this.respondWithJson(json);
	}

	//Evaluation endpoints...
	evaluations() {
		let evaluations = Object.values(this.server.evaluations).map((e) => {
			let json = {
				id: e.id.toString(),
				state: e.state,
			};
			if (e.error)
				json.error = {
					description: this.errorDescription(e.error),
				};
			return json;
		});
		this.respondWithJson(evaluations);
	}

	evaluation() {
		let id = this.requestedId();
		let evaluation = this.evaluationWithId(id);
		if (evaluation) {
			let json = {
				id: evaluation.id.toString(),
				state: evaluation.state,
			};
			if (evaluation.error)
				json.error = {
					description: this.errorDescription(evaluation.error),
				};
			return this.respondWithJson(json);
		}
		let object = this.objectWithId(id);
		if (!object) return this.notFound();
		fake = { id: id, state: "finished" };
		return this.respondWithJson(fake);
	}

	evaluateExpression() {
		let debug = this.bodyAt("debug");
		if (debug == true) return this.debugExpression();
		let expression = this.bodyAt("expression");
		let sync = this.bodyAt("sync");
		if (sync == undefined) sync = true;
		let pin = this.bodyAt("pin");
		if (pin == undefined) pin = false;
		let id = this.server.newId();
		let object;
		let source = "doIt ^(" + expression + ")";
		let evaluation = {
			id: id,
			expression: expression,
			state: "pending",
		};
		this.server.evaluations[id] = evaluation;
		let requestedClass = this.requestedClassContext();
		let requestedObject = this.requestedObjectContext();
		let targetClass = requestedClass
			? requestedClass.metaclass()
			: requestedObject
			? requestedObject.objectClass()
			: this.classNamed("Object");
		let receiver = requestedObject
			? requestedObject.wrappee()
			: requestedClass
			? requestedClass.wrappee()
			: this.runtime.nil();
		try {
			this.compile(source, targetClass);
			object = this.runtime.sendLocal_to_("doIt", receiver);
			//this.runtime.sendLocal_to_with_("removeSelector:", species, [selector]);
			object = this.wrapWithId(object, id);
			evaluation.state = "finished";
		} catch (error) {
			evaluation.state = "failed";
			evaluation.error = error;
		}
		// Despite the value of 'sync', only synchronous evaluations are supported by the moment:
		// This execution point is reached only when the expression is already evaluated (or an error was found).
		// However, from this point on, the we respond according to the 'sync' value:
		// 	- If sync=true, we respond with either the resulting object or the error found, as specified by Webside API.
		// 	  See https://github.com/guillermoamaral/Webside/tree/main/docs/api/evaluations for more details
		//	- If sync=false, we respond with it.
		if (sync) {
			if (evaluation.state === "failed")
				return this.evaluationError(evaluation);
			delete this.server.evaluations[id];
			let json = object.asWebsideJson();
			if (pin) {
				this.server.pinnedObjects[id] = object;
				json.id = id.toString();
			}
			return this.respondWithJson(json);
		}
		if (evaluation.state === "finished")
			this.server.pinnedObjects[id] = object;
		let json = { id: evaluation.id.toString(), state: evaluation.state };
		if (evaluation.error)
			json.error = {
				description: this.errorDescription(evaluation.error),
			};
		return this.respondWithJson(json);
	}

	//Debugging endpoints...
	createDebugger() {
		let id = this.bodyAt("evaluation");
		if (!id) return this.notFound();
		let evaluation = this.evaluationWithId(id);
		if (!evaluation) return this.notFound();
		let _debugger = {
			id: id,
			description: this.errorDescription(evaluation.error),
		};
		this.server.debuggers[id] = _debugger;
		this.respondWithJson(_debugger);
	}

	debuggerFrames() {
		let id = this.requestedId();
		let _debugger = this.debuggerWithId(id);
		if (!_debugger) return this.notFound();
		let evaluation = this.evaluationWithId(id);
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		let json = frames.map((frame, index) => {
			let method = EggMethodWrapper.on_runtime_(frame[0], this.runtime);
			let receiver = EggObjectWrapper.on_runtime_(frame[1], this.runtime);
			let label =
				receiver.objectClass().name() + ">>" + method.selector();
			return { index: index, label: label };
		});
		this.respondWithJson(json);
	}

	debuggerFrame() {
		let id = this.requestedId();
		let _debugger = this.debuggerWithId(id);
		if (!_debugger) return this.notFound();
		let index = this.requestedIndex();
		let evaluation = this.evaluationWithId(id);
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		if (index > frames.length - 1) return this.notFound();
		let frame = frames[index];
		let method = EggMethodWrapper.on_runtime_(frame[0], this.runtime);
		let receiver = EggObjectWrapper.on_runtime_(frame[1], this.runtime);
		let label = receiver.objectClass().name() + ">>" + method.selector();
		let json = {
			index: index,
			label: label,
			class: receiver.objectClass().asWebsideJson(),
			method: method.asWebsideJson(),
			interval: [0, 0],
		};
		this.respondWithJson(json);
	}

	frameBindings() {
		let id = this.requestedId();
		let _debugger = this.debuggerWithId(id);
		if (!_debugger) return this.notFound();
		let index = this.requestedIndex();
		let evaluation = this.evaluationWithId(id);
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		if (index > frames.length - 1) return this.notFound();
		let frame = frames[index];
		let code = EggMethodWrapper.on_runtime_(frame[0], this.runtime);
		let receiver = EggObjectWrapper.on_runtime_(frame[1], this.runtime);
		let bindings = [
			{ name: "self", type: "variable", value: receiver.printString() },
		];
		let object, wrapper, binding;
		for (let i = 1; i <= code.argumentCount().asLocalObject(); i++) {
			object = context.argumentAt_frameIndex_(i, index + 1);
			wrapper = EggObjectWrapper.on_runtime_(object, this.runtime);
			binding = {
				name: "argument" + i,
				type: "argument",
				value: wrapper.printString(),
			};
			bindings.push(binding);
		}
		for (let i = 1; i <= code.tempCount().asLocalObject(); i++) {
			object = context.stackTemporaryAt_frameIndex_(i, index + 1);
			wrapper = EggObjectWrapper.on_runtime_(object, this.runtime);
			binding = {
				name: "temporary" + i,
				type: "temporary",
				value: wrapper.printString(),
			};
			bindings.push(binding);
		}
		this.respondWithJson(bindings);
	}

	deleteDebugger() {
		let id = this.requestedId();
		let _debugger = this.debuggerWithId(id);
		if (_debugger) {
			delete this.server.debuggers[id];
			delete this.server.evaluations[id];
			delete this.server.pinnedObjects[id];
		}
		this.respondWithData(id);
	}

	//Extension endpoints...
	extensions() {
		this.respondWithJson([]);
	}

	//Private...
	wrapWithId(object, id) {
		return EggObjectWrapper.on_runtime_id_(object, this.runtime, id);
	}

	wrap(object) {
		return EggObjectWrapper.wrap(object, this.runtime);
	}

	wrapCollection(collection) {
		return EggObjectWrapper.wrapCollection(collection, this.runtime);
	}

	loadedModules() {
		const dictionary = this.wrap(
			this.runtime.sendLocal_to_("loadedModules", this.kernelModule())
		);
		return this.wrapCollection(dictionary.values());
	}

	packageNamed(name) {
		const symbol = this.runtime.addSymbol_(name);
		return this.wrap(
			this.runtime.sendLocal_to_with_(
				"loadedModuleNamed:",
				this.kernelModule(),
				[symbol]
			)
		);
	}

	defaultRootClass() {
		const nil = this.runtime.nil();
		let root = this.wrap(nil).objectClass();
		while (!(root.superclass().wrappee() === nil)) root = root.superclass();
		return root;
	}

	classTreeFrom(species, depth) {
		const names = this.queryAt("names");
		var json;
		if (names === "true") {
			var superclass = species.superclass();
			json = {
				name: species.name(),
				superclass:
					superclass === this.runtime.nil()
						? superclass
						: superclass.name,
			};
		} else {
			json = species.asWebsideJson();
		}
		if (depth && depth == 0) return json;
		//const sorted = species.subclasses().sort( (a, b) => a.name < b.name);
		const subclasses = species
			.subclasses()
			.map((s) => this.classTreeFrom(s, depth - 1));
		json["subclasses"] = subclasses;
		return json;
	}

	classTreeFromClasses(classes) {
		const roots = {};
		let removable = [];
		let moniker, superclass, root, superclasses;
		classes.forEach((c) => {
			moniker = c.name();
			roots[moniker] = { name: moniker };
		});
		classes.forEach((c) => {
			superclass = c.superclass();
			if (superclass.notNil()) {
				moniker = superclass.name();
				root = roots[moniker];
				if (root) {
					if (!root.subclasses) root.subclasses = [];
					let name = c.name();
					root.subclasses.push(roots[name]);
					removable.push(name);
				}
			}
		});
		removable.forEach((n) => delete roots[n]);
		return Object.values(roots);
	}

	classNamed(name) {
		if (!name) return;
		let identifier = name;
		let metaclass = name.endsWith(" class");
		if (metaclass) identifier = identifier.slice(0, -" class".length);
		let root = this.defaultRootClass();
		let species = root
			.withAllSubclasses()
			.detect_((c) => c.name() == identifier);
		if (!species) return;
		return metaclass ? species.metaclass() : species;
	}

	filterByCategory(methods) {
		let category = this.queriedCategory();
		return category
			? methods.filter((m) => m.category() == category)
			: methods;
	}

	filterByVariable(methods) {
		let variable = this.queriedAccessing();
		if (!variable) return methods;
		return methods.filter((m) => {
			let slot = undefined;
			let classVar = undefined;
			let species = m.methodClass();
			if (species.hasSlotNamed(variable))
				slot = species.slotNamed(variable);
			if (species.classVarNames().includes_(variable))
				classVar = species.classVarNamed(variable);
			return (
				(slot && (slot.isReadIn(m) || slot.isWrittenIn(m))) ||
				(classVar && classVar.isReferencedIn(m))
			);
		});
	}

	implementorsOf(symbol) {
		let scope = this.queriedScope();
		if (scope) {
			debugger;
			return scope.implementorsOf(symbol);
		}
		let root = this.defaultRootClass();
		return root
			.withAllSubspecies()
			.filter((c) => c.includesSelector(symbol))
			.map((c) => c.methodFor(symbol));
	}

	queriedAccessing() {
		return this.queryAt("accessing");
	}

	queriedCategory() {
		return this.queryAt("category");
	}

	queriedClass() {
		let name = this.queryAt("class");
		return typeof name == "function" ? undefined : name;
	}

	queriedReferencingClass() {
		return this.queryAt("referencingClass");
	}

	queriedReferencingString() {
		return this.queryAt("referencingString");
	}

	queriedScope() {
		let scope = this.queryAt("scope");
		return this.classNamed(scope);
	}

	queriedSelector() {
		return this.queryAt("selector");
	}

	queriedSending() {
		return this.queryAt("sending");
	}

	requestedSelector() {
		return this.parameterAt("selector");
	}

	requestedClass() {
		const name = this.parameterAt("classname") || this.queryAt("classname");
		return this.classNamed(name);
	}

	requestedClassContext() {
		const context = this.bodyAt("context");
		if (!context) return;
		const classname = context.class;
		if (classname && typeof classname === "string")
			return this.classNamed(classname);
	}

	requestedObjectContext() {
		const context = this.bodyAt("context");
		if (!context) return;
		const path = context.object;
		if (path) return this.objectFromPath(path);
	}

	requestedWorkspaceContext() {
		const context = this.bodyAt("context");
		let id = context.workspace;
		if (id) return this.workspaceWithId(id);
	}

	requestedDebuggerContext() {
		const context = this.bodyAt("context");
		id = context.debugger;
		if (id) {
			const _debugger = this.debuggerWithId(id);
			if (!_debugger) return;
			const index = context.frame;
			const evaluation = this.evaluationWithId(id);
			let frames = this.errorContext(evaluation.error).backtrace();
			if (index < frames.length) return frames[index];
		}
	}

	requestedPackage() {
		const name = this.parameterAt("packagename");
		return this.packageNamed(name);
	}

	requestedId() {
		let id = this.parameterAt("id");
		return id;
	}

	evaluationWithId(id) {
		return this.server.evaluations[id];
	}

	objectWithId(id) {
		return this.server.pinnedObjects[id];
	}

	workspaceWithId(id) {
		return this.server.workspaces[id];
	}

	debuggerWithId(id) {
		return this.server.debuggers[id];
	}

	queryAt(option) {
		return this.request.query[option];
	}

	parameterAt(name) {
		return this.request.params[name];
	}

	urlAt(name) {
		return this.request.params[name];
	}

	bodyAt(name) {
		return this.request.body[name];
	}

	requestedSlot() {
		let uri = this.bodyAt("uri");
		if (!uri) return null;
		let index = uri.indexOf("/objects/") + 9;
		let path = uri.substring(index, uri.length);
		return this.objectFromPath(path);
	}

	objectFromPath(path) {
		let segments = path.split("/");
		let id = segments[0];
		let slot = this.server.pinnedObjects[id];
		if (!slot) return null;
		for (let i = 1; i < segments.length; i++) {
			slot = this.slotOf(segments[i], slot);
			if (!slot) return null;
		}
		return slot;
	}

	instanceVariablesOf(object) {
		return object
			.objectClass()
			.allInstVarNames()
			.map((v) => {
				return { name: v };
			});
	}

	namedSlotsOf(object) {
		return object
			.objectClass()
			.allInstVarNames()
			.map((v) => {
				let slot = this.slotOf(v, object);
				let json = slot.asWebsideJson();
				json.slot = v;
				return json;
			});
	}

	indexedSlotsOf(object) {
		if (!object.hasIndexedSlots().asLocalObject()) {
			return this.notFound();
		}
		let from = this.queryAt("from");
		from = from ? parseInt(from) : 1;
		let to = this.queryAt("to");
		to = to ? parseInt(to) : object.size().asLocalObject();
		let slots = [];
		for (let i = from; i <= to; i++) {
			//let slot = object.slotAt_(i).asWebsideJson();
			let slot = this.slotOf(i, object).asWebsideJson();
			slot.slot = i;
			slots.push(slot);
		}
		return slots;
	}

	customPresentationsOf(object) {
		return [];
	}

	slotOf(slot, object) {
		if (parseInt(slot).toString() == slot) {
			let index = parseInt(slot);
			if (object.hasIndexedSlots().asLocalObject()) {
				if (index > object.size().asLocalObject()) return;
				// object.slotAt_(index)
				let element = this.runtime.sendLocal_to_with_(
					"at:",
					object.wrappee(),
					[this.runtime.newInteger_(index)]
				);
				return this.wrap(element);
			}
		}
		let index = object.objectClass().allInstVarNames().indexOf(slot);
		return index != -1 ? object.slotAt_(index + 1) : null;
	}

	requestedIndex() {
		let index = this.urlAt("index");
		return index ? parseInt(index) : null;
	}

	evaluationError(evaluation) {
		let json = {
			description: this.errorDescription(evaluation.error),
			evaluation: id,
		};
		this.error(JSON.stringify(json));
	}

	errorContext(error) {
		let stack = error._process.slotAt_(2);
		return this.runtime._interpreter._stacks.get(stack);
	}

	errorDescription(error) {
		return this.runtime
			.sendLocal_to_("description", error._exception)
			.asLocalString();
	}
}

export default WebsideAPI;
