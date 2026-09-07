#include "hfsp/io/instance_loader.hpp"
#include "hfsp/registry.hpp"

#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>

namespace {

void write_outputs(const hfsp::SolveResult& result, const std::filesystem::path& output_dir) {
    std::filesystem::create_directories(output_dir);
    {
        std::ofstream output(output_dir / (result.result.algorithm + "_result.json"));
        output << std::setprecision(17)
               << "{\"algorithm\":\"" << result.result.algorithm
               << "\",\"objective\":" << result.result.objective
               << ",\"runtime_seconds\":" << result.result.runtime_seconds
               << ",\"seed\":" << result.result.seed
               << ",\"feasible\":" << (result.result.feasible ? "true" : "false") << "}\n";
    }
    {
        std::ofstream output(output_dir / (result.result.algorithm + "_schedule.csv"));
        output << "job_id,stage_id,machine_id,start,end\n";
        for (const auto& operation : result.schedule.operations) {
            output << operation.job_id << ',' << operation.stage_id << ',' << operation.machine_id << ','
                   << std::setprecision(17) << operation.start << ',' << operation.end << '\n';
        }
    }
    {
        std::ofstream output(output_dir / (result.result.algorithm + "_trace.csv"));
        output << "iteration,elapsed_seconds,objective\n";
        for (const auto& point : result.trace) {
            output << point.iteration << ',' << std::setprecision(17) << point.elapsed_seconds << ','
                   << point.objective << '\n';
        }
    }
    {
        std::ofstream output(output_dir / (result.result.algorithm + "_best_seq.json"));
        output << "{\"job_sequence\":[";
        for (std::size_t index = 0; index < result.result.best_sequence.size(); ++index) {
            if (index != 0) {
                output << ',';
            }
            output << result.result.best_sequence[index];
        }
        output << "],\"machine_assignment\":[";
        for (std::size_t index = 0; index < result.schedule.operations.size(); ++index) {
            if (index != 0) {
                output << ',';
            }
            output << result.schedule.operations[index].machine_id;
        }
        output << "]}\n";
    }
}

} // namespace

int run_main(int argc, char** argv) {
    hfsp::Instance instance;
    if (argc > 1) {
        instance = hfsp::load_instance(argv[1]);
    } else {
        instance.id = "demo_cpp";
        instance.machines_per_stage = {2, 2};
        instance.processing_times = {{2.0, 3.0}, {1.0, 2.0}, {3.0, 1.0}};
    }
    instance.validate();
    const auto algorithm = argc > 2 ? std::string(argv[2]) : "sa_basic";
    const auto it = hfsp::algorithm_registry().find(algorithm);
    if (it == hfsp::algorithm_registry().end()) {
        std::cerr << "unknown algorithm: " << algorithm << '\n';
        return EXIT_FAILURE;
    }
    const auto result = it->second(instance, hfsp::SolveConfig{});
    const auto output_dir = std::filesystem::path("outputs") / "single" / instance.id;
    write_outputs(result, output_dir);
    std::cout << "algorithm=" << result.result.algorithm
              << " objective=" << result.result.objective
              << " feasible=" << (result.result.feasible ? "true" : "false") << '\n';
    return result.result.feasible ? EXIT_SUCCESS : EXIT_FAILURE;
}

int main(int argc, char** argv) {
    try {
        return run_main(argc, argv);
    } catch (const std::exception& error) {
        std::cerr << "hfsp_run error: " << error.what() << '\n';
        return EXIT_FAILURE;
    }
}
