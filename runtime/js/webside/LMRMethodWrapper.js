import LMRObjectWrapper from "./LMRObjectWrapper.js";

let LMRMethodWrapper = class extends LMRObjectWrapper {
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
		};
		if (s) return s.wrappee().asLocalString();
		"This means the wrappee is a block"
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

export default LMRMethodWrapper;
