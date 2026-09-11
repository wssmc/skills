#pragma once

#include "scheduling/core/domain.hpp"

#include <filesystem>

namespace scheduling {

void write_outputs(const SolveResult &solved, const std::filesystem::path &output_dir);

} // namespace scheduling
