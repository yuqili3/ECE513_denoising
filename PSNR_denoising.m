root            =   '/mnt/spinner/yuqi/imageDataset';

DatasetList 	=	{'kodak'};
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList 	=	[5, 10, 15, 25, 50];

method_list = {'ksvd','dct','old','utl'}
K_list = [256, 256, 256, 64]; 



for idxDS = 1:length(DatasetList)
    Dataset = char(DatasetList(idxDS));
	imageDir = fullfile(root,Dataset);
	imList = dir(fullfile(imageDir, '*.mat'));
	numImage = numel(imList);
    for idxMethod = 1:numel(method_list)
        method = char(method_list(idxMethod));
        PSNR_noisy = zeros(24,length(NoiseLevelList));
        PSNR_rec = zeros(24,length(NoiseLevelList));
    	for idxImage = 1:numImage
        	curData     =   imList(idxImage).name;
            curName     =   curData(1:end - length('.mat'));
            resultImDir = fullfile(root,strcat(Dataset,'_',method),curName);
    		for i = 1:length(NoiseLevelList)
                sigma = NoiseLevelList(i);
                load(fullfile(resultImDir,sprintf('sigma%d_dict%d.mat',sigma,K_list(idxMethod))), 'psnr_Xr','psnr_noisy');
                PSNR_noisy(idxImage,i) = psnr_noisy;
                PSNR_rec(idxImage,i) = psnr_Xr;
            end
        end
        outfile = sprintf('%s_PSNR_%s.mat',Dataset,method);
        save(outfile    ,'PSNR_noisy','PSNR_rec');
    end
end


