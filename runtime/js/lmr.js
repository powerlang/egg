
// here we define a few base objects/classes/methods that we are going to add to the js environment
// for our smalltalk VM.

// The code of VM itself is transpiled to native JS, so VM's true is JS true, VM numbers are JS numbers.
// On the other hand, the Smalltalk image to be loaded has a true object that is a JS object (diferent from
// true), same for false, etc. 



// Support for transpiling Smalltalk cascades in VM code:
// JS doesn't support Smalltalk cascades directly. Our transliterator uses this _cascade function
// instead, generating code for evaluating the receiver with a closure that executes all the messages
// with that receiver. 
globalThis._cascade = function(receiver, cascadeStatements) { return cascadeStatements(receiver);}


// Support for nil in VM code:
// Unfortunately it is not possible to extend JS null with methods, so we define an object for nil
// and try to avoid using null anywhere

globalThis.nil = {}

Object.prototype.ifNil_ = function(closure) { if (this == nil) { return closure() } else { return this } }

Object.prototype.ifNotNil_ = function(closure) { if (this == nil) { return nil } else {return closure(this)} }
Object.prototype.ifNil_ifNotNil_ = function(closureNil, closureNotNil) {
	if (this == nil) { return closureNil() } else {return closureNotNil(this) } }


Object.prototype.isNil = function() { return (this === nil) }
Object.prototype.notNil = function() { return (!this.isNil()) }

//Object.prototype.value = function () { return this; }

Object.prototype.eval_ = function(string) {
	 return eval(string) }

Object.prototype.isSmallInteger = function(value) { return Number.isInteger(value); }

Object.prototype.isCollection = function() { return false; }
Array.prototype.isCollection  = function() { return true; }
Map.prototype.isCollection    = function() { return true; }

Object.prototype.isBlock    = function() { return false; }
Function.prototype.isBlock  = function() { return true; }

Object.prototype.initialize = function() { return this;}
Object.prototype.basicNew = function() { return new this; }
Object.prototype.new = function() { const obj = new this; obj.initialize(); return obj; }
Object.prototype.class = function() { return this.constructor; }
Object.prototype.asString = function() { return this.toString(); }

// add some Smalltalk-ish methods to JS booleans

Boolean.prototype.ifTrue_  = function(closure) { if (this == true) { return closure() } else {return nil } }
Boolean.prototype.ifFalse_ = function(closure) { if (this == true) { return nil } else { return closure() } }
Boolean.prototype.ifTrue_ifFalse_ = function(closureTrue, closureFalse) { if (this == true) { return closureTrue() } else {return closureFalse() } }

Boolean.prototype.or_  = function (closure) { return this || closure() }
Boolean.prototype.orNot_  = function (closure) { return this || !closure() }
Boolean.prototype.and_ = function (closure) { return this && closure() }
Boolean.prototype.andNot_ = function (closure) { return this && !closure() }
Boolean.prototype.not = function () { return !this }

Array.new_ = function(size) { return new Array(size); }
Array.new_withAll_ = function(size, value) { return Array(size).fill(value); }
Array.with_with_ = function(first, second) { return [first, second]; }
Array.prototype.size  = function()         { return this.length; }
Array.prototype.isEmpty  = function()         { return this.length == 0; }
Array.prototype.asArray  = function()         { return this; }
Array.prototype.at_    = function(index)         { return this[index-1]; }
Array.prototype.at_put_ = function(index, object) { return this[index-1] = object; }
Array.prototype.atAllPut_ = function(value) { return this.fill(value); }
Array.prototype.allButLast = function() { return this.slice(0,-1); }
Array.prototype.first    = function()         { return this[0]; }
Array.prototype.second   = function()         { return this[1]; }
Array.prototype.last     = function()         { return this[this.length-1]; }
Array.prototype.asString = function() { return String.fromCharCode.apply(null, this); }
Array.prototype.replaceFrom_to_with_startingAt_ = function(start, end, other, first) { 
	const size = end - start + 1;
	this.splice(start - 1, size, ...other.slice(first - 1, first - 1 + size));
	return this;
}

Array.prototype.do_ = function(closure) {
	this.forEach(closure);
}
Array.prototype.withIndexDo_ = function(closure) {
	this.forEach((element, index) => {closure(element, index + 1)} );
}
Array.prototype.do_separatedBy_ = function(closure, separated) {
	this.forEach((value, index) => { 
		closure(value); 
		if (!Object.is(this.length - 1, index)) {separated()}
	});
}

