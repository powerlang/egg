#ifndef LMR_TEST_SEGMENT_PATH_H
#define LMR_TEST_SEGMENT_PATH_H

#include <string>

namespace lmr_test
{
inline std::string segPath(const char* name)
{
    return std::string(LMR_SEG_DIR) + "/" + name;
}
} // namespace lmr_test

#endif // LMR_TEST_SEGMENT_PATH_H
