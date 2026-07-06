{
  "problem_type": "{{problem_type}}",
  "solver": "gurobi",
  "objective": "{{objective}}",
  "features": {
    "has_missing_operations": {{has_missing_operations}},
    "missing_mode": "{{missing_mode}}",
    "has_machine_reentry": {{has_machine_reentry}},
    "machine_reentry_positions": {{machine_reentry_positions}},
    "has_manual_operations": {{has_manual_operations}},
    "manual_operations_by_m": {{manual_operations_by_m}},
    "manual_resource_mode": "{{manual_resource_mode}}",
    "has_setup_time": {{has_setup_time}},
    "has_transport_time": {{has_transport_time}},
    "has_worker_resource": {{has_worker_resource}},
    "has_maintenance_window": {{has_maintenance_window}},
    "has_batch_constraint": {{has_batch_constraint}},
    "has_precedence_constraint": {{has_precedence_constraint}},
    "has_due_date": {{has_due_date}},
    "has_release_time": {{has_release_time}},
    "preemption_allowed": {{preemption_allowed}},
    "waiting_allowed": {{waiting_allowed}}
  },
  "constraints": {
    "stage_order": "sequential",
    "machine_capacity": 1,
    "machine_no_overlap": true
  },
  "generated_heuristics": {{generated_heuristics}},
  "generated_neighborhoods": {{generated_neighborhoods}},
  "instance_configs": {
    "demo": {{demo_config}},
    "small": {{small_config}},
    "large": {{large_config}}
  }
}