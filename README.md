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
cd exp/07-07-2026-06-02-vbe-bfgs-many-trials/
# Optionally, do smoke testing with the following commands
# python ../../bin/train_viscous_burgers_pinn.py --outdir=_tmpdir --impl scipy_optimize --opt BFGS --gtol 1e-1 --split-key --seed 1
# python ../../bin/train_viscous_burgers_pinn.py --outdir=_tmpdir --impl optim_jl --opt BFGS --gtol 1e-1 --split-key --seed 1 --linesearch StrongWolfe
bash run.sh
```

To generate statistics, do
```shell
python table_statistics.py | python transform-latex-table.py
```

4. Run an experiment that trains neural networks using SciPy directly, without
_Open Interfaces_:
```shell
cd  exp/09-2026-11-08-vbe-bfgs-many-trials-raw/
bash run.sh
```

After completion, to generate statistics:
```shell
python table_statistics.py | python transform-latex-table.py
```

## Copyright

2026 © Dmitry I. Kabanov, Stephan Rave, Mario Ohlberger
