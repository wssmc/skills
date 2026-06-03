# Chapter 4: Model or Method Checklist

This chapter should be written by the researcher because it must match the actual model, algorithm, and code implementation.

## If Chapter 4 is mathematical formulation

Check:

- [ ] Sets and indices are complete.
- [ ] Parameters distinguish missing operations from positive operations.
- [ ] Decision variables match the scheduling decisions.
- [ ] Objective matches the stated goal.
- [ ] Assignment constraints exclude missing operations.
- [ ] Stage precedence constraints are defined only for non-missing operations.
- [ ] Machine capacity constraints are correct.
- [ ] Inter-order precedence / release constraints are correct.
- [ ] Cmax constraints use the last non-missing stage.
- [ ] Big-M values are justified or bounded.

## If Chapter 4 is solution method

Check:

- [ ] Encoding is defined.
- [ ] Decoding produces feasible schedules.
- [ ] Missing operations are skipped correctly.
- [ ] DAG / release constraints are enforced.
- [ ] Neighborhood moves preserve or repair feasibility.
- [ ] Parameter calibration is described.
- [ ] Complexity or computational burden is discussed.
- [ ] Each method component has an ablation counterpart if claimed as a contribution.