Array.prototype.detect_ = function(block) { return this.find(block); }


String.prototype.asSymbol = function() { return this; }
String.prototype.asString = function() { return this; }
String.prototype._comma = function(string) { return this.concat(string); }

Array.prototype.add_ = function(object) { return this.push(object); }
Array.prototype._comma = function(array) { return this.concat(array); }
Array.prototype.copyWith_ = function(object) { return this.concat([object]); }
Array.prototype._equal = function(value) { 
	return Array.isArray(value) &&
        this.length === value.length &&
        this.every((val, index) => val === value[index]);
}

Array.prototype.asLittleEndianPositiveInteger = function() {
	let bigInteger = 0n;
	for (let i = 0; i < this.length; i++) {
		bigInteger += BigInt(this[i]) << BigInt(8 * i);
	}
	return bigInteger;
}

Array.prototype.asLittleEndianNegativeInteger = function() {
	return this.asLittleEndianPositiveInteger() - (BigInt(1) << BigInt(64));
}

String.prototype.asByteArray = function() { return Array.from(this).map((char) => char.charCodeAt(0)); }
String.prototype.beginsWith_ = function(string) { return this.startsWith(string); }

Map.withAll_ = function(associations) {
	const result = new this;
	associations.forEach((assoc) => result.set(assoc.key(), assoc.value()));
	return result;
}

Map.prototype.at_          = function(key)         { return this.get(key); }
Map.prototype.at_put_       = function(key, value) { return this.set(key, value); }
Map.prototype.at_ifPresent_ = function(key, closure) {
	if (this.has(key))
		return closure(this.get(key));
	else
		return nil;
}

Map.prototype.at_ifAbsentPut_ = function(key, closure) {
	let v = this.get(key);
	if (v)
		return v;
	else 
		v = closure();
		this.set(key, v);
	return v;
}

Map.prototype.removeKey_ifAbsent_ = function(key, closure) {
	if (!this.delete(key)) { closure();}
}

Map.prototype.keysAndValuesDo_ = function(closure) {
	this.forEach((value, key) => closure(key, value));
}

// ~~~~~~~~~~~~~~~~~~~~ Block Closures ~~~~~~~~~~~~~~~~~~~~~~~~

Function.prototype.value = function () {
	return this();
}

Function.prototype.value_ = function (a) {
	return this(a);
}

Function.prototype.value_value_ = function (a, b) {
	return this(a, b);
}

Function.prototype.value_value_value_ = function (a, b, c) {
	return this(a, b, c);
}

// loop helpers
Function.prototype.whileTrue = function () {
	while(this()) { }
	return nil;
}

Function.prototype.whileFalse = function () {
	while(!this()) { }
	return nil;
}

Function.prototype.whileTrue_ = function (block) {
	while(this()) { block() }
	return nil;
}

Function.prototype.whileFalse_ = function (block) {
	while(!this()) { block() }
	return nil;
}

Object.prototype._arrow = function(value) {
	const t = this;
	return {
		key: function() {return t; },
		value: function() {return value; },
		key_: function(k) {this.key = function() { return k; }; return this;},
		value_: function(v) {this.value = function() { return v; }; return this;}
	};
}

Object.prototype._equal = function(value) { return this ==  value; }
Object.prototype._notEqual = function(value) { return this !=  value; }
Object.prototype._equalEqual = function(value) { return this ===  value; }
Object.prototype._notEqualEqual = function(value) { return this !==  value; }

// add some Smalltalk-ish methods to JS numbers
Number.prototype._lessEqualThan = function(value) { return this <=  value; }
Number.prototype._lessThan = function(value) { return this <  value; }
Number.prototype._greaterEqualThan = function(value) { return this >=  value; }
Number.prototype._greaterThan = function(value) { return this >  value; }

Number.prototype.byteAt_ = function(index) {
	const shift = (index - 1) << 3;
	return (this >> shift) & 0xFF;
}

