# 推荐项目结构

```text
project/
├── README.md
├── requirements.txt
├── configs/
│   ├── solver_cplex.json
│   ├── experiment_demo.json
│   ├── experiment_small.json
│   └── experiment_large.json
├── data/
│   ├── demo_data/
│   │   ├── processing_times.txt
│   │   ├── stage_machines.txt
│   │   ├── due_dates.txt
│   │   ├── release_times.txt
│   │   └── index.json
│   ├── data_small/
│   └── data_large/
├── src/
│   ├── core/
│   │   ├── instance.py
│   │   ├── schedule.py
│   │   ├── solution.py
│   │   ├── objective.py
│   │   └── result.py
│   ├── io/
│   │   ├── txt_loader.py
│   │   ├── json_index_loader.py
│   │   ├── data_validator.py
│   │   └── result_writer.py
│   ├── problems/
│   │   ├── base_problem.py
│   │   └── hfsp/
│   │       ├── hfsp_instance.py
│   │       ├── hfsp_parser.py
│   │       ├── hfsp_generator.py
│   │       ├── hfsp_objective.py
│   │       └── hfsp_rules.py
│   ├── solvers/
│   │   ├── base_solver.py
│   │   ├── solver_config.py
│   │   └── mip/
│   │       ├── cplex_hfsp_model.py
│   │       ├── variable_manager.py
│   │       ├── constraint_builder.py
│   │       ├── objective_builder.py
│   │       └── solution_extractor.py
│   ├── algorithms/
│   │   ├── encoding/
│   │   ├── decoding/
│   │   ├── baselines/
│   │   ├── proposed/
│   │   └── common/
│   ├── constraints/
│   ├── resources/
│   ├── evaluation/
│   ├── visualization/
│   └── utils/
├── scripts/
├── tests/
└── outputs/
```
