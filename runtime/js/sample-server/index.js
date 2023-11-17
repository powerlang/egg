import Bootstrapper from '../bootstrapper.js';
import WebsideServer from '../webside/WebsideServer.js';

var bootstrapper = new Bootstrapper();
bootstrapper.loadKernelFile("Kernel.json");
const runtime = bootstrapper.runtime;

const compiler = runtime.addSymbol_("Compiler");
const kernel = bootstrapper.kernel.exports["Kernel"];
const module = runtime.sendLocal_to_with_("load:", kernel, [compiler]);

const namespace = runtime.sendLocal_to_("namespace", module);
const classname = runtime.addSymbol_("SCompiler");

const scompiler = runtime.sendLocal_to_with_("at:", namespace, [classname]);

const object = bootstrapper.kernel.exports["Object"];
const code = runtime.newString_("foo ^'foo'");
const method = runtime.sendLocal_to_with_("compile:in:", scompiler, [code, object]);

runtime.sendLocal_to_("install", method);
const foo = runtime.sendLocal_to_("foo", object);
console.log(foo.asLocalString());

const webside = new WebsideServer("localhost", 9005, runtime);
webside.start();

//const str = runtime.sendLocal_to_("printString", obj);
//console.log("got:", str.toString());
