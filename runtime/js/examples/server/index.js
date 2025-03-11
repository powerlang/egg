import Egg from "@powerlang/egg-js";
import WebsideServer from "@powerlang/egg-js-webside";

var egg = new Egg();
egg.loadKernelFile("Kernel.json");
const modules = [
	"Compiler",
	"ImageSegmentBuilder",
	"STON",
	"Tonel",
	"CodeSpecs",
	"ModuleImporter",
	"PetitParser",
	"PetitParser.Parsers",
	"PetitParser.Extensions",
	"PetitParser.Tools",
];
modules.forEach((name) => egg.loadModule(name));

const webside = new WebsideServer("localhost", 9005, egg.runtime);
webside.start();
