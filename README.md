# dorado_pipeline

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
