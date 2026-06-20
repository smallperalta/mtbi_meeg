
# PyTorch MLP on EEG bandpower features

A 2-layer neural network classifier trained end-to-end in PyTorch, applied to MNE's public `eegbci` dataset (motor-imagery EEG from PhysioNet, 20 subjects). The notebook walks through:

1. Loading the dataset via `mne.datasets.eegbci`
2. Extracting bandpower features (delta/theta/alpha/beta/gamma) via Welch's PSD method
3. A 2-layer MLP defined with `nn.Module`
4. A training loop 
5. Model output evaluation
6. Data re-scaling to address issues
7. Re-training and evaluation

**Why this dataset, not BioMag mTBI data?** The original idea was to use the same data from sklearn classifiers in `src/analysis/`. However BioMag data from real clinical patients and thus subjec to strict privacy regulations, it cannot be used outside the lab.

BioMag data is patient and therefore sensitive and subject to strict privacy matter. The idea would be to test this out with the BioMag data in the future.

**To run:** activate the conda env (`conda activate mtbi_meeg_conda`), open `experiments/torch_mlp_nn.ipynb` in VS Code or `jupyter`, and Run All. 