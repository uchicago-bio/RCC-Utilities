"""
machine_info.py

Retrieves detailed hardware topology information for the current machine, including
the number of sockets, physical cores, and logical threads.

This utility is intended to provide a quick overview of the system’s CPU structure
to assist with performance tuning or parallel resource allocation.

Note:
    Reported values may not always be accurate due to system configuration,
    virtualization, or limited hardware visibility.
"""

import psutil
import os

def with_psutil():
    physical_cores = psutil.cpu_count(logical=False)
    logical_cores = psutil.cpu_count(logical=True)

    print(f"Physical cores: {physical_cores}")
    print(f"Logical cores: {logical_cores}")
    print(f"Threads per core: {logical_cores / physical_cores:.2f}")

def with_os():
    num_cores = os.cpu_count()
    print(f"Logical cores available: {num_cores}")


with_psutil()
with_os()

