import LMRObjectWrapper from "./LMRObjectWrapper.js";

let LMRModuleWrapper = class extends LMRObjectWrapper {
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

LMRObjectWrapper.setLMRModuleWrapper(LMRModuleWrapper);

export default LMRModuleWrapper;
