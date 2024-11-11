import { performance } from "perf_hooks"; // nodejs built-in for measuring time
import Egg from '../../Egg.js';


var egg = new Egg();
egg.loadKernelFile("Kernel.json");

let n1 = 1, t1;
do {
    let startTime = performance.now();
    egg.send(egg.runtime.newInteger_(n1), "benchSieve");
    let endTime = performance.now();
    t1 = endTime - startTime;
    if (t1 >= 1000) break;
    n1 = n1 * 2;
} while (true)

let n2 = 28, t2, r;
do {
    let startTime = performance.now();
    r = egg.send(egg.runtime.newInteger_(n2), "benchFibonacci").value();
    let endTime = performance.now();
    t2 = endTime - startTime;
    if (t2 >= 1000) break;
    n2 = n2 + 1;
} while (true)

console.log(`${(n1 * 500000.0 * 1000 / t1).toFixed()} bytecodes/sec; ${(r * 1000.0 / t2).toFixed()} sends/sec`)
    
