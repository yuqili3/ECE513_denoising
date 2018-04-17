root            =   '/mnt/spinner/yuqi/imageDataset';
DatasetList 	=	{'kodak'};
format          =   '.mat';
datatype        =   '*.mat';

bb=8; % block size
RRList = [1, 2, 4, 8]; % redundancy factor

for idxR = 1: length(RRList)
	RR = RRList(idxR);
	dictSize=RR*bb^2; % number of atoms in the dictionary
end

