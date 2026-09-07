#pragma once

#include "hfsp/core/domain.hpp"

#include <filesystem>

namespace hfsp {

// Reads the canonical txt files emitted by the Python data utility.
// The data utility prepares instances; the C++ core owns the runtime model.
Instance load_instance(const std::filesystem::path& instance_directory);

} // namespace hfsp
