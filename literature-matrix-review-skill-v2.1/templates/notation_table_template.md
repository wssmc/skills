# Notation Table Template

## Sets and indices

| Symbol | Description |
|---|---|
| J | Set of scheduling objects |
| S | Set of stages |
| M_s | Set of machines at stage s |
| A | Set of precedence arcs |

## Parameters

| Symbol | Description |
|---|---|
| p_{js} | Processing time of object j at stage s. p_{js}=0 indicates a missing operation. |
| m_s | Number of machines at stage s |
| H | A sufficiently large constant |

## Decision variables

| Symbol | Description |
|---|---|
| x_{jsm} | 1 if object j is assigned to machine m at stage s; 0 otherwise |
| S_{js} | Start time of object j at stage s |
| C_{js} | Completion time of object j at stage s |
| Cmax | Makespan |
