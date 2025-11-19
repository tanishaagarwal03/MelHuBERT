#!/bin/bash
#SBATCH --job-name="mel20ms"
#SBATCH --partition=Teach-Standard
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --time=4:00:00
#SBATCH --mem=16G
#SBATCH --output=/disk/scratch/s2211921/melhubert/experiments/slurm_log/log_%j.txt


cd /home/s2211921/MelHuBERT
source venvmel/bin/activate
. /home/htang2/toolchain-20251006/toolchain.rc
mkdir -p /disk/scratch/s2211921/melhubert/experiments
mkdir -p /disk/scratch/s2211921/melhubert/experiments/slurm_log

python3 train.py \
  -f 20 \
  -g ./config/config_model_20ms.yaml \
  -c ./config/config_runner_20ms.yaml \
  -n /disk/scratch/s2211921/melhubert/experiments/20ms_full_run
