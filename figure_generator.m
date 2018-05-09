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
sigma = 15; 
% figure;
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 11 11])	
for i = 1:length(method_list)
	method = char(method_list(i))
	dir1 = fullfile(root,strcat(Dataset,'_',method),'kodim03');
	K = K_list(i);
	load(fullfile(dir1,sprintf('sigma%d_dict%d',sigma,K)), 'Dict');
	if size(Dict, 1) ~= bb^2
		Dict = Dict';
	end
	I1 = displayDictionaryElementsAsImage(Dict, floor(sqrt(K)), floor(size(Dict,2)/floor(sqrt(K))),bb,bb,0);
	% title(sprintf('The dictionary trained by %s', char(full_name_list(i))));
	imwrite(I1,sprintf('figures/Dict_%s.jpg',method))
end
% print(sprintf('figures/Dict_%s',method), '-dpng','-r400');



%{
method_list = {'ksvd','dct','old','utl'};
idxSigma = 3;
sigma = NoiseLevelList(idxSigma);
load('kodim03.mat','X');
imwrite(uint8(X), sprintf('figures/kodim03_truth.jpg'))
load(sprintf('kodim03_sigma%d.mat',sigma),'noisy','psnr_noisy')
imwrite(uint8(noisy), sprintf('figures/kodim03_noise_%.0f.jpg',psnr_noisy*100))
for i = 1:length(method_list)
	method = char(method_list(i))
	load(sprintf('sigma%d_%s.mat',sigma,method),'Xr','psnr_Xr')
	imwrite(uint8(Xr),sprintf('figures/kodim03_rec_%s_%.0f.jpg',method,psnr_Xr*100))
end

method_list = {'ksvd','dct','old','utl'};
idxSigma = 3;
sigma = NoiseLevelList(idxSigma);
pos1 = [150,250, 100,250];
load('kodim03.mat','X');
imwrite(uint8(X(pos1(1):pos1(2), pos1(3):pos1(4))), sprintf('figures/kodim03_truth_pos1.jpg'))
load(sprintf('kodim03_sigma%d.mat',sigma),'noisy','psnr_noisy')
imwrite(uint8(noisy(pos1(1):pos1(2), pos1(3):pos1(4))), sprintf('figures/kodim03_noise_pos1_%.0f.jpg',psnr_noisy*100))
for i = 1:length(method_list)
	method = char(method_list(i))
	load(sprintf('sigma%d_%s.mat',sigma,method),'Xr','psnr_Xr')
	imwrite(uint8(Xr(pos1(1):pos1(2), pos1(3):pos1(4))),sprintf('figures/kodim03_rec_pos1_%s_%.0f.jpg',method,psnr_Xr*100))
end
%}


