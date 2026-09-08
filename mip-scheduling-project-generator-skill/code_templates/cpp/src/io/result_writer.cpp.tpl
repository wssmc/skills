#include "scheduling/io/result_writer.hpp"

#include <cmath>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <stdexcept>

namespace scheduling {

void write_outputs(const SolveResult& solved, const std::filesystem::path& output_dir) {
    std::filesystem::create_directories(output_dir);
    {
        std::ofstream output(output_dir / "result.json");
        if (!output) {
            throw std::runtime_error("cannot write result.json");
        }
        output << std::setprecision(17)
               << R"({"instance_id":")" << solved.result.instance_id
               << R"(","instance_seed":)" << solved.result.instance_seed
               << R"(,"algorithm":")" << solved.result.algorithm
               << R"(","round":)" << solved.result.round
               << R"(,"solve_seed":)" << solved.result.solve_seed
               << R"(,"objective":)";
        if (solved.result.feasible && std::isfinite(solved.result.objective)) {
            output << solved.result.objective;
        } else {
            output << "null";
        }
        output << R"(,"runtime_seconds":)" << solved.result.runtime_seconds
               << R"(,"feasible":)" << (solved.result.feasible ? "true" : "false")
               << R"(,"status":")" << solved.result.status << R"(","best_bound":)";
        if (solved.result.best_bound) {
            output << *solved.result.best_bound;
        } else {
            output << "null";
        }
        output << R"(,"relative_gap":)";
        if (solved.result.relative_gap) {
            output << *solved.result.relative_gap;
        } else {
            output << "null";
        }
        output << '}' << '\n';
    }
    {
        std::ofstream output(output_dir / "solution.json");
        if (!output) {
            throw std::runtime_error("cannot write solution.json");
        }
        output << R"({"job_sequence":[)";
        for (std::size_t index = 0; index < solved.result.best_sequence.size(); ++index) {
            if (index != 0) {
                output << ',';
            }
            output << solved.result.best_sequence[index];
        }
        output << R"(],"operations":[)";
        for (std::size_t index = 0; index < solved.schedule.operations.size(); ++index) {
            if (index != 0) {
                output << ',';
            }
            const auto& operation = solved.schedule.operations[index];
            output << R"({"job_id":)" << operation.job_id
                   << R"(,"stage_id":)" << operation.stage_id
                   << R"(,"machine_id":)" << operation.machine_id
                   << R"(,"start":)" << operation.start
                   << R"(,"end":)" << operation.end << '}';
        }
        output << "]}" << '\n';
    }
    {
        std::ofstream output(output_dir / "schedule.csv");
        output << "job_id,stage_id,machine_id,start,end\n";
        for (const auto& operation : solved.schedule.operations) {
            output << operation.job_id << ',' << operation.stage_id << ',' << operation.machine_id << ','
                   << std::setprecision(17) << operation.start << ',' << operation.end << '\n';
        }
    }
    {
        std::ofstream output(output_dir / "trace.csv");
        output << "iteration,elapsed_seconds,objective\n";
        for (const auto& point : solved.trace) {
            output << point.iteration << ',' << std::setprecision(17) << point.elapsed_seconds << ','
                   << point.objective << '\n';
        }
    }
}

} // namespace scheduling
