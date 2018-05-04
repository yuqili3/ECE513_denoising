import os
import numpy as np
import OnlineDict_py.denoiseImageOnlineDict as old
import OnlineDict_py.PSNR as PSNR
import scipy.io as sio

root            =   '/mnt/spinner/yuqi/imageDataset';
Dataset =	'kodak';
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList 	=	[5, 10, 15, 25, 50];

bb = 8; # block size
K = 256;
method = 'old'; #online dict



for i in range(24):
#for i in range(1):
    inFile = '%s/%s/kodim%02d.mat'%(root,Dataset,i+1)
    M = sio.loadmat(inFile)
    X = M['X']
    for j,sigma in enumerate(NoiseLevelList):
        inFile = '%s/%s/kodim%02d/sigma%d.mat'%(root,Dataset,i+1,sigma)
        M = sio.loadmat(inFile)
        noisy = M['noisy']
        psnr_noisy = M['psnr_noisy']
        Xr, output, code = old.denoiseImageOnlineDict(noisy,sigma,K)
        psnr_Xr = PSNR.PSNR(X - Xr)
        outFile = '%s/%s_%s/kodim%02d/sigma%d_dict%d.mat'%(root,Dataset,method,i+1,sigma,K)
        directory = os.path.dirname(outFile)
        if not os.path.exists(directory):
            os.makedirs(directory)
        sio.savemat(outFile,{'Xr':Xr,'psnr_Xr':psnr_Xr,'psnr_noisy': psnr_noisy,'Dict':output})
        
        
        


