root            =   '/mnt/spinner/yuqi/imageDataset';
Dataset 	=	'kodak';
format          =   '.mat';
datatype        =   '*.mat';
NoiseLevelList 	=	[5, 10, 15, 25, 50];

method_list = {'ksvd','dct','old'};
full_name_list = {'K-SVD', 'Discrete Cosine Transform','Online Dictionary Learning'};
K_list = [256, 256, 256]; 
bb = 8;

addpath('KSVD_Matlab_ToolBox');
sigma = 25; 
for i = 1:length(method_list)
	method = char(method_list(i))
	dir1 = fullfile(root,strcat(Dataset,'_',method),'kodim01');
	K = K_list(i);
	load(fullfile(dir1,sprintf('sigma%d_dict%d',sigma,K)), 'Dict');
	if size(Dict, 1) ~= bb^2
		Dict = Dict';
	end
	figure;
	set(gcf,'PaperUnits','inches','PaperPosition',[0 0 11 11])
	I = displayDictionaryElementsAsImage(Dict, floor(sqrt(K)), floor(size(Dict,2)/floor(sqrt(K))),bb,bb);
	title(sprintf('The dictionary trained by %s', char(full_name_list(i))));
	print(sprintf('figures/Dict_%s',method), '-dpng','-r400');
end
