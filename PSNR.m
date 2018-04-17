function [ psnr ] = PSNR(X)
	psnr = 20*log10(255/sqrt(mean((X(:)).^2)));
end