#!/bin/bash
#SBATCH --job-name="mel20ms_40ep"
#SBATCH --partition=PGR-Standard
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=5-00:00:00
#SBATCH --output=/disk/scratch/s2211921/melhubert/experiments/slurm_log/mel20ms_%j.out

set -e

cd /home/s2211921/MelHuBERT
source venvmel/bin/activate
. /home/htang2/toolchain-20251006/toolchain.rc

mkdir -p /disk/scratch/s2211921/melhubert/experiments/slurm_log
mkdir -p /disk/scratch/s2211921/melhubert/experiments/20ms_pretrain

python3 train.py \
  -f 20 \
  -g ./config/config_model_20ms.yaml \
  -c ./config/config_runner_20ms_40ep.yaml \
  -n /disk/scratch/s2211921/melhubert/experiments/20ms_pretrain
