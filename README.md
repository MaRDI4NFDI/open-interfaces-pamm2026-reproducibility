# Reproducibility package for the manuscript "Software package MaRDI Open Interfaces for improved interoperability in numerical optimization"

This repository contains the reproducibility package for the manuscript
"Software package MaRDI Open Interfaces for improved interoperability
in numerical optimization".

## Usage

To provide a quick way of reproducing the computations from the manuscript,
we use [Docker](https://docker.com) which gives an ability to run
software inside isolated _containers_ without installing anything
directly on a given computer.

1. Build a Docker image that contains :

```shell
docker build -t mardi-oif-optim-repro .
```
which will use the `Dockerfile` in this repro to build [MaRDI Open
Interfaces](https://github.com/MaRDI4NFDI/open-interfaces)
on the Ubuntu 24.04 operating system.
This will take some time depending on your computer
and Internet bandwidth, to download dependencies, compile Julia packages
and compile _MaRDI Open Interfaces_.

2. Start a container based on the built image:
```shell
docker run -it --rm -v"$(PWD)":"/app" mardi-oif-optim-repro
```

3. Run experiments that train neural networks using MaRDI Open Interfaces::
```shell
cd exp/15-2026-11-15-vbe-all-together/
# Optionally, do smoke testing with the following commands
# python ../../bin/train_viscous_burgers_pinn.py --outdir=_tmpdir --impl scipy_optimize --opt BFGS --gtol 1e-1 --split-key --seed 1 --jit --warmup
# python ../../bin/train_viscous_burgers_pinn.py --outdir=_tmpdir --impl optim_jl --opt BFGS --gtol 1e-1 --split-key --seed 1 --linesearch StrongWolfe --jit --warmup
bash run.sh
```

To generate statistics, do
```shell
python table_statistics.py | python transform-latex-table.py
```

## Additional notes 1

We used the script `runall_linux_workstation.sh` that checks that Turbo Boost
(Intel technology for variable CPU frequency) is disabled.
Additionally, we run the code using `nice -n -15` (high-priority).
We used a workstation equipped with an 8-core Intel Intel Xeon E5-1630 v3 CPU (3.70~GHz).

## Additional notes 2

To start on a Macbook with 8 performance cores
forcing to prevent sleeping of disk, display and forcing high priority:
```shell
caffeinate -dimsu sudo nice -n -15 \
    docker run -it --rm -v"$(PWD)":"/app" \
         --cpus="8" \
        -e OMP_NUM_THREADS=8 \
        -e OPENBLAS_NUM_THREADS=8 \
        mardi-oif-optim-repro
```

## Copyright

2026 © Dmitry I. Kabanov, Stephan Rave, Mario Ohlberger
