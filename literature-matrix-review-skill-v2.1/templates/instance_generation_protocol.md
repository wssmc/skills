# Instance Generation Protocol

## Object generation

1. Generate raw orders.
2. Map raw orders to upstream objects such as NEST orders.
3. Generate merged orders / consolidated batches.
4. Split merged orders into downstream LOT objects.
5. Generate precedence arcs from NEST to LOT.

## Shop generation

| Factor | Suggested levels |
|---|---|
| Number of stages | 5, 8, 10 |
| Machines per stage | random integer in [2, 7] |
| Instance size | small / medium / large |
| Missing-operation rate | 20%, 40%, 60% |
| Processing time | discrete uniform [1, 99], with 0 for missing operations |
| Predecessors per downstream object | 1–5 |
| Out-degree of upstream object | 1–3 |
| Graph type | DAG, preferably only upstream-to-downstream arcs if the problem assumes NEST→LOT |

## Output data files

- processing_time_matrix.csv
- machine_counts.csv
- order_types.csv
- precedence_arcs.csv
- instance_metadata.json
