
#include <filesystem>
#include <string>
#include <cstring>

using namespace std;

extern "C" {

    void* directory_new_from_path(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        try {
            return new filesystem::directory_entry(*path);
        } catch (...) {
            return nullptr;
        }
    }

    void* directory_path(void* cdir) {
        filesystem::directory_entry *dir = static_cast<filesystem::directory_entry*>(cdir);
        return new filesystem::path(dir->path());
    }

    void directory_release(void* cdirectory) {
        delete static_cast<filesystem::directory_entry*>(cdirectory);
    }

    bool path_create_directory(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return filesystem::create_directory(*path);
    }

    bool path_create_directories(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return filesystem::create_directories(*path);
    }

    bool path_exists(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return filesystem::exists(*path);
    }

    const char* path_filename(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        auto filename = path->filename().string();
        char* cstr = new char[filename.size() + 1]; // Allocate on the heap
        strcpy(cstr, filename.c_str());        // Copy the contents of the string
        return cstr;         
    }

    void* path_new(const char* path) {
        return new filesystem::path(path);
    }

    void* path_parent(void *cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return new filesystem::path(path->parent_path());
    }

    void* path_operator_slash(void* cpath, const char* other) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return new filesystem::path((*path) / other);
    }
    
    bool path_remove(void* cpath) {
        filesystem::path *path = static_cast<filesystem::path*>(cpath);
        return filesystem::remove(*path);
    }

    void path_release(void* path) {
        delete static_cast<filesystem::path*>(path);
    }

}

