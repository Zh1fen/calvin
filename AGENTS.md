# Repository Guidelines

## Project Structure & Module Organization
- `calvin_env/`: simulation environment package (installed editable by `install.sh`).
- `calvin_models/`: model code and Hydra configs. Main code lives in `calvin_models/calvin_agent/` (`training.py`, `evaluation/`, `models/`, `datasets/`).
- `calvin_models/conf/`: Hydra config tree (`model/`, `datamodule/`, `trainer/`, `callbacks/`, `inference/`).
- `dataset/`: dataset download scripts and format docs.
- `slurm_scripts/`: cluster launch/resume/eval helpers.
- `scripts/`: utility scripts such as dataset visualization.

## Build, Test, and Development Commands
- Environment setup:
  - `conda create -n calvin_venv python=3.8 && conda activate calvin_venv`
  - `sh install.sh` (installs `calvin_env` and `calvin_models` in editable mode).
- Dataset download (from `dataset/`): `sh download_data.sh D` (or `ABC`, `ABCD`, `debug`).
- Train baseline (from `calvin_models/calvin_agent/`):
  - `python training.py datamodule.root_data_dir=/path/to/dataset datamodule/datasets=vision_lang_shm`
- Evaluate:
  - `python evaluation/evaluate_policy.py --dataset_path <DATASET> --train_folder <RUN_DIR>`
- Slurm training (from `slurm_scripts/`):
  - `python slurm_training.py --venv calvin_venv datamodule.root_data_dir=/path/to/dataset/`
- Quality checks:
  - `pre-commit run --all-files`
  - `pytest` (and optionally `pytest --cov`).

## Coding Style & Naming Conventions
- Python 3.8 target, 4-space indentation, max line length 120.
- Formatting/import order: `black` + `isort` (configured in `pyproject.toml`).
- Lint/type checks: `flake8`, `mypy` via `.pre-commit-config.yaml`.
- Keep Hydra override names aligned with config paths (example: `datamodule/observation_space=lang_rgbd_both`).

## Testing Guidelines
- Use `pytest` for new tests; place tests under package-level `tests/` directories (create if missing).
- Name test files `test_*.py` and mirror target module names.
- For training/eval changes, add at least one smoke test for CLI entrypoints or config loading.

## Commit & Pull Request Guidelines
- Current history favors short, imperative commit titles (`add ...`, `fix ...`, `update ...`).
- Keep subject lines concise; scope each commit to one logical change.
- PRs should include:
  - What changed and why.
  - Repro commands used (train/eval/lint/test).
  - Config overrides and dataset split used.
  - Logs or screenshots for behavior/metric changes when relevant.
