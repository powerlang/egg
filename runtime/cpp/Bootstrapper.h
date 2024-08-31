
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
		return imageSegment->exports["__module__"];
	}

	ImageSegment* loadModuleFromFile(const std::string &filename)
	{
		auto filepath = this->findInPath(filename);
		auto stream = std::ifstream(filepath);
		auto imageSegment = new ImageSegment(&stream);
		//this->bindModuleImports(reader);
		return imageSegment;
	}

	std::filesystem::path findInPath(const std::string &filename)
	{
		std::vector<std::string> dirs({"./", "../"});
		auto searched = "image-segments/" + filename;
		for (auto dir : dirs ) {
			auto filePath = std::filesystem::path(dir) / searched;

			if (std::filesystem::exists(filePath))
					return filePath;
		}

		std::terminate();
	}
};

}
