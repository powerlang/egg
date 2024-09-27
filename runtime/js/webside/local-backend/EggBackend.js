import Egg from "../../Egg";
import * as logo from "./logo";
import { EggObjectWrapper, EggMethodWrapper } from "../server/EggObjectWrapper";
import { v4 as uuidv4 } from "uuid";

class BackendError extends Error {
	constructor(description, url, request, status, reason, data) {
		const explanation =
			reason && reason.lenght > 0 ? " due to " + reason : "";
		const message = '"' + description + " (" + url + explanation + ')"';
		super(message);
		this.name = "BackendError";
		this.url = url;
		this.request = request;
		this.status = status;
		this.reason = reason;
		this.data = data;
	}
}

class EggBackend {
	constructor(url, author, reportError, reportChange) {
		this.url = url;
		this.reportError = reportError ? reportError.bind() : null;
		this.reportChange = reportChange ? reportChange.bind() : null;
		this.author = author;
		this.useChanges = false;
		this.initializeRuntime();
		this.resources = {
			objects: {},
			evaluations: {},
			workspaces: {},
			debuggers: {},
		};
	}

	// Private...

	initializeRuntime() {
		this.runtime = new Egg();
		runtime.loadKernelFile("Kernel.json");
		const modules = [
			"Compiler",
			"ImageSegmentBuilder",
			"STON",
			"Tonel",
			"CodeSpecs",
		];
		modules.forEach((name) => runtime.loadModule(name));
	}

	kernelModule() {
		return this.runtime.bootstrapper().kernel.exports["Kernel"];
	}

	loadedModules() {
		const dictionary = this.wrap(
			this.runtime.sendLocal_to_("loadedModules", this.kernelModule())
		);
		return this.wrapCollection(dictionary.values());
	}

	moduleNamed(name) {
		const symbol = this.runtime.addSymbol_(name);
		const found = this.wrap(
			this.runtime.sendLocal_to_with_(
				"loadedModuleNamed:",
				this.kernelModule(),
				[symbol]
			)
		);
		if (!found.isNil()) return found;
	}

	findClassNamed(name) {
		if (!name) return null;
		let identifier = name;
		let metaclass = name.endsWith(" class");
		if (metaclass) identifier = identifier.slice(0, -" class".length);
		let root = this.defaultRootClass();
		let species = root
			.withAllSubclasses()
			.detect_((c) => c.name() == identifier);
		if (!species) return null;
		return metaclass ? species.metaclass() : species;
	}

	wrap(object) {
		return EggObjectWrapper.wrap(object, this.runtime);
	}

	wrapWithId(object, id) {
		return EggObjectWrapper.on_runtime_id_(object, this.runtime, id);
	}

