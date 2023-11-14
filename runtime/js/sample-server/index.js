import Bootstrapper from '../bootstrapper.js';
import WebsideServer from '../webside/WebsideServer.js';

var bootstrapper = new Bootstrapper();
bootstrapper.loadKernelFile("image-segments/Kernel.json");
const runtime = bootstrapper.runtime;

const compiler = runtime.addSymbol_("Compiler");
const kernel = bootstrapper.kernel.exports["Kernel"];
const module = runtime.sendLocal_to_with_("load:", kernel, [compiler]);

const webside = new WebsideServer("localhost", 9005, runtime);
webside.start();

//const str = runtime.sendLocal_to_("printString", obj);
//console.log("got:", str.toString());
