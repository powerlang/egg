import Loader from '../Loader.js';
import WebsideServer from '../webside/WebsideServer.js';

var loader = new Loader();
loader.loadKernelFile("Kernel.json");
const runtime = loader.runtime;
const kernel = loader.kernel.exports["Kernel"];
const modules = ["Compiler", "ImageSegmentBuilder", "STON", "Tonel", "CodeSpecs"];
modules.forEach(name => {
    const symbol = runtime.addSymbol_(name);
    runtime.sendLocal_to_with_("load:", kernel, [symbol])});

const webside = new WebsideServer("localhost", 9005, runtime);
webside.start();