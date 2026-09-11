#include "scheduling/io/instance_loader.hpp"
#include "scheduling/io/result_writer.hpp"
#include "scheduling/registry.hpp"

#include <cctype>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <iostream>
#include <stdexcept>
#include <string>

namespace {

std::uint64_t parse_u64(const std::string &text, const char *label) {
    std::size_t used = 0;
    const auto value = std::stoull(text, &used);
    if (used != text.size()) {
        throw std::invalid_argument(std::string(label) + " must be an unsigned integer");
    }
    return value;
}

std::string safe_component(const std::string &value) {
    if (value.empty()) {
        throw std::invalid_argument("output path component must not be empty");
    }
    for (const auto ch : value) {
        const auto byte = static_cast<unsigned char>(ch);
        if (!(std::isalnum(byte) || ch == '-' || ch == '_' || ch == '.')) {
            throw std::invalid_argument("unsafe output path component: " + value);
        }
    }
    return value;
}

std::filesystem::path output_root() {
    const auto *configured = std::getenv("SCHED_OUTPUT_ROOT");
    auto root = std::filesystem::path(configured ? configured : "outputs/tmp/unclassified")
                    .lexically_normal();
    if (root.empty() || root.is_absolute()) {
        throw std::invalid_argument("SCHED_OUTPUT_ROOT must be a relative path under outputs/");
    }
    auto part = root.begin();
    if (part == root.end() || part->string() != "outputs") {
        throw std::invalid_argument("SCHED_OUTPUT_ROOT must be under outputs/");
    }
    for (const auto &component : root) {
        if (component == "..") {
            throw std::invalid_argument("SCHED_OUTPUT_ROOT must not contain '..'");
        }
    }
    return root;
}

int run_main(int argc, char **argv) {
    if (argc != 5) {
        std::cerr << "usage: solver_run INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND\n";
        return EXIT_FAILURE;
    }
    const auto instance = scheduling::load_instance(argv[1]);
    const auto algorithm = safe_component(argv[2]);
    const auto solve_seed = parse_u64(argv[3], "solve_seed");
    const auto round_value = parse_u64(argv[4], "round");
    if (round_value == 0) {
        throw std::invalid_argument("round must be at least 1");
    }
    const auto round = static_cast<std::size_t>(round_value);
    const auto found = scheduling::algorithm_registry().find(algorithm);
    if (found == scheduling::algorithm_registry().end()) {
        std::cerr << "unknown algorithm: " << algorithm << '\n';
        return EXIT_FAILURE;
    }

    const scheduling::SolveConfig config{30.0, solve_seed, round, 200};
    const auto solved = found->second(instance, config);
    const auto run_name = "round_" + std::to_string(round) + "_seed_" + std::to_string(solve_seed);
    const auto output_dir = output_root() / safe_component(instance.id) / algorithm / run_name;
    scheduling::write_outputs(solved, output_dir);
    std::cout << "instance=" << solved.result.instance_id
              << " algorithm=" << solved.result.algorithm << " round=" << solved.result.round
              << " solve_seed=" << solved.result.solve_seed
              << " objective=" << solved.result.objective
              << " feasible=" << (solved.result.feasible ? "true" : "false") << '\n';
    return solved.result.feasible ? EXIT_SUCCESS : EXIT_FAILURE;
}

} // namespace

int main(int argc, char **argv) {
    try {
        return run_main(argc, argv);
    } catch (const std::exception &error) {
        std::cerr << "solver_run error: " << error.what() << '\n';
        return EXIT_FAILURE;
    }
}
