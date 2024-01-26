import Bootstrapper from '../bootstrapper.js';
import WebsideServer from '../webside/WebsideServer.js';

var bootstrapper = new Bootstrapper();
bootstrapper.loadKernelFile("Kernel.json");
const runtime = bootstrapper.runtime;
const kernel = bootstrapper.kernel.exports["Kernel"];
const modules = ["Compiler", "ImageSegmentBuilder", "STON"];
modules.forEach(name => {
    const symbol = runtime.addSymbol_(name);
    runtime.sendLocal_to_with_("load:", kernel, [symbol])});

const webside = new WebsideServer("localhost", 9005, runtime);
webside.start();