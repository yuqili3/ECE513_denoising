import numpy as np
import scipy.io as sio
from scipy.misc import imread
from sklearn.decomposition import MiniBatchDictionaryLearning
from sklearn.feature_extraction.image import extract_patches_2d
from sklearn.feature_extraction.image import reconstruct_from_patches_2d
import PSNR
from skimage.color import rgb2gray
import matplotlib.pyplot as plt

def generate_DCT(bb,Pn):
    DCT = np.zeros((Pn,bb))
    for k in range(Pn):
        V = np.cos(np.arange(bb)*k*np.pi/Pn)
        if k > 0:
            V -= np.mean(V)
        DCT[k,:] = V/np.linalg.norm(V)
    DCT = np.kron(DCT, DCT)
    #    plt.imshow(DCT)
    return DCT
def aggregate_patches(Image,sigma, Patches, image_size, patch_size):
    bb = patch_size[0]
    Im = np.zeros(image_size)
    Im_wei = np.zeros(image_size)
    count = 0
    for i in range(image_size[0]-bb+1):
        for j in range(image_size[1]-bb+1):
            blk = Patches[count,:].reshape(bb,bb)
            Im[i:(i+bb), j:(j+bb)] += blk
            Im_wei[i:(i+bb), j:(j+bb)] += 1
            count += 1
    Im = (Image+0.8*sigma*Im)/(1+0.8*sigma*Im_wei)
    return Im
    
def denoiseImageOnlineDict(Image, sigma, K, patch_size = (8,8)):
        
    Image /= 255
    image_size = Image.shape
    Patches = extract_patches_2d(Image,patch_size = patch_size)
    Patches = Patches.reshape(Patches.shape[0],-1)
    Patches_mean = np.mean(Patches, axis=0)
    Patches_std = np.std(Patches, axis=0)
    Patches -= Patches_mean
    Patches /= Patches_std
    DCT = generate_DCT(patch_size[0],int(np.ceil(np.sqrt(K))))
    Dict = MiniBatchDictionaryLearning(n_components=K,alpha=0.001*sigma, dict_init=DCT,batch_size=3, n_iter=500,transform_algorithm='omp',transform_n_nonzero_coefs=3)
#    Dict = MiniBatchDictionaryLearning(n_components=K,alpha=0.001*sigma, dict_init=DCT,batch_size=3, n_iter=500,transform_algorithm='threshold',transform_alpha=0.015*sigma)
    V = Dict.fit(Patches).components_
    print('Fitting completed')
    code = Dict.transform(Patches)
    print('sparse code generated')
    Patches = np.dot(code, V)
    Patches += Patches_mean
    Patches -= Patches.min()
    Patches /= Patches.max()
    Patches = Patches.reshape(Patches.shape[0], *patch_size)
    Imout = aggregate_patches(Image,sigma, Patches, image_size = image_size, patch_size= patch_size)
#    Imout = reconstruct_from_patches_2d(Patches, image_size = image_size)
    Imout -= Imout.min()
    Imout /= Imout.max()
    Imout *= 255
    return Imout, V, code


sigma = 10;
M = sio.loadmat('kodim01.mat')
X = M['X']
M = sio.loadmat('sigma%d.mat'%(sigma))
noisy = M['noisy']
psnr_noisy = M['psnr_noisy']

Xr, output, code = denoiseImageOnlineDict(noisy, sigma, 256)
#Xr = denoiseImageOnlineDict(noisy,sigma,256)
A = np.sum(code!=0,axis = 1)
psnr_Xr = PSNR.PSNR(X-Xr)
sio.savemat('sigma%d_online.mat'%(sigma),{'Xr':Xr,'psnr_Xr':psnr_Xr,'output': output})
#sio.savemat('sigma%d_online.mat'%(sigma),{'Xr':Xr,'psnr_Xr':psnr_Xr})



