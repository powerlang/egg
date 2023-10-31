
import LMRObjectHeader from './interpreter/LMRObjectHeader.js';
import LMRSlotObject from './interpreter/LMRSlotObject.js';
import LMRByteObject from './interpreter/LMRByteObject.js';
import LMRSmallInteger from './interpreter/LMRSmallInteger.js';

import { readFileSync } from 'fs';

export const ObjectTypes = Object.freeze({
	SlotObject: 1,
	ByteObject: 2,
	SmallIntegerObject: 3,
	Import: 4
})

/**
 * @param {*} environment is a dictionary mapping names to objects, that is used for module imports
 *
 * A ModuleReader is an object that creates a Powertalk module by reading it from a JSON file.
 * The format of the module is pretty simple: it has an object table, and an export map.
 * Objects in the table can be of four types: SmallInteger, ByteObject, SlotObject and Import
 *  - Import objects have a name, which is used to find the corresponding object passed in
 *    the environment dictionary.
 *  - Small integers are immediates
 *  - Byte objects have bytes, hash and behavior
 *  - Slot objects have slots, hash and behavior.
 * Both slots and behaviors are stored as indexes in the object table.
 * The reader generates all object instances in a first pass, and then changes references to
 * other objects by accessing the corresponding index in the object table.
 */

const ModuleReader = class {
    constructor(environment = {})
    {
        this.environment = environment;
    }

   	loadFile(path) {
		let rawdata = readFileSync(path);
		let module = JSON.parse(rawdata);
		this.loadObjects(module);
		return this;
	}

	loadObjects(module) {
		this.objects = module.objects.map(obj => this.recreate(obj));
		this.objects.forEach(obj => this.linkSlots(obj));
		this.exports = Object.fromEntries(module.exports.map( exp => [exp[0], this.objects[exp[1]]]));
		return this.objects;
	}

	objectNamed(name)
	{
	  return this.exports[name];
	}

	recreate(object) {
		switch (this.objectType(object)) {
			case ObjectTypes.SlotObject:
				return this.newSlotObject(object);
			case ObjectTypes.ByteObject:
				return this.newByteObject(object);
			case ObjectTypes.SmallIntegerObject:
				return this.newSmallInteger(object);
            case ObjectTypes.Import:
                return this.environment[object.name];
			default: 
				throw "unknown object type";
		}
	}

	newSlotObject(object)
	{
		let result = new LMRSlotObject();
		result._slots = this.objectSlots(object);
		result._header = new LMRObjectHeader();
		result._header._behavior = this.objectBehavior(object);
		result._header._hash = this.objectHash(object);
		return result;
	}

	newByteObject(object)
	{
		let result = new LMRByteObject();
		result._bytes = this.objectBytes(object);
		result._header = new LMRObjectHeader();
		result._header._behavior = this.objectBehavior(object);
		result._header._hash = this.objectHash(object);
		return result;
	}

	newSmallInteger(object)
	{
		let result = new LMRSmallInteger();
		result._value = object[1];
		return result;
	}
	
	linkSlots(object) {
		if (object.isImmediate())
			return;
		
		object._header._behavior = this.objects[object._header._behavior];
		
		if (!object.isBytes())
			object._slots = object._slots.map(index => this.objects[index]);
	}

	objectType(object)
	{
		return object[0];
	}

	objectSlots(object)
	{
		return object[1];
	}

	objectBytes(object)
	{
		return object[1];
	}

	objectHeader(object)
	{
		return object[2];
	}

	objectBehavior(object)
	{
		return this.objectHeader(object)[0];
	}

	objectHash(object)
	{
		return this.objectHeader(object)[1];
	}

}

export default ModuleReader