	wrapCollection(collection) {
		return EggObjectWrapper.wrapCollection(collection, this.runtime);
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

	classTreeFrom(species, depth, onlyNames) {
		var json;
		if (onlyNames) {
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

	defaultRootClass() {
		const nil = this.runtime.nil();
		let root = this.wrap(nil).objectClass();
		while (!(root.superclass().wrappee() === nil)) root = root.superclass();
		return root;
	}

	handleError(description, uri, error) {
		var status, reason, data;
		if (error.response) {
			status = error.response.status;
			reason = error.response.statusText;
			data = error.response.data;
		} else if (error.request) {
			reason = error.message;
		}
		const exception = new BackendError(
			description,
			this.url + uri,
			error.request,
			status,
			reason,
			data
		);
		throw exception;
	}

	notFound(resource) {
		const exception = new BackendError(
			"Cannot find " + resource,
			"",
			null,
			null,
			null,
			null
		);
		throw exception;
	}

	notImplementedYet(answer) {
		// const exception = new BackendError(
		// 	"Not implemented yet ",
		// 	"",
		// 	null,
		// 	null,
		// 	null,
		// 	null
		// );
		// throw exception;
		return answer;
	}

	implementorsOf(symbol, classname) {
		let species = classname
			? this.findClassNamed(classname)
			: this.defaultRootClass();
		return species
			.withAllSubspecies()
			.filter((c) => c.includesSelector(symbol))
			.map((c) => c.methodFor(symbol));
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

	objectFromPath(id, path) {
		let object = this.resources.objects[id];
		if (!object) return null;
		path.split("/").forEach((s) => {
			object = this.slotOf(s, object);
			if (!object) return null;
		});
		return object;
	}

	newId() {
		return uuidv4().toString();
	}

	errorDescription(error) {
		return this.runtime
			.sendLocal_to_("description", error._exception)
			.asLocalString();
	}

	errorContext(error) {
		let stack = error._process.slotAt_(2);
		return this.runtime._interpreter._stacks.get(stack);
	}

	// General...
	dialect() {
		return "EggJS";
	}

	colors() {
		return { primary: "#81C784", secondary: "#2E7D32" };
	}

	logo() {
		return logo.data;
	}

	saveImage() {}

	systemStats() {
		return [];
	}

	themes() {
		return [];
	}

	// Code...
	packageNames() {
		const modules = this.loadedModules();
		return modules.map((m) => {
			return m.name().asLocalObject();
		});
	}

	packageTree() {
		const modules = this.loadedModules();
		modules.map((c) => c.asWebsideJson());
	}

	packageNamed(packagename) {
		const pack = this.moduleNamed(packagename);
		if (!pack) return this.notFound("package named " + packagename);
		return pack.asWebsideJson();
	}

	packageClasses(packagename, extended = false, category) {
		const pack = this.moduleNamed(packagename);
		if (!pack) return this.notFound("package named " + packagename);
		const defined = this.wrapCollection(pack.classes());
		const extensions = extended
			? this.wrapCollection(pack.extensionClasses())
			: [];
		const all = defined.concat(extensions);
		return this.classTreeFromClasses(all);
	}

	classTree(rootName, depth, onlyNames = false) {
		let root = rootName
			? this.findClassNamed(rootName)
			: this.defaultRootClass();
		if (rootName && !root) this.notFound("class named " + classname);
		return this.classTreeFrom(root, depth, onlyNames);
	}

	classNames() {
		let root = this.defaultRootClass();
		const classes = [root].concat(root.allSubclasses());
		return classes.map((c) => c.name());
	}

	classNamed(classname) {
		const species = this.findClassNamed(classname);
		if (!species) this.notFound("class named " + classname);
		return species.asWebsideJson();
	}

	superclasses(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named" + classname);
		return species.allSuperclasses().map((c) => c.asWebsideJson());
	}

	subclasses(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named" + classname);
		return species.subclasses().map((c) => c.asWebsideJson());
	}

	instanceVariables(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named " + classname);
		return species.withAllSuperclasses().flatMap((c) => {
			c.instVarNames().map((v) => {
				return { name: v, class: c.name(), type: "instance" };
			});
		});
	}

	classVariables(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named " + classname);
		return species.withAllSuperclasses().flatMap((c) =>
			c.classVarNames().map((v) => {
				return { name: v, class: c.name(), type: "class" };
			})
		);
	}

	variables(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named " + classname);
		return species.withAllSuperclasses().flatMap((c) => {
			let instance = c.instVarNames().map((v) => {
				return { name: v, class: c.name(), type: "instance" };
			});
			let meta = c.classVarNames().map((v) => {
				return { name: v, class: c.name(), type: "class" };
			});
			return instance.concat(meta);
		});
	}

	categories(classname) {
		let species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named " + classname);
		return species.categories();
	}

	usedCategories(classname) {
		return this.notImplementedYet([]);
	}

	allCategories() {
		return this.notImplementedYet([]);
	}

	usualCategories(meta = false) {
		return this.notImplementedYet([]);
	}

	selectors(classname, sorted = false) {
		const species = this.findClassNamed(classname);
		if (!species) this.notFound("class named " + classname);
		const selectors = species.methods().map((m) => m.selelector());
		if (sorted) {
			selectors.sort((a, b) => (a <= b ? -1 : 1));
		}
		return selectors;
	}

	methods(classname, sorted = false) {
		const species = this.findClassNamed(classname);
		if (!species) this.notFound("class named " + classname);
		const methods = species.methods().map((m) => m.asWebsideJson());
		if (sorted) {
			methods.sort((a, b) => (a.selector <= b.selector ? -1 : 1));
		}
		return methods;
	}

	accessors(classname, variable, type, sorted = false) {
		//Need to take type into account...
		const species = this.findClassNamed(classname);
		if (!species) this.notFound("class named " + classname);
		let methods = species.methods().filter((m) => {
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
		methods = methods.map((m) => m.asWebsideJson());
		if (sorted) {
			methods.sort((a, b) => (a.selector <= b.selector ? -1 : 1));
		}
		return methods;
	}

	method(classname, selector) {
		const species = this.findClassNamed(classname);
		if (!species) return this.notFound("class named " + classname);
		if (!species.includesSelector(selector))
			return this.notFound(
				"selector " + selector + " in class " + classname
			);
		const method = species.methodFor(selector);
		return method.asWebsideJson();
	}

	methodHistory(classname, selector) {
		return this.notImplementedYet([]);
	}

	autocompletions(classname, source, position) {
		return this.notImplementedYet([]);
	}

	searchClassNames(text) {
		const results = this.search(text, true, "similar", "class");
		return results.map((r) => r.text);
	}

	searchPackageNames(text) {
		const results = this.search(text, true, "similar", "package");
		return results.map((r) => r.text);
	}

	search(text, ignoreCase = false, condition = "beginning", type = "all") {
		return this.notImplementedYet([]);
	}

	selectorInSource(source, position) {
		return this.notImplementedYet([]);
	}

	// Method queries...
	senders(selector) {
		return this.notImplementedYet([]);
	}

	sendersCount(selector) {
		return this.notImplementedYet(0);
	}

	localSenders(selector, classname) {
		return this.notImplementedYet([]);
	}

	classReferences(classname) {
		return this.notImplementedYet([]);
	}

	stringReferences(string) {
		return this.notImplementedYet([]);
	}

	implementors(selector) {
		let methods = this.implementorsOf(selector);
		return methods.map((m) => m.asWebsideJson());
	}

	localImplementors(selector, classname) {
		let methods = this.implementorsOf(selector, classname);
		return methods.map((m) => m.asWebsideJson());
	}

	methodsMatching(pattern) {
		return this.notImplementedYet([]);
	}

	methodTemplate() {
		return {
			template: true,
			selector: "messagePattern",
			source: 'messagePattern\r\t"comment"\r\r\t| temporaries |\r\tstatements',
		};
	}

	classTemplate(pack) {
		return {
			template: true,
			name: "MyClass",
			definition:
				"Object\r\tsubclass: #MyClass\r\tinstanceVariableNames: ''\r\tclassVariableNames: ''\r\tpoolDictionaries: ''",
		};
	}

	methodsInCategory(classname, category, sorted = false) {
		const species = this.findClassNamed(classname);
		if (!species) this.notFound("class named " + classname);
		const methods = methods
			.filter((m) => m.category() == category)
			.map((m) => m.asWebsideJson());
		if (sorted) {
			methods.sort((a, b) => (a.selector <= b.selector ? -1 : 1));
		}
		return methods;
	}

	// Debugging...
	debuggers() {
		return this.resources.debuggers;
	}

	createDebugger(id) {
		let evaluation = this.resources.evaluations[id];
		if (!evaluation) return this.notFound("evaluation with id " + id);
		let _debugger = {
			id: id,
			description: this.errorDescription(evaluation.error),
		};
		this.resources.debuggers[id] = _debugger;
		return _debugger;
	}

	debuggerFrames(id) {
		let _debugger = this.resources.debuggers[id];
		if (!_debugger) return this.notFound("debugger with id " + id);
		let evaluation = this.resources.evaluations[id];
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		return frames.map((frame, index) => {
			let method = EggMethodWrapper.on_runtime_(frame[0], this.runtime);
			let receiver = EggObjectWrapper.on_runtime_(frame[1], this.runtime);
			let label =
				receiver.objectClass().name() + ">>" + method.selector();
			return { index: index, label: label };
		});
	}

	debuggerFrame(id, index) {
		let _debugger = this.resources.debuggers[id];
		if (!_debugger) return this.notFound("debugger with id " + id);
		let evaluation = this.resources.evaluations[id];
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		if (index > frames.length - 1)
			return this.notFound(
				"frame at " + index + " of debugger with id " + id
			);
		let frame = frames[index];
		let method = EggMethodWrapper.on_runtime_(frame[0], this.runtime);
		let receiver = EggObjectWrapper.on_runtime_(frame[1], this.runtime);
		let label = receiver.objectClass().name() + ">>" + method.selector();
		return {
			index: index,
			label: label,
			class: receiver.objectClass().asWebsideJson(),
			method: method.asWebsideJson(),
			interval: [0, 0],
		};
	}

	frameBindings(id, index) {
		let _debugger = this.resources.debuggers[id];
		if (!_debugger) return this.notFound("debugger with id " + id);
		let evaluation = this.resources.evaluations[id];
		let context = this.errorContext(evaluation.error);
		let frames = context.backtrace();
		if (index > frames.length - 1)
			return this.notFound(
				"frame at " + index + " of debugger with id " + id
			);
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
			binding = {
				name: "temporary" + i,
				type: "temporary",
				value: wrapper.printString(),
			};
			bindings.push(binding);
		}
		return bindings;
	}

	stepIntoDebugger(id, index) {
		return this.notImplementedYet(null);
	}

	stepOverDebugger(id, index) {
		return this.notImplementedYet(null);
	}

	stepThroughDebugger(id, index) {
		return this.notImplementedYet(null);
	}

	restartDebugger(id, index, update = false) {
		return this.notImplementedYet(null);
	}

	resumeDebugger(id) {
		return this.notImplementedYet(null);
	}

	terminateDebugger(id) {
		return this.notImplementedYet(null);
	}

	deleteDebugger(id) {
		let _debugger = this.resources.debuggers[id];
		if (_debugger) {
			delete this.resources.debuggers[id];
			delete this.resources.evaluations[id];
			delete this.resources.objects[id];
		}
		return _debugger;
	}

	// Workspaces...
	workspaces() {
		return Object.values(this.resources.workspaces);
	}

	createWorkspace() {
		const id = this.newId();
		const ws = { id: id };
		this.resources.workspaces[id] = ws;
		return ws;
	}

	workspace(id) {
		const ws = this.resources.workspaces[id];
		if (!ws) return this.notFound("workspace with id " + id);
		return ws;
	}

	saveWorkspace(workspace) {
		return this.notImplementedYet(null);
	}

	deleteWorkspace(id) {
		const ws = this.resources.workspaces[id];
		if (!ws) return this.notFound("workspace with id " + id);
		delete this.resources.workspaces[id];
		return ws;
	}

	async workspaceBindings(id) {
		return await this.get(
			"/workspaces/" + id + "/bindings",
			"bindings of workspace " + id
		);
	}

	// Changes...
	usesChanges() {
		return this.useChanges;
	}

	async lastChanges() {
		return await this.get("/changes", "changes");
	}

	newChange(type) {
		return {
			type: type,
			author: this.author,
		};
	}

	async postChange(change, description) {
		const changes = await this.usesChanges();
		if (!changes) {
			const exception = new BackendError(
				"Changes not supported",
				this.url + "/changes",
				null,
				null,
				null,
				null
			);
			throw exception;
		}
		const applied = await this.post("/changes", change, description);
		if (this.reportChange) {
			this.reportChange(applied);
		}
		return applied;
	}

	async downloadChanges(changes) {
		return await this.post(
			"/changesets/download",
			changes,
			"download changes"
		);
	}

	async uploadChangeset(changeset) {
		return await this.post(
			"/changesets/upload",
			changeset,
			"upload changeset"
		);
	}

	async updateChanges(changes) {
		return await this.post("/changes/update", changes, "update changes");
	}

	async compressChanges(changes) {
		return await this.post(
			"/changes/compress",
			changes,
			"compress changes"
		);
	}

	extensions(elementType) {
		return this.notImplementedYet([]);
	}

	// Change helpers...
	createPackage(packagename) {
		const description = "create package " + packagename;
		const change = this.newChange("AddPackage");
		change.name = packagename;
		const changes = this.usesChanges();
		if (!changes) {
			this.post("/packages/", change, description);
			return change;
		}
		return this.postChange(change, description);
	}

	async removePackage(packagename) {
		const change = this.newChange("RemovePackage");
		const description = "remove package " + packagename;
		change.name = packagename;
		const changes = await this.usesChanges();
		if (!changes) {
			await this.delete("/packages/" + packagename, description);
			return change;
		}
		return await this.postChange(change, description);
	}

	async renamePackage(packagename, newName) {
		const change = this.newChange("RenamePackage");
		change.name = packagename;
		change.newName = newName;
		return await this.postChange(change, "rename package " + packagename);
	}

	async defineClass(classname, superclassname, packagename, definition) {
		const description = "define class " + classname;
		const change = this.newChange("AddClass");
		change.className = classname;
		change.superclass = superclassname;
		change.package = packagename;
		change.definition = definition;
		const changes = await this.usesChanges();
		if (!changes) {
			const species = await this.post("/classes/", change, description);
			change.className = species.name;
			change.definition = species.definition;
			return change;
		}
		return await this.postChange(change, description);
	}

	async commentClass(classname, comment) {
		const change = this.newChange("CommentClass");
		change.className = classname;
		change.comment = comment;
		return await this.postChange(change, "comment class " + classname);
	}

	async removeClass(classname) {
		const description = "remove class " + classname;
		const change = this.newChange("RemoveClass");
		change.className = classname;
		const changes = await this.usesChanges();
		if (!changes) {
			await this.delete("/classes/" + classname, description);
			return change;
		}
		return await this.postChange(change, description);
	}

	async renameClass(classname, newName, renameReferences = true) {
		const change = this.newChange("RenameClass");
		change.className = classname;
		change.newName = newName;
		change.renameReferences = renameReferences;
		return await this.postChange(change, "rename class " + classname);
	}

	async addInstanceVariable(classname, variable) {
		const change = this.newChange("AddInstanceVariable");
		change.className = classname;
		change.variable = variable;
		return await this.postChange(
			change,
			"add instance variable " + variable + " to " + classname
		);
	}

	async addClassVariable(classname, variable) {
		const change = this.newChange("AddClassVariable");
		change.className = classname;
		change.variable = variable;
		return await this.postChange(
			change,
			"add class variable " + variable + " to " + classname
		);
	}

	async renameInstanceVariable(classname, variable, newName) {
		const change = this.newChange("RenameInstanceVariable");
		change.className = classname;
		change.variable = variable;
		change.newName = newName;
		return await this.postChange(
			change,
			"rename instance variable " +
				variable +
				" to " +
				newName +
				" of class " +
				classname
		);
	}

	async renameClassVariable(classname, variable, newName) {
		const change = this.newChange("RenameClassVariable");
		change.className = classname;
		change.variable = variable;
		change.newName = newName;
		return await this.postChange(
			change,
			"rename class variable " +
				variable +
				" to " +
				newName +
				" of class " +
				classname
		);
	}

	async removeInstanceVariable(classname, variable) {
		const change = this.newChange("RemoveInstanceVariable");
		change.className = classname;
		change.variable = variable;
		return await this.postChange(
			change,
			"remove instance variable " + variable + " from class " + classname
		);
	}

	async removeClassVariable(classname, variable) {
		const change = this.newChange("RemoveClassVariable");
		change.className = classname;
		change.variable = variable;
		return await this.postChange(
			change,
			"remove class variable " + variable + " from class " + classname
		);
	}

	async moveInstanceVariableUp(classname, variable) {
		const change = this.newChange("MoveUpInstanceVariable");
		change.className = classname;
		change.variable = variable;
		return await this.postChange(
			change,
			"move up variable " + variable + " from class " + classname
		);
	}

	async moveInstanceVariableDown(classname, variable, target) {
		const change = this.newChange("MoveDownInstanceVariable");
		change.className = classname;
		change.variable = variable;
		change.target = target;
		return await this.postChange(
			change,
			"move down variable " + variable + " from class " + classname
		);
	}

	async renameCategory(classname, category, newName) {
		const change = this.newChange("RenameCategory");
		change.className = classname;
		change.category = category;
		change.newName = newName;
		return await this.postChange(
			change,
			"rename category " +
				category +
				" to " +
				newName +
				" of class " +
				classname
		);
	}

	async removeCategory(classname, category) {
		const change = this.newChange("RemoveCategory");
		change.className = classname;
		change.category = category;
		return await this.postChange(
			change,
			"remove category " + category + " from class " + classname
		);
	}

	async compileMethod(classname, packagename, category, source) {
		const description = "compile " + source + " in " + classname;
		const change = this.newChange("AddMethod");
		change.className = classname;
		change.package = packagename;
		change.category = category;
		change.sourceCode = source;
		const changes = await this.usesChanges();
		if (!changes) {
			const method = await this.post(
				"/classes/" + classname + "/methods",
				change,
				description
			);
			change.selector = method.selector;
			change.sourceCode = method.source;
			return change;
		}
		return await this.postChange(change, description);
	}

	async removeMethod(classname, selector) {
		const description = "remove methodd " + classname + ">>#" + selector;
		const change = this.newChange("RemoveMethod");
		change.className = classname;
		change.selector = selector;
		const changes = await this.usesChanges();
		if (!changes) {
			await this.delete(
				"/classes/" + classname + "/methods/" + selector,
				description
			);
			return change;
		}
		return await this.postChange(change, description);
	}

	async classifyMethod(classname, selector, category) {
		const change = this.newChange("ClassifyMethod");
		change.className = classname;
		change.selector = selector;
		change.category = category;
		return await this.postChange(
			change,
			"classify methodd " +
				classname +
				">>#" +
				selector +
				" under " +
				category
		);
	}

	async renameSelector(classname, selector, newSelector) {
		const change = this.newChange("RenameMethod");
		change.className = classname;
		change.selector = selector;
		change.newSelector = newSelector;
		return await this.postChange(
			change,
			"rename selector " + selector + " to " + newSelector
		);
	}

	async addClassCategory(packagename, category) {
		const change = this.newChange("AddClassCategory");
		change.package = packagename;
		change.category = category;
		return await this.postChange(
			change,
			"add class category " + category + " to package " + packagename
		);
	}

	async renameClassCategory(packagename, category, newName) {
		const change = this.newChange("RenameClassCategory");
		change.package = packagename;
		change.category = category;
		change.newName = newName;
		return await this.postChange(
			change,
			"rename class category " +
				category +
				" to " +
				newName +
				" of package " +
				packagename
		);
	}

	async removeClassCategory(packagename, category) {
		const change = this.newChange("RemoveClassCategory");
		change.package = packagename;
		change.category = category;
		return await this.postChange(
			change,
			"remove class category " + category + " from package " + packagename
		);
	}

	// Evaluations...
	evaluateExpression(
		expression,
		sync = false,
		pin = false,
		context,
		assignee
	) {
		let id = this.newId();
		let object;
		let source = "doIt ^(" + expression + ")";
		let evaluation = {
			id: id,
			expression: expression,
			state: "pending",
		};
		this.resources.evaluations[id] = evaluation;
		try {
			this.compile(source, "Object");
			object = this.runtime.sendLocal_to_("doIt", this.runtime.nil());
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
				return {
					description: this.errorDescription(evaluation.error),
					evaluation: id,
				};
			delete this.resources.evaluations[id];
			let json = object.asWebsideJson();
			if (pin) {
				this.resources.objects[id] = object;
				json.id = id;
			}
			return json;
		}
		if (evaluation.state === "finished")
			this.resources.objects[id] = object;
		let json = { id: id, state: evaluation.state };
		if (evaluation.error)
			json.error = {
				description: this.errorDescription(evaluation.error),
			};
		return json;
	}

	pauseEvaluation(id) {
		return this.notImplementedYet(null);
	}

	cancelEvaluation(id) {
		return this.notImplementedYet(null);
	}

	evaluation(id) {
		let evaluation = this.resources.evaluations[id];
		if (evaluation) {
			let json = {
				id: id,
				state: evaluation.state,
			};
			if (evaluation.error)
				json.error = {
					description: this.errorDescription(evaluation.error),
				};
			return json;
		}
		let object = this.resources.objects[id];
		if (!object) return this.notFound("object with id " + id);
		return { id: id, state: "finished" };
	}

	evaluations() {
		return Object.values(this.resources.evaluations).map((e) => {
			let json = {
				id: e.id,
				state: e.state,
			};
			if (e.error)
				json.error = {
					description: this.errorDescription(e.error),
				};
			return json;
		});
	}

	debugExpression(expression, context) {
		return this.notImplementedYet(null);
	}

	profileExpression(expression, context) {
		return this.notImplementedYet(null);
	}

	// Objects...
	objects() {
		return Object.entries(this.resources.objects).map((e) => {
			let json = e[1].asWebsideJson();
			json.id = e[0];
			return json;
		});
	}

	objectWithId(id) {
		let object = this.resources.objects[id];
		if (!object) return this.notFound("object with id " + id);
		let json = object.asWebsideJson();
		json.id = id;
		return json;
	}

	unpinObject(id) {
		if (!this.resources.objects[id])
			return this.notFound("object with id " + id);
		delete this.resources.objects[id];
		return id;
	}

	unpinAllObjects() {
		this.resources.objects = [];
	}

	objectNamedSlots(id, path) {
		let object = this.objectFromPath(id, path);
		if (!object) return this.notFound("object at path " + id + path);
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

	objectIndexedSlots(id, path) {
		let object = this.objectFromPath(id, path);
		if (!object) return this.notFound("object at path " + id + path);
		if (!object.hasIndexedSlots().asLocalObject())
			return this.notFound("indexed slots of object with id " + id);
		let slots = [];
		for (let i = 1; i <= object.size().asLocalObject(); i++) {
			let slot = this.slotOf(i, object).asWebsideJson();
			slot.slot = i;
			slots.push(slot);
		}
		return slots;
	}

	objectInstanceVariables(id, path) {
		let object = this.objectFromPath(id, path);
		if (!object) return this.notFound("object at path " + id + path);
		return object
			.objectClass()
			.allInstVarNames()
			.map((v) => {
				return { name: v };
			});
	}

	objectViews(id, path) {
		return this.notImplementedYet([]);
	}

	objectSlot(id, path) {
		let object = this.objectFromPath(id, path);
		if (!object) return this.notFound("object at path " + id + path);
		return object.asWebsideJson();
	}

	pinObjectSlot(id, path) {
		let object = this.objectFromPath(id, path);
		if (!object) return this.notFound("object at path " + id + path);
		// Replace with UUID or the like...
		let id = this.newId();
		this.resources.objects[id] = object;
		let json = object.asWebsideJson();
		json.id = id;
		return json;
	}

	// Tests...
	async testRuns() {
		return await this.get("/test-runs", "test runs");
	}

	async runTestSuite(suite) {
		return await this.post("/test-runs", suite, "run test suite");
	}

	async runTest(classname, selector) {
		const suite = {
			methods: [{ class: classname, selector: selector }],
		};
		return await this.runTestSuite(suite);
	}

	async runTestClass(classname) {
		const suite = {
			classes: [classname],
		};
		return await this.runTestSuite(suite);
	}

	async runTestPackage(packagename) {
		const suite = {
			packages: [packagename],
		};
		return await this.runTestSuite(suite);
	}

	async testRunStatus(id) {
		return await this.get(
			"/test-runs/" + id + "/status",
			"status of test run " + id
		);
	}

	async testRunResults(id) {
		return await this.get(
			"/test-runs/" + id + "/results",
			"results of test run " + id
		);
	}

	async runTestRun(id) {
		return await this.post(
			"/test-runs/" + id + "/run",
			null,
			"run test run " + id
		);
	}

	async stopTestRun(id) {
		return await this.post(
			"/test-runs/" + id + "/stop",
			null,
			"stop test run " + id
		);
	}

	async deleteTestRun(id) {
		return await this.delete("/test-runs/" + id, "test run " + id);
	}

	async debugTest(id, classname, selector) {
		const test = {
			class: classname,
			selector: selector,
		};
		return await this.post(
			"/test-runs/" + id + "/debug",
			test,
			"debug test " + selector + " in " + classname
		);
	}

	// Profiling...
	profilerTreeResults(id) {
		return this.notImplementedYet(null);
	}

	profilerRankingResults(id) {
		return this.notImplementedYet(null);
	}

	deleteProfiler(id) {
		return this.notImplementedYet(null);
	}
}

export default EggBackend;
