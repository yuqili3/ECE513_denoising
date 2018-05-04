root            =   '/mnt/spinner/yuqi/imageDataset';
DatasetList 	=	{'kodak'};
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList 	=	[5, 10, 15, 25, 50];

addpath('unitary_transform_learning');
bb = 8; % block size

method = 'utl';

for idxDS = 1:length(DatasetList)
    Dataset = char(DatasetList(idxDS));
	imageDir = fullfile(root,Dataset);
	imList = dir(fullfile(imageDir, '*.mat'));
	numImage = numel(imList);

	for idxImage = 1:numImage
    	curData     =   imList(idxImage).name;
        curName     =   curData(1:end - length('.mat'));
        load(fullfile(imageDir,curData),'X');
        noisyDir = fullfile(imageDir,curName);
        resultImDir = fullfile(root,strcat(Dataset,'_',method),curName);
		if ~exist(resultImDir,'dir')
			mkdir(resultImDir);
		end
		for i = 1:length(NoiseLevelList)
            sigma = NoiseLevelList(i);
            load(fullfile(noisyDir,sprintf('sigma%d.mat',sigma)), 'noisy','psnr_noisy');
            param.sig = sigma;
            param = getParam(param);
            [Xr, psnrXr] = UTL_imagedenoising(noisy, param, X);
            psnr_Xr = PSNR(Xr - X);
            outfile = sprintf('%s/sigma%d_dict%d.mat',char(resultImDir),sigma,bb^2);
            save(outfile,'Xr','psnr_Xr','psnr_noisy');
        end
    end
end


