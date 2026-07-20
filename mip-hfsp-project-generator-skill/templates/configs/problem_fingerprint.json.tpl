{
  "problem_type": "{{problem_type}}",
  "template_support": "{{direct_basic_hfsp_or_adapter_required}}",
  "solver": "gurobi",
  "objective": "{{objective}}",
  "base_hfsp_assumptions": {
    "same_stage_route_for_all_jobs": {{same_stage_route_for_all_jobs}},
    "processing_time_mode": "{{job_by_stage_or_other}}",
    "parallel_machines_per_stage": {{parallel_machines_per_stage}},
    "waiting_allowed": {{waiting_allowed}},
    "preemption_allowed": {{preemption_allowed}},
    "machine_capacity": 1
  },
  "features": {
    "has_release_time": {{has_release_time}},
    "has_due_date": {{has_due_date}},
    "has_explicit_precedence": {{has_explicit_precedence}},
    "has_setup_time": {{has_setup_time}},
    "has_transport_time": {{has_transport_time}},
    "has_reentry": {{has_reentry}},
    "has_optional_routes": {{has_optional_routes}},
    "has_machine_dependent_processing_time": {{has_machine_dependent_processing_time}},
    "has_additional_resources": {{has_additional_resources}},
    "has_maintenance_windows": {{has_maintenance_windows}},
    "has_batch_constraints": {{has_batch_constraints}},
    "has_multiple_objectives": {{has_multiple_objectives}}
  },
  "required_adapters": {{required_adapters}},
  "required_regression_tests": {{required_regression_tests}},
  "instance_configs": {
    "demo": {{demo_config}},
    "small": {{small_config}},
    "large": {{large_config}}
  }
}
