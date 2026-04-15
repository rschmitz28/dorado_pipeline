# Dorado Pipeline

This script assumes a sample-level directory structure in which each top-level sample folder contains a second sample folder, and that nested folder contains one or more run directories. Each run directory must include a `pod5/` subdirectory containing POD5 files. `run_dorado_fastq.sh` should be placed in and executed from the nested sample directory, alongside the run folders.

## Expected Directory Structure
```
<sample>/
└── <sample>/
    ├── <run_1>/
    │   └── pod5/
    ├── <run_2>/
    │   └── pod5/
    ├── <run_3>/
    │   └── pod5/
    └── run_dorado_fastq.sh
```
## Output

Running the script will generate the following files in the sample-level directory:

- `dorado<jobid>.log` — log file capturing Dorado execution details  
- `<sample>.fastq` — merged FASTQ file containing basecalled reads from all runs for the sample

## Notes

- This script is written for a SLURM-based GPU environment.
- Update SLURM resource requests as needed for your system.
- It is recommended to run this from within a `tmux` session to avoid interruption if your connection drops.
- By default, the script expects `dorado` to be available in your environment.
- The script assumes that the `dorado` executable is available in your environment. You can download it from the [Dorado Github repository](https://github.com/nanoporetech/dorado/?tab=readme-ov-file). The Patel Lab should have it on the `../common/reference/tools/` location.
- You can override the Dorado executable path or model at runtime:

```bash
DORADO=/path/to/dorado MODEL=dna_r10.4.1_e8.2_400bps_sup@v5.2.0 sbatch run_dorado_fastq.sh
