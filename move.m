root            =   '/mnt/spinner/yuqi/imageDataset';
rootsource      =   '/mnt/spinner/bihan/scratch/imageDataset'
DatasetList     =   {'kodak'};
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList  =   [5, 10, 15, 25, 50];

addpath('KSVD_Matlab_ToolBox');
bb = 8; % block size
RRList = [4]; % redundancy factor

method = 'ksvd';

for idxR = 1: length(RRList)
    RR = RRList(idxR);
    K =RR*bb^2; % number of atoms in the dictionary
    for idxDS = 1:length(DatasetList)
        Dataset = char(DatasetList(idxDS));
        imageDir = fullfile(root,Dataset);
        imList = dir(fullfile(imageDir, '*.mat'));
        numImage = numel(imList);

        for idxImage = 1:numImage
            curData     =   imList(idxImage).name;
            curName     =   curData(1:end - length('.mat'));
            load(fullfile(imageDir,curData),'X');
            resultImDir = fullfile(root,strcat(Dataset,'_',method),curName);
            noisyDir = fullfile(imageDir,curName);
            if ~exist(resultImDir,'dir')
                mkdir(resultImDir);
            end
            resultSourceDir = fullfile(rootsource,strcat(Dataset,'_',method),curName);
            for i = 1:length(NoiseLevelList)
                sigma = NoiseLevelList(i);
                load(fullfile(noisyDir,sprintf('sigma%d.mat',sigma)), 'psnr_noisy');
                load(fullfile(resultSourceDir,sprintf('sigma%d.mat',sigma)), 'Xr','psnrXr');
                psnr_Xr = psnrXr
                DictSize = K;
                outfile = sprintf('%s/sigma%d_dict%d.mat',char(resultImDir),sigma,DictSize);
                save(outfile,'Xr','psnr_Xr','psnr_noisy','DictSize');

            end
        end
    end
end
