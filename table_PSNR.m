resultDir		= 	'/home/yuqi/Documents/ECE513_denoising/';

methodList = {'dct','ksvd','utl','old'};
Name_list = {'DCT','KSVD','UTL','ODL'};
DatabaseList = {'kodak'};   
NoiseList = [5, 10, 15, 25, 50];


% here is a latex table of just results
for idxDS = 1:numel(DatabaseList)
	Database = char(DatabaseList(idxDS));
	fprintf('Database: %s\n',Database);
	% generate latex ready table, 4 cols, 15 rows
	for k = 1:numel(NoiseList)
		sigma = NoiseList(k);
		fprintf(' & $\\sigma$ =%d ',NoiseList(k));
	end
	fprintf('\\\\ \n'); % change line sign

	for i = 1:numel(methodList)
		method1 = char(methodList(i));
		
		inFile = sprintf('%s_PSNR_%s.mat',Database,method1);
		load(inFile,'PSNR_noisy', 'PSNR_rec');
		psnr = mean(PSNR_noisy,1);
		if i == 1
			fprintf('Noisy ');
			psnr = mean(PSNR_noisy, 1);
			for k = 1:numel(NoiseList)
				fprintf('& %.2f ',psnr(k));
			end
			fprintf('\\\\ \n'); % change line sign
		end
		diff1 = PSNR_rec - PSNR_noisy;
		psnr = mean(PSNR_rec, 1);
		std_psnr = std(PSNR_rec, 0, 1);

		% generate latex ready table, 4 cols, 15 rows
		fprintf('%s ',char(Name_list(i)));
		for k = 1:numel(NoiseList)
			fprintf('& %.2f $\\pm$ %.2f ',psnr(k),std_psnr(k));
		end
		fprintf('\\\\ \n'); % change line sign
	end
end


