import numpy as np
import mne  # For EEG data manipulation
from sklearn.decomposition import PCA, FastICA
from scipy.fft import fft, fftn  # Fourier Transform
from scipy.signal import stft  # Short Time Fourier Transform
import pywt  # For Discrete Wavelet Transform

import tarfile
import os

def extract_tar_gz(tar_gz_path, extract_path=None):
    """
    Extracts a .tar.gz file to the specified directory.

    :param tar_gz_path: Path to the .tar.gz file.
    :param extract_path: Directory to extract the files into. Defaults to the current directory.
    """
    if extract_path is None:
        extract_path = os.path.dirname(tar_gz_path)
    
    with tarfile.open(tar_gz_path, "r:gz") as tar:
        tar.extractall(path=extract_path)
        print(f"Files extracted to {extract_path}")

def extract_multiple_tar_gz(file_paths, extract_path=None):
    """
    Extracts multiple .tar.gz files to the specified directory.

    :param file_paths: A list of paths to the .tar.gz files.
    :param extract_path: Directory to extract all files into. Defaults to the directory of each file.
    """
    for file_path in file_paths:
        extract_tar_gz(file_path, extract_path)

# Example usage
tar_gz_paths = ['path/to/your/first/file.tar.gz', 'path/to/your/second/file.tar.gz']  # Update this list with all your file paths
extract_multiple_tar_gz(tar_gz_paths)
# Function to load EEG data (Modify according to your data format)
def load_eeg_data(file_path):
    # Implement the loading depending on the format of your EEG files
    # For example, if they are in .edf format you can use mne.io.read_raw_edf(file_path)
    raw = mne.io.read_raw(file_path, preload=True)
    return raw.get_data()

# PCA and ICA
def apply_pca_ica(data):
    pca = PCA(n_components=5)  # Adjust components as necessary
    ica = FastICA(n_components=5)
    
    pca_data = pca.fit_transform(data)
    ica_data = ica.fit_transform(data)
    
    return pca_data, ica_data

# Fourier and related transforms
def apply_transforms(data):
    fft_data = fft(data)  # Fast Fourier Transform
    
    # Short Time Fourier Transform, adjust parameters as needed
    f, t, Zxx = stft(data, nperseg=100)
    
    # Discrete Wavelet Transform, choose your wavelet
    coeffs = pywt.dwt(data, 'db1')  # 'db1' is Daubechies wavelet, adjust as necessary
    
    return fft_data, Zxx, coeffs

# Main function to process the files
def process_eeg_files(file_paths):
    for file_path in file_paths:
        data = load_eeg_data(file_path)  # Load data
        
        # Apply PCA and ICA
        pca_data, ica_data = apply_pca_ica(data)
        
        # Apply Fourier and related transforms
        fft_data, stft_data, dwt_data = apply_transforms(data)
        
        # Here you can further process or save the transformed data

# Example usage
file_paths = ['path/to/eeg1.fif', 'path/to/eeg2.fif']  # Update with your file paths
process_eeg_files(file_paths)