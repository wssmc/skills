{
  "problem_family": "{{problem_family}}",
  "problem_type": "{{problem_type}}",
  "reference_adapter": "{{flow_shop_or_custom}}",
  "core_language": "C++17",
  "auxiliary_language": "Python 3",
  "mip_solver": "IBM ILOG CPLEX Python API (cplex)",
  "orchestration": "Bash",
  "evaluation_cache": false,
  "instance_seed_policy": "one recorded seed per instance directory",
  "solve_seed_file": "configs/seeds/solve_seeds.txt",
  "rounds": "{{round_count}}",
  "adaptation_status": "{{direct_reference_or_adapter_required}}"
}
