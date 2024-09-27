import express from "express";
import cors from "cors";
import WebsideAPI from "./WebsideAPI.js";
import { v4 as uuidv4 } from "uuid";

class WebsideServer extends Object {
	constructor(host, port, runtime) {
		super();
		this.runtime = runtime;
		this.host = host;
		this.port = port;
		this.server = express();
		this.server.use(cors());
		this.server.use(express.json());
		this.initializeEndpoints();
		this.pinnedObjects = {};
		this.evaluations = {};
		this.debuggers = {};
		this.workspaces = {};

		let api = new WebsideAPI(this);
		api.pinSampleObjects();
	}

	start() {
		this.server.listen(this.port, this.host, () => {
			console.log(
				`WebsideServer is running on http://${this.host}:${this.port}`
			);
		});
	}

	api(request, response) {
		return new WebsideAPI(this, request, response);
	}

	initializeEndpoints() {
		this.server.get("/dialect", (request, response) => {
			this.api(request, response).dialect();
		});

		this.server.get("/logo", (request, response) => {
			this.api(request, response).logo();
		});

		this.server.get("/colors", (request, response) => {
			this.api(request, response).colors();
		});

		//Code endpoints..."
		this.server.get("/packages", (request, response) => {
			this.api(request, response).packages();
		});

		this.server.get("/packages/:packagename", (request, response) => {
			this.api(request, response).package();
		});

		this.server.get(
			"/packages/:packagename/classes",
			(request, response) => {
				this.api(request, response).packageClasses();
			}
		);

		this.server.get("/classes", (request, response) => {
			this.api(request, response).classes();
		});

		this.server.get("/classes/:classname", (request, response) => {
			this.api(request, response).classDefinition();
		});

		this.server.get(
			"/classes/:classname/variables",
			(request, response) => {
				this.api(request, response).variables();
			}
		);

		this.server.get(
			"/classes/:classname/subclasses",
			(request, response) => {
				this.api(request, response).subclasses();
			}
		);

		this.server.get(
			"/classes/:classname/categories",
			(request, response) => {
				this.api(request, response).categories();
			}
		);

		this.server.get(
			"/classes/:classname/used-categories",
			(request, response) => {
				this.api(request, response).usedCategories();
			}
		);

		this.server.get("/classes/:classname/methods", (request, response) => {
			this.api(request, response).methods();
		});

		this.server.get(
			"/classes/:classname/methods/:selector",
			(request, response) => {
				this.api(request, response).method();
			}
		);

		this.server.get("/methods", (request, response) => {
			this.api(request, response).methods();
		});

		this.server.get("/usual-categories", (request, response) => {
			this.api(request, response).usualCategories();
		});

		//Objects endpoints..."
		this.server.get("/objects", (request, response) => {
			this.api(request, response).pinnedObjects();
		});

		this.server.get("/objects/:id/*", (request, response) => {
			this.api(request, response).pinnedObjectSlots();
		});

		this.server.get("/objects/:id", (request, response) => {
			this.api(request, response).pinnedObject();
		});

		this.server.delete("/objects/:id", (request, response) => {
			this.api(request, response).unpinObject();
		});

		this.server.post("/objects", (request, response) => {
			this.api(request, response).pinObjectSlot();
		});

		//Evaluation endpoints..."
		this.server.get("/evaluations", (request, response) => {
			this.api(request, response).evaluations();
		});

		this.server.get("/evaluations/:id", (request, response) => {
			this.api(request, response).evaluation();
		});

		this.server.post("/evaluations", (request, response) => {
			this.api(request, response).evaluateExpression();
		});

		//Debugging endpoints..."
		this.server.post("/debuggers", (request, response) => {
			this.api(request, response).createDebugger();
		});

		this.server.get("/debuggers/:id/frames", (request, response) => {
			this.api(request, response).debuggerFrames();
		});

		this.server.get("/debuggers/:id/frames/:index", (request, response) => {
			this.api(request, response).debuggerFrame();
		});

		this.server.get(
			"/debuggers/:id/frames/:index/bindings",
			(request, response) => {
				this.api(request, response).frameBindings();
			}
		);

		this.server.delete("/debuggers/:id", (request, response) => {
			this.api(request, response).deleteDebugger();
		});

		//Changes endpoints...
		this.server.post("/changes", (request, response) => {
			this.api(request, response).addChange();
		});

		//Extensions endpoints...
		this.server.get("/extensions", (request, response) => {
			this.api(request, response).extensions();
		});
	}

	newId() {
		return uuidv4();
	}
}

export default WebsideServer;
