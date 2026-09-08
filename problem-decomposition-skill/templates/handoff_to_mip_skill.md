# Handoff to mip-scheduling-project-generator-skill

## Problem Type

HFSP / HFFS.

## Required Data Format

Main data in txt, connected by index.json.

## Core Files

- processing_times.txt
- stage_machines.txt
- due_windows.txt, if applicable
- priority_jobs.txt, if applicable
- shared_windows.txt, if applicable
- machine_unavailability.txt, if applicable

## Modeling Requirements

- IBM ILOG CPLEX Python API (`cplex`) MIP model;
- HFSP decoder;
- baseline algorithms;
- proposed algorithm module;
- feasibility checker;
- Gantt chart;
- comparison tables.

## Extension Requirements

Use constraint and resource plugins for setup, transport, worker and machine calendar constraints.
