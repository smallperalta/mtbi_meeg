# mTBI-EEG

Pipeline for the processing and analysis of EEG data from mild Traumatic Brain Injuries (mTBI) patients.

The processing pipeline reads raw EEG data and processes it to obtain bandpower data.
The analysis pipeline utilizes ML models for classifying the subjects. 
The preprocessing and analysis sections are run separately.

_Authors: Verna Heikkinen, Mia Liljeström, Aino Kuusi, Estanislao Porta_

## Diagram
The diagram of the pipeline can be seen in the following diagram:

![Pipeline diagram](/src/pipeline_diagram.png)

### Example images on the output data:
<Add images of the output control plots / ROC / metadata >

## Folder structure
The folder structure for the project is shown below. The root folder is `mtbi_meeg`. The code is under `src`. Common scripts and config files are under `src/`.
The modules for data processing and data analysis are under `src/processing/` and `src/analysis/`.

```bash
mtbi_meeg/
├── LICENSE
├── README.md
├── requirements.txt
├── setup.py
├── src/
│   ├── check_system.py
│   ├── config_eeg.py
│   ├── config_common.py
│   ├── fnames.py
│   ├── pickle_data_handler.py
│   ├── other_files/
│   ├── analysis/
│   │    ├── 01_read_processed_data.py
│   │    ├── 02_plot_processed_data.py
│   │    ├── 03_fit_classifier_and_plot.py
│   │    ├── 03_psd_topoplots.py (WIP)
│   │    ├── 04_create_report.py
│   │    ├── 05_reports_to_pdf.py
│   │    ├── count_code_lines.py
│   │    └── run_files.py
│   └── processing/
│        ├── 01_freqfilt.py
│        ├── 02_ica.py
│        ├── 03_psds.py
│        ├── 04_bandpower.py
│        └── run_files.py
└── tests/
    ├── test_01_read_processed_data.py
    ├── test_01_read_processed_data_unittest.py
    └── test_02_plot_processed_data.py
```

## Installing the package locally in the computer
The package can be installed by cloning the repository and using pip install:

```bash
$ git clone https://github.com/BioMag/mtbi_meeg
# cd into the root directory
$ cd mtbi_meeg
$ python3 -m pip install .
```
This will install all the necessary dependencies for the package to work. 

In the case that freely installing dependencies in the local computer is not possible or not desirable, an option is to create a conda environment or start a Docker container. Instructions using these two alternative methods are described below. 

## Installing in a Conda environment

### Installing miniconda (macOS)
If you don't have conda yet, install miniconda via Homebrew:
```bash
$ brew install --cask miniconda
```
Then initialize it for your shell (one-time setup) and restart your terminal:
```bash
$ conda init "$(basename "${SHELL}")"   # e.g. conda init zsh
```
Verify with `conda --version`.

### Installing miniconda (windows)
Download from https://www.anaconda.com/download/success

### Installign miniconda (Linux)
Follow instructions from https://www.anaconda.com/docs/getting-started/miniconda/install/linux-install

### Creating the environment
1. After cloning the repository, navigate to the root directory.
2. Create the conda environment by running,
    ```
    $ conda env create --file environment.yml
    # Note: this step might take 20+ minutes
    ```
3. Activate the created environment,
    ```
    $ conda activate mtbi_meeg_conda
    ```
   If `conda activate` errors with "shell has not been properly configured", run `conda init "$(basename "${SHELL}")"` and restart your terminal.
4. Install the package and its dependencies,
    ```
    $ python3 -m pip install .
    ```
## Installing using Docker
This Dockerfile specifies a base image (`continuumio/miniconda3:latest`), updates conda, installs the necessary dependencies, and copies the `mtbi_meeg` package code into the container. It also sets the working directory and specifies the default command to run when the container starts.

1. Build the Docker image: Run the command `docker build -t mtbi_meeg . ` to build the Docker image. This will create a new image named `mtbi_meeg` based on the Dockerfile.

2. Run the Docker container: Run the command `docker run -it mtbi_meeg` to start the container and run your package. This will start a new container based on the my_package image and run the default command specified in the Dockerfile.

