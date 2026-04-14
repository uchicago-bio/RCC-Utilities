# RCC-Utilities

Useful scripts and examples for The University of Chicago's Research Computing Center (https://rcc.uchicago.edu). All SLURM examples target the **Midway3** cluster using the `caslake` partition.

## Utility Scripts

* **`.bashrc`** — A starter `.bashrc` that adds safety aliases to prevent accidental `rm *` disasters.

* **`src/machine_info.py`** — Reports the number of physical cores, logical cores, and threads per core using `psutil` and `os.cpu_count()`. Useful for understanding the hardware topology of a node.

* **`src/monkey_shakespear.py`** — Generates random Shakespearean-style sentences by combining subjects, verbs, objects, and adverbs. Each sentence is prefixed with the hostname, making it easy to see which node produced it. Used by several of the SLURM demos below.

## Data

* **`data/`** — A collection of FASTA files and a sample database used by the examples.
  
## Sample SLURM Jobs

The examples are numbered in order of increasing complexity. Each builds on concepts from the previous one.

### `1_single_node_job/`

The simplest possible batch job: one node, one task, one core. Demonstrates basic `#SBATCH` directives, SLURM environment variables, and output file naming with `%j`. No `srun` is needed because the script runs directly on the single allocated node.

**Scripts:**
- `single_node.sbatch` — Prints hostname, sleeps for 10 seconds, and reports start/end times.
- `single_node_monkey.sbatch` — Same structure, but runs `monkey_shakespear.py` instead of sleeping.
- `debug.sbatch` — An example BLASTp job showing how to print SLURM variables for debugging.

### `2_hello_world/`

Demonstrates a **common multi-node mistake**. The script requests 6 nodes and lists them with `scontrol show hostnames`, but the actual command runs **without `srun`** — so only the head node executes it. The `srun` line is commented out to make the bug visible.

**Key lesson:** Without `srun`, commands in a multi-node job only run on the head node. The other nodes sit idle while you're still charged for them. Uncomment the `srun` line to see the correct behavior.

### `3_multi_node_job/`

The corrected version of the hello world pattern. Uses `srun` to run `monkey_shakespear.py` on **24 nodes simultaneously**, with all output appended to a single shared file (`monkey_shakespear_book.txt`). Each line identifies which node wrote it via the hostname prefix.

### `4_array_job/`

Introduces SLURM array jobs with `--array=0-10`. Each of the 11 tasks receives a unique `$SLURM_ARRAY_TASK_ID` and runs independently — no `srun` required, since each array element is already its own SLURM job. The script demonstrates how to use `printf` to zero-pad the task ID (e.g., `00`, `01`, ..., `10`) for consistent filenames.

**Output files** use the `%j.%a` pattern, where `%j` is the job ID and `%a` is the array task ID.

### `5_fragment_array_job/`

A complete **dynamic pipeline** driven by a Python script (`custom_array.py`) that:

1. Reads a database file and splits it into N equal-sized chunks.
2. Writes each chunk to a temporary file (`tempdb_0.db`, `tempdb_1.db`, ...).
3. **Generates** a custom `.sbatch` file at runtime with `--array=0-N`.
4. Submits it with `subprocess.run(['sbatch', ...])` and captures the job ID.
5. **Generates** a cleanup `.sbatch` file with `--dependency=afterok:<job_id>`.
6. Submits the cleanup job, which moves all output and temporary files into a workspace directory.

This is a pattern for production workflows where the number of tasks depends on the input data.

### `6_dependency_workflows/`

Shows how to chain jobs so that each one waits for the previous one to finish. Includes both a **bash** and a **Python** implementation.

**Bash (`dependency.bash`):** Uses `awk '{print $4}'` to extract the job ID from `sbatch` output, then passes it via `--dependency=afterok` and `--dependency=afterany`.

**Python (`dependency.py`):** Wraps submission in a function with error handling. If any submission fails, all previously submitted jobs are cancelled with `scancel`. Each job appends a line to `workflow.out`, creating a log of the execution chain.

**Dependency types:**
| Flag | Behavior |
|------|----------|
| `afterok` | Run only if the dependency succeeded (exit code 0) |
| `afterany` | Run regardless of success or failure |
| `afternotok` | Run only if the dependency failed |

### `7_multiprocessing/`

A **hybrid** approach that combines SLURM multi-node allocation with Python's `multiprocessing.Pool`. The SLURM directives request 4 nodes with 4 CPUs per task, and the Python script reads SLURM environment variables to configure the pool size accordingly.

Each worker receives a database chunk identifier, simulates processing with a random sleep, and writes output to a file tagged with the job ID, node count, and chunk number. This pattern maximizes utilization by using SLURM for inter-node distribution and `multiprocessing` for intra-node parallelism.


### `8_blast/`
A benchmarking demonstration using BLASTp for sequence alignment. *Note: This has not been updated for Midway3.*


## Usage

All scripts assume the `mpcs56430` account on the `caslake` partition. To run any example:

```bash
ssh <your_cnetid>@midway3.rcc.uchicago.edu
cd RCC-Utilities/<example_directory>
sbatch <script_name>.sbatch
```

For the Python-driven workflows (`5_fragment_array_job`, `6_dependency_workflows`), run the Python script directly from the login node:

```bash
python custom_array.py
python dependency.py
```
