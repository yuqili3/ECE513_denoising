root            =   '/mnt/spinner/yuqi/imageDataset';
DatasetList 	=	{'kodak'};
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList 	=	[5, 10, 15, 25, 50];

addpath('KSVD_Matlab_ToolBox');
bb = 8; % block size
RRList = [8]; % redundancy factor
% RRList = [4];

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
            noisyDir = fullfile(imageDir,curName);
            resultImDir = fullfile(root,strcat(Dataset,'_',method),curName);
			if ~exist(resultImDir,'dir')
				mkdir(resultImDir);
			end
			for i = 1:length(NoiseLevelList)
                sigma = NoiseLevelList(i);
                load(fullfile(noisyDir,sprintf('sigma%d.mat',sigma)), 'noisy','psnr_noisy');
                [Xr,output] = denoiseImageKSVD(noisy, sigma, K); % Xr: reconstructed Im, output contains the dictionary
                psnr_Xr = PSNR(Xr - X);
                Dict = output.D;
                DictSize = K;
                outfile = sprintf('%s/sigma%d_dict%d.mat',char(resultImDir),sigma,DictSize);
                save(outfile,'Dict','Xr','psnr_Xr','psnr_noisy','DictSize');

            end
        end
    end
end