Number.prototype._plus = function(value) { return this + value; }
Number.prototype._minus = function(value) { return this - value; }
Number.prototype._times = function(value) { return this * value; }
Number.prototype._slash = function(value) { return this / value; }
Number.prototype._modulo = function(value) { return this % value; }
Number.prototype._integerQuotient = function(value) { return Math.floor(this / value); }
Number.prototype._and = function(value) { return this.bitAnd_(value); }
Number.prototype._or = function(value) { return this.bitOr_(value); }
Number.prototype.bitAnd_ = function(value) { return Number(BigInt(this) & BigInt(value)); }
Number.prototype.bitOr_ = function(value) { return Number(BigInt(this) | BigInt(value)); }
Number.prototype.bitXor_ = function(value) { return Number(BigInt(this) ^ BigInt(value)); }
Number.prototype.bitShift_ = function(value) {
	return value > 0 ?
		Number(BigInt(this) << BigInt(value)) :
		Number(BigInt(this) >> BigInt(-value)); }
Number.prototype._shiftLeft = function(value) { return Number(BigInt(this) << BigInt(value)); }
Number.prototype._shiftRight = function(value) { return Number(BigInt(this) >> BigInt(value)); }
Number.prototype.anyMask_ = function(value) { return (this.bitAnd_(value)) != 0; }
Number.prototype.noMask_ = function(value) { return (this.bitAnd_(value)) == 0; }

Number.prototype.timesRepeat_ = function(closure) { for (let i = 0; i < this; i++) { closure(); } }
Number.prototype.to_do_ = function(limit, closure) { for (let i = this; i <= limit; i++) { closure(i); } }
Number.prototype.to_by_do_ = function(limit, increment, closure) { 
	if (increment > 0) 
		for (let i = this; i <= limit; i=i+increment) { closure(i); }
	else
		for (let i = this; i >= limit; i=i+increment) { closure(i); }
}

import LMRByteObject from "./interpreter/LMRByteObject.js";
import LMRSlotObject from "./interpreter/LMRSlotObject.js";
import LMRHeapObject from "./interpreter/LMRHeapObject.js";
import LMRSmallInteger from "./interpreter/LMRSmallInteger.js";

LMRSlotObject.prototype.pointersSize = function() { return this.size(); }
LMRSlotObject.prototype.size = function() { return this._slots.length; }
LMRByteObject.prototype.size = function() { return this._bytes.length; }


// ~~~~~~~~~~~~~~~~~~~~ Stretch ~~~~~~~~~~~~~~~~~~~~~~~~

let Stretch = class {
	constructor(start, end) {this.start = start; this.end = end;};

	length() { return this.end - this.start + 1;}
}

Number.prototype.thru = function(value) { return new Stretch(this, value); }
Number.prototype.bitsAt_ = function(stretch) {
	let shifted = this >> (stretch.start - 1);
	let mask = 1 << stretch.length();
	return shifted & (mask - 1)
}

Number.prototype.bitsAt_put_ = function(stretch, value) {
	let shifted = this >> (stretch.start - 1);
	let max = 1 << stretch.length();
	if (value >= max)
		{ throw 'invalid argument'; };
	return this.bitsClear_(stretch) | shifted;
}

Number.prototype.bitsClear_ = function(stretch, value) {
	let mask = (1 << stretch.end) - (1 << (stretch.start - 1));
	return this & (mask ^ -1)
}

// ~~~~~~~~~~~~~~~~~~~~ Interval ~~~~~~~~~~~~~~~~~~~~~~~~

let Interval = class {
	constructor(start, end, step = 1) {this.start = start; this.end = end; this.step = 1};

	at_(anInteger) {
		if (anInteger > 0) {
			const result = this.start + (anInteger - 1 * this.step);
			const min = Math.min(this.start, this.end);
			const max = Math.max(this.start, this.end);
			if (min <= result && result <= max) return result;
			if (anInteger == this.size() ) return this.end;
		}
		
		throw "outOfBoundsIndex";
	}

	do_(closure) {
		if (this.step > 0) {
			for (let i = this.start; i <= this.end; i=i+this.step) { closure(i) }
		} else {
			for (let i = this.start; i >= this.end; i=i+this.step) { closure(i) }
		}	
	}

	collect_(closure) {
		const result = [];
		const s = this.size();
		for (let i = 1; i <= s; i++)
		{
			result.push(closure(this.at_(i)));
		}
		return result;
	}

	size() {
		let _size = Math.max(0, Math.floor((this.end - this.start) / this.step) + 1);
		const x = this.step * _size + this.start;
		if ((this.step < 0 && this.end <= x) || (this.step > 0 && x <= this.end))
			_size = _size + 1;
		return _size;
	}
}

Number.prototype.to_ = function(value) { return new Interval(this, value); }
Number.prototype.to_by_ = function(limit, increment) { return new Interval(this, limit, increment); }

