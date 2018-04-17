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
        load(fullfile(imageDir,curData),'I7');
        X = I7
        outfile = sprintf('%s/%s/%s.mat',root,Dataset,curName);
        save(outfile,'X');	
	end
end
