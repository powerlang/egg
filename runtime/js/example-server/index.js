import Egg from '../Egg.js';
import WebsideServer from '../webside/WebsideServer.js';

var egg = new Egg();
egg.loadKernelFile("Kernel.json");
const modules = ["Compiler", "ImageSegmentBuilder", "STON", "Tonel", "CodeSpecs"];
modules.forEach(name => egg.loadModule(name));

const webside = new WebsideServer("localhost", 9005, egg.runtime);
webside.start();