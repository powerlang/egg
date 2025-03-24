
#include "Evaluator/Runtime.h"
#include "ImageSegment.h"
#include "HeapObject.h"

#include <map>
#include <string>
#include <vector>
#include <filesystem>
#include <fstream>
#include <Allocator/GCHeap.h>
#include <Allocator/GCSpace.h>
#include <Evaluator/Evaluator.h>
#include <Evaluator/SAssociationBinding.h>

namespace Egg {

class Bootstrapper {
	public:
	std::map<std::string, ImageSegment*> _segments;
	Runtime *_runtime;
	ImageSegment *_kernel;

	Bootstrapper(ImageSegment *kernel) {
		this->_kernel = kernel;
		this->_runtime = new Runtime(this, this->_kernel);

		this->_runtime->addSegmentSpace_(kernel);
//		this->_runtime->bootstrapper_(this);
		this->_runtime->initializeEvaluator();
	}

	HeapObject* loadModule_(std::string name)
	{
		auto imageSegment = _segments.contains(name) ? _segments[name] : this->loadModuleFromFile(name + ".ems");
		return imageSegment->_exports["__module__"];
	}

	void 
	bindModuleImports(ImageSegment *imageSegment, std::vector<Object*> &imports)
	{
		for (int i = 0; i < imageSegment->_importDescriptors.size(); i++)
		{
			imports.push_back(this->bindModuleImport(imageSegment, imageSegment->_importDescriptors[i]));
		}
	}

	Object* bindModuleImport(ImageSegment* imageSegment, std::vector<std::uint32_t> &descriptor)
	{

		auto linker = this->importStringAt_(imageSegment, descriptor[0]);
		HeapObject *token;
		if (descriptor.size() == 1)
			token = this->_kernel->_exports["nil"];
		else if (descriptor.size() == 2)
			token = this->importStringAt_(imageSegment, descriptor[1]);
		else
		{
			std::vector<HeapObject*> array;
			for (int i = 1; i < descriptor.size(); i++)
				array.push_back(this->importStringAt_(imageSegment, descriptor[i]));
			token = this->transferArray(array);
		}
		
		auto ref = this->_runtime->sendLocal_to_with_with_("linker:token:", (Object*)this->_kernel->_exports["SymbolicReference"], (Object*)linker, (Object*)token);
		return this->_runtime->sendLocal_to_("link", ref);
	}

	HeapObject* importStringAt_(ImageSegment* imageSegment, uint32_t index)
	{
		return this->transferSymbol(imageSegment->importStringAt_(index));
	}

	HeapObject* transferSymbol(std::string &str)
	{
		return this->_runtime->addSymbol_(str);
	}

	HeapObject* transferArray(std::vector<HeapObject*> &array)
	{
		return this->_runtime->newArray_(array);
	}
	
	HeapObject* transferArray(std::vector<Object*> &array)
	{
		return this->_runtime->newArray_(array);
	}


	ImageSegment* loadModuleFromFile(const std::string &filename)
	{
		auto filepath = this->findInPath(filename);
		auto stream = std::ifstream(filepath, std::ios::binary);
		auto imageSegment = new ImageSegment(&stream);
		std::vector<Object*> imports;
		this->bindModuleImports(imageSegment, imports);
		imageSegment->fixPointerSlots(imports);
		this->_runtime->addSegmentSpace_(imageSegment);
		return imageSegment;
	}

	std::filesystem::path findInPath(const std::string &filename)
	{
		std::vector<std::string> dirs({"./", "../"});
		auto searched = "image-segments/" + filename;
		for (auto dir : dirs) {
			auto filePath = std::filesystem::path(dir) / searched;

			if (std::filesystem::exists(filePath))
					return filePath;
		}

		auto str = std::string("could not find module snapshot file ") + filename;
		error(str.c_str());
		std::terminate();
	}

	// only used for testing that the most basic things work (i.e. sending messages)
	ImageSegment* bareLoadModuleFromFile(const std::string &filename)
	{
		auto filepath = this->findInPath(filename);
		auto stream = std::ifstream(filepath);
		auto imageSegment = new ImageSegment(&stream);
		std::vector<Object*> imports;
		for (int i = 0; i < imageSegment->_importDescriptors.size(); i++)
		{
			std::vector<uint32_t> &descriptor = imageSegment->_importDescriptors[i];
			auto import = this->bareBindModuleImport(imageSegment, descriptor);
			std::cout << "import " << i << " is: " << import->printString() << std::endl;
			imports.push_back(import);
		}
		imageSegment->fixPointerSlots(imports);
		return imageSegment;
	}

	Object* bareBindModuleImport(ImageSegment* imageSegment, std::vector<std::uint32_t> &descriptor)
	{

		auto linker = imageSegment->importStringAt_(descriptor[0]);
		std::vector<std::string> tokens;
		for (int i = 1; i < descriptor.size(); i++)
			tokens.push_back(imageSegment->importStringAt_(descriptor[i]));

		if (linker == "asSymbol") {
			auto symbol = _runtime->symbolTableAt_(tokens[0]);
			if (symbol == nullptr) {
				symbol = _runtime->newString_(tokens[0]);
				_runtime->addKnownSymbol_(tokens[0], symbol);
			}
			return (Object*)symbol;
		}
		if (linker == "nil")
			return (Object*)_runtime->_nilObj;
		if (linker == "true")
			return (Object*)_runtime->_trueObj;
		if (linker == "false")
			return (Object*)_runtime->_falseObj;
		if (linker == "asClass")
			return (Object*)_kernel->_exports[tokens[1]];
		if (linker == "asMetaclass")
			return (Object*)_runtime->speciesOf_((Object*)_kernel->_exports[tokens[1]]);
		if (linker == "asBehavior")
			return (Object*)_runtime->speciesInstanceBehavior_(_kernel->_exports[tokens[1]]);
		if (linker == "asMetaclassBehavior")
			return (Object*)_runtime->speciesInstanceBehavior_(_runtime->speciesOf_((Object*)_kernel->_exports[tokens[1]]));
		if (linker == "asModule")
			return (Object*)_kernel->_exports["__module__"];
		if (linker == "symbolTable")
			return (Object*)_kernel->_exports["SymbolTable"];
		if (linker == "nilToken") {
			auto hashTable = _kernel->_exports["HashTable"];
			auto symbol = _runtime->existingSymbolFrom_("NilToken");
			auto binding = (SAssociationBinding*)_runtime->_evaluator->context()->staticBindingForCvar_in_(symbol, hashTable);
			return binding->valueWithin_(_runtime->_evaluator->context());
		}
		ASSERT(false);
	}
};

}
