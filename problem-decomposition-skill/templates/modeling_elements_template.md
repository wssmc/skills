# Modeling Elements

## Sets

- J: jobs
- S: stages
- M_s: machines available at stage s
- W: due windows or shared windows, if applicable
- U_m: unavailable periods of machine m, if applicable
- R: additional resources, such as transporters or workers

## Parameters

- p[j, s]: processing time of job j at stage s
- r[j]: release time of job j
- d[j] or [e[j], l[j]]: due date or due window
- wE[j], wT[j]: earliness and tardiness weights
- a[m, t]: machine availability calendar
- cap[r]: capacity of resource r

## Decisions

- x[j, s, m]: whether job j is assigned to machine m at stage s
- C[j, s]: completion time of job j at stage s
- S[j, s]: start time of job j at stage s
- y[i, j, s, m]: sequencing variable on a machine
- E[j], T[j]: earliness and tardiness

## Objective

Minimize TWET or user-defined objective.

## Constraints

- assignment
- stage precedence
- machine no-overlap
- machine unavailability
- due window / priority / shared window
- optional setup / transport / worker constraints
