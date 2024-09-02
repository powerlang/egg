
#include "Evaluator/Runtime.h"
#include "ImageSegment.h"
#include "HeapObject.h"

#include <map>
#include <string>
#include <vector>
#include <filesystem>
#include <fstream>

namespace Egg {

class Bootstrapper {
	public:
	std::map<std::string, ImageSegment*> _segments;
	Runtime *_runtime;
	ImageSegment *_kernel;

	Bootstrapper(ImageSegment *kernel) {
		this->_kernel = kernel;
		this->_runtime = new Runtime(this, this->_kernel);
//		this->_runtime->bootstrapper_(this);
		this->_runtime->initializeEvaluator();
	}

	HeapObject* loadModule_(std::string name)
	{
		auto imageSegment = _segments.contains(name) ? _segments[name] : this->loadModuleFromFile(name + ".ems");
		return imageSegment->_exports["__module__"];
	}

	/**
	 * Traverses the image segment looking for references to imports (last two bits are 10b),
	 * converting them to the corresponding imported value.
	 */
	void
	fixObjectReferences(ImageSegment *imageSegment, std::vector<Object*> &imports)
	{
		auto current = ((HeapObject::ObjectHeader*)imageSegment->header.baseAddress)->object();
		auto end = (HeapObject*)(imageSegment->header.baseAddress + imageSegment->header.reservedSize);
		while (current < end)
		{
			auto behavior = current->behavior();
			if (((uintptr_t)behavior & 0x2) == 0x2)
				current->behavior(imports[((uintptr_t)behavior)>>2]->asHeapObject());

			for (uintptr_t i = 0; i < current->pointersSize(); i++)
			{
				auto &slot = current->slot(i);
				if (((uintptr_t)slot & 0x2) == 0x2)
					slot = imports[((uintptr_t)i)>>2];
			}
		}
	}

	void 
	bindModuleImports(ImageSegment *imageSegment, std::vector<Object*> &imports)
	{
		for (int i = 0; i < imageSegment->_importDescriptors.size(); i++)
		{
			imports[i] = this->bindModuleImport(imageSegment, imageSegment->_importDescriptors[i]);
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
		
		std::vector<Object*> args = { (Object*)linker, (Object*)token };
		auto ref = this->_runtime->sendLocal_to_with_("linker:token:", (Object*)this->_kernel->_exports["SymbolicReference"], args);
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
		auto stream = std::ifstream(filepath);
		auto imageSegment = new ImageSegment(&stream);
		std::vector<Object*> imports;
		this->bindModuleImports(imageSegment, imports);
		this->fixObjectReferences(imageSegment, imports);
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
};

}
