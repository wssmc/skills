# Upstream Contract for mip-scheduling-project-generator-skill

~~~text
problem-decomposition-skill
  -> literature-matrix-review-skill-v2.1
  -> mip-scheduling-project-generator-skill
~~~

## Required problem inputs

- refined problem description
- problem fingerprint
- entities, resources, parameters, constraints and objectives
- assumptions and data requirements
- current problem family and adaptation needs

## Recommended literature inputs

- problem feature table
- method matrix
- recommended baselines
- method design hints
- evidence for experiment settings

## Generation contract

- C++17 core; Python for instances, CPLEX MIP, and analysis
- IBM ILOG CPLEX Python API (`cplex`) MIP
- Bash orchestration
- one explicit recorded generation seed per instance and fixed solve seeds
- N rounds equals N solve seeds
- no EvalCache, Concert C++, Gurobi or docplex
- problem-specific model instead of HFSP-only assumptions