## Getting started: config_common and check_system

Before the first time you execute the scripts in this repository, you must edit the file `src/config_common.py` and include a new block with information about your user, workstation, data directories, and matplotlib backend:

1. Go to folder `src` and open the file `config_common.py` for editing. From terminal,
    ```bash
    $ cd src
    $ nano config_common.py
    # Note: you can also use other editors. For using VS Code, type `code config_common.py`
    ```
2. Edit the file: add your `user` and `host` to the list. Copy the commented template block at the bottom of `config_common.py` and fill it in for your machine:

    ```python
    elif host == '<WORKSTATION>' and user == '<USER>' :
        # <USER>'s workstation in <WORKPLACE>
        raw_data_dir = ''
        processed_data_dir = ''
        reports_dir = ''
        figures_dir = ''
        n_jobs = 4
        matplotlib_backend = ''
    ```
3. Add the path where `raw_data_dir` is expected ('/net/theta/fishpool/projects/tbi_meg/BIDS' in BioMag)
4. Add the path where `processed_data_dir` is expected (Be mindful which folder you choose, as you may overwrite other people's data)
5. Add the paths where figures and reports will be created into (you can use the directories in this repository or other)
6. Add the matplotlib backend ("use Qt5Agg for desktop, Agg for headless/HPC")
7. Check that your system has the required dependencies by running the script `check_system.py`. From terminal, 
    ```bash
    $ python3 check_system.py
    ```
If there's no problems, you should see a message saying that 'System requirements are ok' and you should be ok to run the pipeline now.

### Version Conflict errors
If there is an issue with packages or versions, you will see a message indicating the library with a Version Conflict. Please update the package
```bash
# For updating using pip,
$ python3 -m  pip install --upgrade <package-name>
# For updating using conda,
$ conda update <package-name>
```
### Missing raw data dir errors
 If raw data is missing, the repository cannot be used.

## Running the pipelines
Once you have added the required information in config_common and checked that all the dependencies are met, you can run the `preprocessing` or `analysis` sections. If you haven't, please follow the instructions described above.

### Preprocessing
The preprocessing pipeline can be found in `src/processing/`. The aim of this pipeline is to clean up the data and extract useful features, so data can be used by the classifiers in the analysis section.

**Files:**
- `01_freqfilt.py`: applies frequency filtering
- `02_ica.py`: removes ocular & heartbeat artefacts with independent component analysis
- `03_psds.py`: computes the PSDs over all channels and saves them as h5 files
- `04_bandpower.py`: calculates band power for each subject and creates a spatial frequency matrix that is then vectorized for later analysis.

**Inputs:**
- Raw data (in folder `raw_data_dir`)
- Parameters defined in config_eeg.py 
- Subject(s)

**Outputs:**
- Processed files: CSV files with bandpower data (in folder `processed_data_dir`)
- Reports

#### How to run
Go to the folder `src/processing`. Make sure that file `subjects.txt` exists in the folder.

You can run one file at a time using `python3 <filename> <arguments>`.
Alternatively, you can run the pipeline using the `run_files.py` file. It loops over all steps of the pipeline, using one subject at a time. This means that it will re-run the pipeline as many times as subjects there are.
Since running all the steps for one subject might take a couple of minutes, there's an option to run a test run with only two subjects by modifying the boolean `TEST_RUN` to True in the `run_files.py` file.

```bash
$ cd src/processing/
# Note: Due to the extensive time that running the processing pipeline for each subject takes,
# one can modify the boolean `TEST_RUN` to True in the file `run_files.py` (using, e.g., `nano run_files.py`).
# This will run the whole processing pipeline for only 2 subjects, which takes around 3min or 1.5min per subject.
$ python3 run_files.py
```

### Analysis pipeline
The data analysis is done using the scripts in the folder `src/analysis`. The aim is to use different classifiers (LR, LDA, SVM and RF) to differentiate between patients and controls. A file `subjects.txt` is expected in this folder.

**Files:**
- `01_read_processed_data.py`: Reads in EEG bandpower data from CSV files into a dataframe. The dataframe and the arguments used to run the script are added to a pickle object.
- `02_plot_processed_data.py`: (optional step) Plots the processed EEG data of the PSD intensity for visual assessment.
- `03_fit_classifier_and_plot.py`: Fits ML classifiers using the processed data, performs cross validation and evaluates the performance of the classification using ROC curves. Outputs a CSV file with the classification results, plots and saves plots to disk and adds the information to a metadata file.
- `03_psd_topoplots.py`: (WIP) Plots PSD topographic maps across channels.
- `04_create_report.py`: (optional) Creates an HTML report with the figures created in step 03.
- `05_reports_to_pdf.py`: (optional) Bundle up all htmls into one with a certain cover and create a PDF from it.
- `run_files.py`: Orchestrates the analysis pipeline by running steps 01–05 sequentially for each task (EO, EC, PASAT_1, PASAT_2).

**Inputs:**
- Processed files: CSV files with bandpower data (in folder `processed_data_dir`)
- List of subjects in `subjects.txt`
- parameters defined in `config_eeg.py`

**Outputs:**
- CSV file with results from ML classification accuracy metrics
- PNG figures
- HTML reports
- PDF with all the HTML reports

#### How to run it
Go to the folder `src/analysis`. Make sure that file `subjects.txt` exists in the folder.

You can run one file at a time using `python3 <filename> <arguments>`.
Alternatively, you can run the whole pipeline using the `run_files.py` file. It loops over all steps of the pipeline, using all the list of subjects for each steps, but iterating over the four different tasks: eyes open (EO), eyes closed (EC), Paced Auditory Serial Addition Test 1 or 2 (PASAT_1 or PASAT_2). This means that you will run the whole pipeline four times. 

```bash
$ cd src/analysis/
# Note: Make sure that subjects.txt exists here
$ python3 run_files.py
```

### Subjects as arguments
The current way of defining the subjects to be processed is either via command line arguments and running each step of the pipeline separately or by using `run_files.py`, along with a file where all the subjects to be processed exist, named `subjects.txt`.

An example of the file can be seen below:
```python
# subjects.txt
01C
01P
02C
02P
# etc
```

## Instructions for running it in Aalto's HPC
> Note: these instructions are based on the official Triton documentation. BioMag users should verify module names by running `module spider conda` on the login node.
### 1. Get access
Request a Triton account at https://scicomp.aalto.fi/triton/accounts/
(separate from your Aalto account). Access is free for Aalto researchers.

### 2. Connect
```bash
ssh username@triton.aalto.fi
```

### 3. Set up the environment
Clone the repository and create the conda environment on Triton.
Note: the raw data is already available at the BioMag data path
defined in `config_common.py` — no transfer needed.

```bash
git clone https://github.com/BioMag/mtbi_meeg
cd mtbi_meeg
module load miniconda
conda env create --file environment.yml
conda activate mtbi_meeg_conda
pip install .
```

### 4. Submit a single subject (serial job)
Create a file `run_subject.sh`:

```bash
#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --job-name=mtbi_processing
#SBATCH --output=logs/mtbi_%j.out

module load miniconda
conda activate mtbi_meeg_conda

cd src/processing
python3 run_files.py
```

Submit with:
```bash
sbatch run_subject.sh
```

### 5. Monitor your job
```bash
slurm queue        # check status
slurm history      # see completed jobs
scancel JOBID      # cancel a job
```

### 6. Further reading
- [Triton quickstart](https://scicomp.aalto.fi/triton/quickstart/)
- [Serial jobs](https://scicomp.aalto.fi/triton/tut/serial/)
- [Array jobs (per-subject parallelism)](https://scicomp.aalto.fi/triton/tut/array/)

## Things that are yet to be implemented:
- [x] config file for analysis? 
- [x] model fitting
- [ ] hyperparameter optimization, triton-compatible
- [x] model validation
- [x] visualizations
- [x] statistics
- [ ] Add slurm batching for HPC


## Contributing
Contributions are welcome: fork the repo, work on a branch, and open a PR against `main`. New to Github? See [GitHub's documentation on PRs](https://docs.github.com/en/pull-requests).

## License
Project under MIT License
