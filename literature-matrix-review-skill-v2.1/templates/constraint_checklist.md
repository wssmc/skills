# Constraint Checklist

- [ ] Each non-missing operation is assigned to exactly one eligible machine.
- [ ] Missing operations are not assigned and do not occupy machine capacity.
- [ ] Non-missing operations of the same object follow stage order.
- [ ] Each machine processes at most one object at a time.
- [ ] Downstream objects respect all upstream release constraints.
- [ ] The precedence graph is acyclic.
- [ ] Makespan is defined by the last non-missing operation of every object.
- [ ] All variables have correct domains.
- [ ] If Big-M is used, it is not excessively loose.
