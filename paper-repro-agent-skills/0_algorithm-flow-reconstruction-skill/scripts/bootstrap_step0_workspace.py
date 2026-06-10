from pathlib import Path
import shutil

TEMPLATES = Path(__file__).resolve().parents[1] / "assets" / "templates"

def main(out="artifacts/step0"):
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    for p in TEMPLATES.iterdir():
        if p.is_file():
            shutil.copy2(p, out / p.name)
    print(f"Created Step 0 workspace at {out}")

if __name__ == "__main__":
    import sys
    main(sys.argv[1] if len(sys.argv) > 1 else "artifacts/step0")