// ~~~~~~~~~~~~~~~~~~~~ ReadStream ~~~~~~~~~~~~~~~~~~~~~~~~

let ReadStream = class {
	constructor(contents) { this.contents = contents; this.position = 0; }

	next() {
		if (this.atEnd())
			throw "reached the end of the stream"; 
		
		return this.contents[this.position++];
	}

	next_(n) {
		if (this.position + n > this.contents.length)
			throw "reached the end of the stream"; 
		
		const start = this.position;
		this.position =  this.position+n;
		return this.contents.slice(start,  this.position);
	}

	peek() {
		if (this.atEnd())
			return nil;
		
		return this.contents[ this.position];
	}

	int64() {
		// integers are stored as big endian
		const start =  this.position;
		this.position = this.position + 8;
		return this.contents[start+7] +
		(this.contents[start+6] << 8) +
		(this.contents[start+5] << 16) +
		(this.contents[start+4] << 24) +
		(this.contents[start+3] << 32) +
		(this.contents[start+2] << 40) +
		(this.contents[start+1] << 48) +
		(this.contents[start+0] << 56);
	}

	atEnd() {
		return this.position >= this.contents.length;
	}
}

Array.prototype.readStream = function() { return new ReadStream(this); }

// ~~~~~~~~~~~~~~~~~~~~ WriteStream ~~~~~~~~~~~~~~~~~~~~~~~~

let WriteStream = class {
	constructor() { this.collection = ""; }
	nextPut_(character) {this.collection = this.collection + character; return this;}
	nextPutAll_(string) {this.collection = this.collection + string; return this;}
	space() {return this.nextPutAll_(" ");}
	cr() {return this.nextPutAll_("\n");}
	crtab() {return this.nextPutAll_("\n\t");}
	crtab_(n) {
		this.nextPutAll_("\n" + "\t".repeat(n));
	}
	tab() {return this.nextPutAll_("\t");}

	store_(anObject) { this.nextPutAll_(JSON.stringify(anObject)); return this; }
	
	contents() { return this.collection;}
	reset() { this.collection = ""; return this;}
	print_(object) {return this.nextPutAll_(object.toString());}
}

String.prototype.writeStream = function() { return new WriteStream(); }
String.__proto__.streamContents_ = function(block) { let w = new WriteStream(); block(w); return w.contents(); }



// ~~~~~~~~~~~~~~ extra for debugging ~~~~~~~~~~~~~~~~~

Object.prototype.ASSERT_ = function (bool) { if (!bool) debugger; }
Object.prototype.halt = function () { debugger; }

LMRSmallInteger.prototype.toString = function () { return "<" + this._value + ">"; }
LMRHeapObject.prototype.toString = function () { return "a " + this.classname(); }
LMRSlotObject.prototype.toString = function () { 
	if (this === nil)
		return "nil";

	const classname = this.classname();

	if (classname == "CompiledMethod") {
		let klass = this.slotAt_(4);
		if (!klass) klass = nil;
		let selector = this.slotAt_(5);
		if (!selector) selector = nil;
	
		return klass.toString() + ">>" + selector.toString();
	}

	if (classname == "Behavior")
	{
		let klass = this.slotAt_(1);
		return klass.toString() + ' behavior';
	}
		


	const species = this.species();
	if (!species.speciesIsClass()) // species is metaclass, then this is a class
		return this.className().asLocalString();

	if (classname=="Metaclass") // species is class,then this is a metaclass
		return this.speciesClassname();

	return "a " + this.classname();;
}

LMRByteObject.prototype.toString = function () { 

	const classname = this.classname();

	if (classname == "Symbol")
		return "#" + this.asLocalString();
	
	if (classname == "String")
		return '"' + this.asLocalString() + '"';
	
	return "a " + this.classname();;
}

LMRHeapObject.prototype.species = function () { return this._header._behavior._slots[0]; }
LMRHeapObject.prototype.speciesIsClass = function () { return this._slots[5].constructor == LMRByteObject; }
LMRHeapObject.prototype.speciesInstanceClass = function () { 
	return this.speciesIsClass() ? this : this._slots[5];
}
LMRHeapObject.prototype.className = function () { return this._slots[5]; }

LMRHeapObject.prototype.classname = function () { return this.species().speciesClassname() }
LMRHeapObject.prototype.speciesClassname = function () { 
	if (this.speciesIsClass())
		return this.className().asLocalString();
	else 
		return this.speciesInstanceClass().className().asLocalString() + " class";
}

