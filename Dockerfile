FROM continuumio/miniconda3:latest

# Install mamba in base env for faster dependency resolution
RUN conda install -n base -c conda-forge mamba -y

# Copy project files into the image
COPY . /app
WORKDIR /app

# Create the conda env from environment.yml (single source of truth for conda deps)
RUN mamba env create -f environment.yml

# Install the package itself + pip-only deps (e.g. torch) into the conda env
RUN /opt/conda/envs/mtbi_meeg_conda/bin/pip install -e .

# Run any command inside the activated conda env by default.
# `--no-capture-output` keeps stdout/stderr streaming live (otherwise `conda run` buffers everything).
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "mtbi_meeg_conda"]
CMD ["bash"]

# Usage:
#   docker build -t mtbi_meeg .
#   docker run -it mtbi_meeg
# Inside the container, `python` is the conda env's python; `import torch, mne` should work.
