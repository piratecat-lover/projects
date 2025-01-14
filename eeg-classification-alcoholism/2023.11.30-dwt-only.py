import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import scipy.io as sio
import pywt

path=
raw_data=
eeg_data=raw_data['eeg_data']
pywt.wavedec(eeg_data,wavelet='db4',level=5)