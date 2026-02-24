#!/bin/bash
#SBATCH --job-name="mel20ms_75ep_resume"
#SBATCH --partition=PGR-Standard
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=5-00:00:00
#SBATCH --output=/home/s2211921/MelHuBERT/experiments/slurm_log/mel20ms_%j.out

set -e

cd /home/s2211921/MelHuBERT
source venvmel/bin/activate
. /home/htang2/toolchain-20251006/toolchain.rc

# ---------- paths ----------
SCRATCH=/disk/scratch/s2211921
LIBRI=$SCRATCH/librispeech
PROC=$LIBRI/melhubert/processed
CSV=$PROC/libri-360-data-cluster-pair.csv

mkdir -p "$PROC"
mkdir -p experiments/slurm_log
mkdir -p experiments/20ms_pretrain/baseline_resume

# ---------- stage data if needed ----------
if [ ! -f "$CSV" ]; then
  echo "[INFO] CSV not found — preparing LibriSpeech"

  if [ ! -f "$LIBRI/libri-360.tar" ]; then
    echo "[INFO] Copying tar to scratch"
    cp "$HOME/libri-360.tar" "$LIBRI/"
  fi

  if [ ! -d "$LIBRI/libri-360" ]; then
    echo "[INFO] Extracting LibriSpeech"
    tar -xf "$LIBRI/libri-360.tar" -C "$LIBRI/"
  fi

  echo "[INFO] Running MelHuBERT preprocessing"
  bash preprocess.sh "$LIBRI/libri-360" "$PROC"
else
  echo "[INFO] CSV already exists — skipping preprocessing"
fi


mkdir -p /home/s2211921/MelHuBERT/experiments/slurm_log
mkdir -p /home/s2211921/MelHuBERT/experiments/20ms_pretrain/baseline_resume

python3 train.py \
  -f 20 \
  -g ./config/config_model_20ms.yaml \
  -c ./config/config_runner_20ms_resume_75ep.yaml \
  -n /home/s2211921/MelHuBERT/experiments/20ms_pretrain/baseline_resume \
  -i /home/s2211921/MelHuBERT/experiments/20ms_pretrain/checkpoint-epoch-75.ckpt \
  --init_optimizer_from_initial_weight
