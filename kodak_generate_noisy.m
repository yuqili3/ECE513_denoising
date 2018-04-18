root            =   '/mnt/spinner/yuqi/imageDataset';
DatasetList 	=	{'kodak'};
format          =   '.png';
datatype        =   '*.png';

NoiseLevelList 	=	[5, 10, 15, 25, 50];

for idxDS = 1:length(DatasetList)
	Dataset = char(DatasetList(idxDS));
	imageDir = fullfile(root,Dataset);
	imList = dir(fullfile(imageDir, '*.mat'));
	numImage = numel(imList);
	for idxImage = 1:numImage
		curData     =   imList(idxImage).name;
                curName     =   curData(1:end - length('.mat'));
                % load(fullfile(imageDir,curData),'I7');
                % X = I7;
                % save(char(fullfile(imageDir,curData)),'X');

                load(fullfile(imageDir,curData),'X');
                noisyDir = fullfile(imageDir,curName);
                mkdir(noisyDir)
                for i = 1:length(NoiseLevelList)
                	sigma = NoiseLevelList(i);
                	% generate .mat
                	noisy = X + sigma*randn(size(X));
                	psnr_noisy = PSNR(noisy-X);
                	outfile = sprintf('%s/sigma%d.mat', char(noisyDir),sigma);
                	save(outfile,'noisy','psnr_noisy');

                	% generate .png
                	noisyPngDir = fullfile(imageDir,sprintf('noisy_sigma%d',sigma));
                	if ~exist(noisyPngDir,'dir')
                		mkdir(noisyPngDir);
                	end
                	outfile = sprintf('%s/%s_sigma%d.png',noisyPngDir,curName,sigma);
                	imwrite(uint8(noisy), outfile);
                end
	end
end
