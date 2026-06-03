# Example Case: HFSP-MO-NLPC

## Research topic

带缺失操作与排料图—批次关系约束的混合流水车间调度问题。

Suggested English name:

```text
Hybrid Flow Shop Scheduling Problem with Missing Operations and Nesting-to-Lot Precedence Constraints
HFSP-MO-NLPC
```

## Problem fingerprint

```json
{
  "problem_type": "Hybrid flow shop scheduling with missing operations and DAG precedence",
  "domain": "stamping / sheet metal / nesting-to-lot production",
  "shop_keywords": ["hybrid flow shop", "hybrid flowshop", "flexible flow shop"],
  "objective_keywords": ["makespan", "Cmax", "maximum completion time"],
  "constraint_keywords": ["missing operations", "skipped stages", "precedence constraints", "DAG", "nesting", "batch", "lot", "release time"],
  "business_objects": ["raw order", "NEST order", "merged order", "LOT batch", "part"],
  "decision_variables": ["machine assignment", "operation sequencing", "start time", "completion time"],
  "target_gap_hypothesis": "Nesting improves material utilization but changes the downstream release mechanism; the resulting NEST-to-LOT dependency must be integrated with missing operations in a multi-stage HFSP."
}
```

## Suggested search queries

```text
("hybrid flow shop" OR "hybrid flowshop" OR "flexible flow shop")
AND ("missing operations" OR "skipped stages" OR "operation skipping")
AND ("makespan" OR "Cmax")
```

```text
("sheet metal" OR "stamping" OR "part cutting" OR "nesting")
AND ("scheduling" OR "production scheduling")
AND ("batch" OR "lot" OR "bill of materials" OR "release time")
```

```text
("hybrid flow shop" OR "hybrid flowshop")
AND ("precedence constraints" OR "time lags" OR "bill of materials" OR "DAG")
```

## Chapter 2 structure

```text
2.1 Hybrid flow shop scheduling
2.2 Hybrid flow shop scheduling with missing operations
2.3 Scheduling with precedence, BOM, assembly, and release constraints
2.4 Sheet metal nesting and batch/lot scheduling
2.5 Literature comparison and positioning of this study
```

Insert the paper-ready problem feature matrix in Section 2.5.

## Baseline candidate marking

Potential baseline categories:

- MIP / exact solver for small instances;
- HFSP-MO heuristic for missing-operation comparison;
- precedence-aware heuristic for inter-order dependency comparison;
- nesting-scheduling heuristic for business-mechanism comparison;
- general SA / GA / IG / VNS for metaheuristic comparison;
- ablation variants of the proposed algorithm.

## Gap argument map

### Production fact

In stamping and sheet-metal production, nesting is used to improve material utilization by placing parts from multiple orders on the same sheet. A downstream lot may require parts cut from multiple nesting sheets.

### Why it matters

The downstream lot release time is not determined only by the lot's own route. It depends on the completion of all upstream NEST orders that provide required parts.

### Scheduling consequence

The final scheduling objects are not raw orders. They are NEST orders and downstream LOT batches. The precedence relation is a many-to-many DAG, while different objects may skip different stages.

### Remaining modeling gap

Existing streams cover HFSP, missing operations, precedence constraints, and nesting-scheduling separately, but a unified HFSP model for NEST/LOT object transformation with missing operations and NEST-to-LOT release constraints remains insufficient.

### How this study responds

Define HFSP-MO-NLPC, model NEST and LOT as scheduling objects, enforce missing operations and NEST→LOT release constraints, and design suitable decoding / neighborhood / experiment instances.

## Chapter 3 outline

```text
3 Problem Description
3.1 Production process and object transformation
3.2 Scheduling objects and precedence relationship
3.3 Assumptions
3.4 Illustrative example
3.5 Gantt-chart interpretation
```

## Chapter 5.1 outline

```text
5.1 Experimental design
5.1.1 Instance generation
5.1.2 Parameter calibration
5.1.3 Compared algorithms and evaluation metrics
```