%{
methodPairList = {'octobos','saist','ksvd','octobos','gsm','octobos','gsm','saist'};
DatabaseList = {'kodak'};
NoiseList = [5, 10, 15, 25];

for idxDS = 1:numel(DatabaseList)
	Database = char(DatabaseList(idxDS));
	fprintf('Database: %s\n',Database);
	for k = 1:numel(NoiseList)
		sigma = NoiseList(k);
		fprintf(' & $\\sigma$ =%d ',NoiseList(k));
	end
	fprintf('\\\\ \n'); % change line sign
	for i = 1: numel(methodPairList)/2
		m1 = char(methodPairList(2*i-1));
		m2 = char(methodPairList(2*i));
		inFile = sprintf('%s/result/%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,m1,m2);
		load(inFile,'psnrOut','lambdaList');
		peak_psnr = squeeze(max(psnrOut,[], 3));
		max_of_2_method = squeeze(max(psnrOut(:,:,1), psnrOut(:,:,end)));

		fprintf('%s ',m1);
		for k = 1:numel(NoiseList)
			% fprintf(' & %.2f \\pm %.2f', mean(psnrOut(:,k,end)), std(psnrOut(:,k,end)));
			fprintf(' & %.2f ', mean(psnrOut(:,k,end)));
		end
		fprintf('\\\\ \n'); % change line sign

		fprintf('%s ',m2);
		for k = 1:numel(NoiseList)
			% fprintf(' & %.2f \\pm %.2f', mean(psnrOut(:,k,1)), std(psnrOut(:,k,1)));
			fprintf(' & %.2f ', mean(psnrOut(:,k,1)) );
		end
		fprintf('\\\\ \n'); % change line sign

		fprintf('%s + %s ',m1,m2);
		for k = 1:numel(NoiseList)
			% fprintf(' & %.2f \\pm %.2f', mean(peak_psnr(:,k)), std(peak_psnr(:,k)));
			fprintf(' & %.2f ', mean(peak_psnr(:,k)) );
		end
		fprintf('\\\\ \n'); % change line sign

		fprintf('$\\Delta$ PSNR');
		for k = 1:numel(NoiseList)
			fprintf(' & %.2f ', mean(peak_psnr(:,k)-max_of_2_method(:,k)));
		end
		fprintf('\\\\ \n'); % change line sign

		fprintf('$\\Delta$ PSNR std');
		for k = 1:numel(NoiseList)
			fprintf(' & %.2f ',std(peak_psnr(:,k)-max_of_2_method(:,k)));
		end
		fprintf('\\\\ \n'); % change line sign

		fprintf('\\\\ \n'); % change line sign
	end
end
%}

%{
% the best lambda given the truth OR the fixed lambda at 0.5
m1 = 'dncnn';
% m2List = {'ksvd','gsm','wnnm'};
% DatabaseList = {'kodak'};
% NoiseList = [5, 10, 15, 25, 50];
% noise_start_idx  = 3

m2List = {'ksvd','gsm','wnnm'};
% DatabaseList = {'urban100_LRseed','urban100_SRF2seed'};
DatabaseList = {'urban100_SRF2seed'};
NoiseList = [30, 50, 70];
noise_start_idx = 1;

for idxDS = 1:numel(DatabaseList)
	Database = char(DatabaseList(idxDS));
	fprintf('Database: %s\n',Database);
	for k = noise_start_idx:numel(NoiseList)
		sigma = NoiseList(k);
		fprintf(' & $\\sigma$ =%d ',NoiseList(k));
	end
	fprintf(' & $\\Delta $ PSNR');
	fprintf('\\\\ \n'); % change line sign



	for i = 1:length(m2List)
		m2 = char(m2List(i));
		inFile = sprintf('%s/result/%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,m1,m2);
		load(inFile,'psnrOut','lambdaList');
		if i == 1
			fprintf('%s ',m1);
			for k = noise_start_idx:numel(NoiseList)
				fprintf(' & %.2f ', mean(psnrOut(:,k,end)));
			end
			A = mean(mean(psnrOut(:,noise_start_idx:end,end)));
			fprintf('& %.2f', A -A);
			fprintf('\\\\ \n'); % change line sign
		end
		fixed_lambda_psnr = psnrOut(:,:,6); % fixed lambda at 0.5
		peak_psnr = squeeze(max(psnrOut,[], 3));
		max_of_2_method = squeeze(max(psnrOut(:,:,1), psnrOut(:,:,end)));
		fprintf('%s + %s ',m1,m2);
		for k = noise_start_idx:numel(NoiseList)
			fprintf(' & %.2f ', mean(peak_psnr(:,k)));
			% fprintf(' & %.2f ', mean(fixed_lambda_psnr(:,k)));
		end
		fprintf('& %.2f', mean(mean(peak_psnr(:,noise_start_idx:end))) -A);
		 % fprintf('& %.2f', mean(mean(fixed_lambda_psnr(:,noise_start_idx:end))) -A)
		fprintf('\\\\ \n'); % change line sign	
	end

	methodList = {'dncnn','gsm','wnnm'};
	method1 = char(methodList(1));
	method2 = char(methodList(2));
	method3 = char(methodList(3));
	inFile = sprintf('%s/result/%s_%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,method1,method2,method3);
	load(inFile,'psnrOut');
	B = reshape(psnrOut,100,3,[]);
	C = max(B, [], 3);
	fprintf('%s + %s + %s',method1,method2,method3);
	for k = noise_start_idx:numel(NoiseList)
		fprintf(' & %.2f ', mean(C(:,k)));
	end
	fprintf( '& %.2f', mean(C(:))-A);
	fprintf('\\\\ \n'); % change line sign	

	methodList = {'dncnn','ksvd','gsm'};
	method1 = char(methodList(1));
	method2 = char(methodList(2));
	method3 = char(methodList(3));
	inFile = sprintf('%s/result/%s_%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,method1,method2,method3);
	load(inFile,'psnrOut');
	B = reshape(psnrOut,100,3,[]);
	C = max(B, [], 3);
	fprintf('%s + %s + %s',method1,method2,method3);
	for k = noise_start_idx:numel(NoiseList)
		fprintf(' & %.2f ', mean(C(:,k)));
	end
	fprintf( '& %.2f', mean(C(:))-A);
	fprintf('\\\\ \n'); % change line sign	

	methodList = {'dncnn','ksvd','wnnm'};
	method1 = char(methodList(1));
	method2 = char(methodList(2));
	method3 = char(methodList(3));
	inFile = sprintf('%s/result/%s_%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,method1,method2,method3);
	load(inFile,'psnrOut');
	B = reshape(psnrOut,100,3,[]);
	C = max(B, [], 3);
	fprintf('%s + %s + %s',method1,method2,method3);
	for k = noise_start_idx:numel(NoiseList)
		fprintf(' & %.2f ', mean(C(:,k)));
	end
	fprintf( '& %.2f', mean(C(:))-A);
	fprintf('\\\\ \n'); % change line sign

end
%}


% adaptive lambda 
%{
m1 = 'dncnn';
m2List = {'ksvd','gsm','wnnm'};
% DatabaseList = {'urban100_LRseed','urban100_SRF2seed'};
DatabaseList = {'urban100_SRF2seed'};
NoiseList = [30, 50, 70];
noise_start_idx = 1;

for idxDS = 1:numel(DatabaseList)
	Database = char(DatabaseList(idxDS));
	fprintf('Database: %s\n',Database);
	for k = noise_start_idx:numel(NoiseList)
		sigma = NoiseList(k);
		fprintf(' & $\\sigma$ =%d ',NoiseList(k));
	end
	fprintf(' & $\\Delta $ PSNR');
	fprintf('\\\\ \n'); % change line sign

	i = 1;
	m2 = char(m2List(i));
	inFile = sprintf('%s/result/%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,m1,m2);
	load(inFile,'psnrOut','lambdaList');
	fprintf('%s ',m1);
	for k = noise_start_idx:numel(NoiseList)
		fprintf(' & %.2f ', mean(psnrOut(:,k,end)));
	end
	A = mean(mean(psnrOut(:,noise_start_idx:end,end)));
	fprintf('& %.2f', A -A);
	fprintf('\\\\ \n'); % change line sign

	for i = 1:length(m2List)
		m2 = char(m2List(i));
		inFile = sprintf('%s/result/%s_%s_%s_fidelity_comb_PSNR.mat',resultDir,Database,m1,m2);
		load(inFile,'psnrOut');
		peak_psnr = squeeze(max(psnrOut,[], 3));
		max_of_2_method = squeeze(max(psnrOut(:,:,1), psnrOut(:,:,end)));
		fprintf('%s + %s ',m1,m2);

		inFile = sprintf('%s/result/%s_%s_%s_adaptive_comb_PSNR.mat',resultDir,Database,m1,m2);
		load(inFile,'psnrTest','psnrOut','method1','method2','lambda_adaptive');

		for k = noise_start_idx:numel(NoiseList)
			fprintf(' & %.2f ', sum(psnrTest(:,k))/sum(psnrTest(:,k)~=0) );
		end
		fprintf('& %.2f', sum(psnrTest(:))/sum(psnrTest(:)~=0) -A)
		fprintf('\\\\ \n'); % change line sign	
	end
end
%}