#pragma once

#include <cstddef>
#include <deque>
#include <string>
#include <unordered_map>
#include <vector>

namespace hfsp {

// One cache is created for one instance × algorithm × repetition.
// The key includes the instance identity, job sequence and machine assignment.
class EvalCache {
public:
    explicit EvalCache(std::size_t capacity = 500) : capacity_(capacity) {}

    bool get(const std::string& key, double& value) {
        const auto it = values_.find(key);
        if (it == values_.end()) {
            ++misses_;
            return false;
        }
        value = it->second;
        ++hits_;
        return true;
    }

    void put(std::string key, double value) {
        if (capacity_ == 0) {
            return;
        }
        if (values_.find(key) != values_.end()) {
            values_[key] = value;
            return;
        }
        while (order_.size() >= capacity_) {
            values_.erase(order_.front());
            order_.pop_front();
        }
        order_.push_back(key);
        values_.emplace(std::move(key), value);
    }

    std::size_t hits() const noexcept { return hits_; }
    std::size_t misses() const noexcept { return misses_; }
    std::size_t size() const noexcept { return values_.size(); }

private:
    std::size_t capacity_;
    std::deque<std::string> order_;
    std::unordered_map<std::string, double> values_;
    std::size_t hits_{0};
    std::size_t misses_{0};
};

inline std::string make_eval_key(
    const std::string& instance_id,
    const std::vector<std::size_t>& sequence,
    const std::vector<std::size_t>& machine_assignment) {
    std::string key = instance_id + "|s:";
    for (const auto value : sequence) {
        key += std::to_string(value) + ",";
    }
    key += "|m:";
    for (const auto value : machine_assignment) {
        key += std::to_string(value) + ",";
    }
    return key;
}

} // namespace hfsp
