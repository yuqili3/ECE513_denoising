import numpy as np

def PSNR(X):
    a = X.shape
    psnr = 20*np.log10(np.sqrt(a[0]*a[1]) * 255 / np.linalg.norm(X))
    return psnr