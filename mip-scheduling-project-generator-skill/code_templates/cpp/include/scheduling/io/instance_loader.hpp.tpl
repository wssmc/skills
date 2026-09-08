#pragma once

#include "scheduling/core/domain.hpp"

#include <filesystem>

namespace scheduling {

FlowShopInstance load_instance(const std::filesystem::path& instance_directory);

} // namespace scheduling
