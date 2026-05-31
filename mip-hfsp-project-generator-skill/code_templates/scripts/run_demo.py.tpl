from pathlib import Path
from src.problems.hfsp.hfsp_parser import load_hfsp_instance
from src.solvers.mip.cplex_hfsp_model import CplexHFSPModel
from src.algorithms.encoding.hfsp_encoding import generate_random_encoding
from src.algorithms.decoding.hfsp_decoder import decode_hfsp_encoding
from src.evaluation.metrics import evaluate_schedule
from src.evaluation.feasibility_checker import check_feasibility
from src.visualization.gantt import plot_gantt


def main():
    root = Path(__file__).resolve().parents[1]
    instance = load_hfsp_instance(root / "data" / "demo_data" / "index.json")

    mip = CplexHFSPModel(instance, config={"time_limit": 300, "mip_gap": 0.001, "log_output": True}).build()
    solution = mip.solve()
    if solution:
        mip_schedule = mip.extract_schedule()
        evaluate_schedule(mip_schedule, instance)
        print("MIP metrics:", mip_schedule.metrics)
        print("MIP violations:", check_feasibility(mip_schedule, instance))
        plot_gantt(mip_schedule, "MIP Schedule", root / "outputs" / "figures" / "gantt_mip.png")

    encoding = generate_random_encoding(instance, seed=42)
    decode_schedule = decode_hfsp_encoding(encoding, instance)
    evaluate_schedule(decode_schedule, instance)
    print("Decode metrics:", decode_schedule.metrics)
    print("Decode violations:", check_feasibility(decode_schedule, instance))
    plot_gantt(decode_schedule, "Decoded Schedule", root / "outputs" / "figures" / "gantt_decode.png")


if __name__ == "__main__":
    main()
