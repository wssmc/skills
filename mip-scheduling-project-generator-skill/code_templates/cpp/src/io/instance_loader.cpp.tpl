#include "scheduling/io/instance_loader.hpp"

#include <cerrno>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace scheduling {
namespace {

bool parse_double(const std::string& token, double& value) {
    char* end = nullptr;
    errno = 0;
    value = std::strtod(token.c_str(), &end);
    return end != token.c_str() && *end == '\0' && errno != ERANGE;
}

std::vector<std::size_t> read_machine_counts(const std::filesystem::path& path) {
    std::ifstream input(path);
    if (!input) {
        throw std::runtime_error("cannot open " + path.string());
    }
    std::vector<std::size_t> counts;
    std::string line;
    while (std::getline(input, line)) {
        std::istringstream row(line);
        std::string stage;
        std::string count_token;
        if (!(row >> stage >> count_token)) {
            continue;
        }
        double count = 0.0;
        if (!parse_double(count_token, count) || count < 1.0 || count != static_cast<double>(static_cast<std::size_t>(count))) {
            continue; // header row
        }
        counts.push_back(static_cast<std::size_t>(count));
    }
    if (counts.empty()) {
        throw std::invalid_argument("stage_machines.txt contains no machine counts");
    }
    return counts;
}

std::vector<std::vector<double>> read_processing_times(const std::filesystem::path& path) {
    std::ifstream input(path);
    if (!input) {
        throw std::runtime_error("cannot open " + path.string());
    }
    std::vector<std::vector<double>> rows;
    std::string line;
    while (std::getline(input, line)) {
        std::istringstream row(line);
        std::string job_token;
        if (!(row >> job_token)) {
            continue;
        }
        double job_id = 0.0;
        if (!parse_double(job_token, job_id)) {
            continue; // header row
        }
        std::vector<double> values;
        std::string token;
        while (row >> token) {
            double value = 0.0;
            if (!parse_double(token, value)) {
                throw std::invalid_argument("invalid processing time in " + path.string());
            }
            values.push_back(value);
        }
        if (!values.empty()) {
            rows.push_back(std::move(values));
        }
    }
    if (rows.empty()) {
        throw std::invalid_argument("processing_times.txt contains no data rows");
    }
    return rows;
}

} // namespace

FlowShopInstance load_instance(const std::filesystem::path& directory) {
    FlowShopInstance instance;
    instance.id = directory.filename().string();
    {
        std::ifstream seed_input(directory / "instance_seed.txt");
        if (!seed_input || !(seed_input >> instance.instance_seed)) {
            throw std::invalid_argument("instance_seed.txt is missing or invalid");
        }
    }
    instance.machines_per_stage = read_machine_counts(directory / "stage_machines.txt");
    instance.processing_times = read_processing_times(directory / "processing_times.txt");
    instance.validate();
    return instance;
}

} // namespace scheduling
