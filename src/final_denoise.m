%% Code to perform the experimental analysis on the NOIZEUS dataset using the CLSMD approach
% Authors : Sarat Chandra Vysyaraju (scv2114)
%           Joshua Finer (jf2904)
% Course : Sparse Represnetation on High Dimension Geometry

%% 
addpath(genpath(pwd));                          %Adding the paths of all files in current directory
% Generating the list of types of noise 
strs=['street';'restaurant';'exhibition';'babble';'car';'airport';'train'];
cellstrs = cellstr(strs);
%%
for p=1:7                                       % Looping over each type of noise
    for i=1:30                                  % Looping for each speech sentence 
        if i<=9                                 % Generating the file names
            filename = ['sp0' num2str(i) '_' cellstrs{p}];
            csig = wavread(['sp0' num2str(i) '.wav']);
        else
            filename = ['sp' num2str(i) '_'  cellstrs{p}];
            csig = wavread(['sp' num2str(i) '.wav']);
        end
        for j=0:5:15                            %Looping over avrious levels of noise (in dB)
            [nsig,Fs] = wavread([filename '_sn' num2str(j) '.wav']);
            params.nfft = 1024;                 %Establishing the parameter set
            params.win = 300;
            params.hop = 180;
            params.eps = 1e-4;
            params.t_max = 100;
            for k=1:2                           %Looping over the low-rank constraints of r=1,2
                params.r = k;
                count=1;
                for l=0.1:0.1:1                 %Looping over the sparsity constraint t from 0.1 to 1
                    params.T = l;
                    D = stft(nsig,params.nfft,params.win,params.hop,Fs);        %Generating the STFT of noisy signal
                    Phase = angle(D);                                           %Phase information of the noisy signal
                    % Performing the CLSMD on the magnitude spectrum of noisy speech signal
                    [L,S,err] = clsmd(abs(D),params);                           
                    Mag = abs(D);
                    %%
                    % Performing Binary Masking on the reconstructed speech
                    gain = 5;                                                   % Gain of Binary Masking
                    Mask = S>gain*L;
                    S2 = Mask.*S;
                    [wavL, wavS] = rec(L.*exp(1i.*Phase),S.*exp(1i.*Phase),params);
                    [m,n]=size(wavS);
                    
                    %Calculating the segSNR and PESQ measures
                    ssnrw(i,ceil((j+1)/5),k,count)=segsnr(csig(1:n,1)',wavS,8000);
                    pesqw(i,ceil((j+1)/5),k,count)=pesq(csig(1:n,1)',wavS,8000);
                    [wavL, wavS2] = rec(L.*exp(1i.*Phase),S2.*exp(1i.*Phase),params);
                    ssnrb(i,ceil((j+1)/5),k,count)=segsnr(csig(1:n,1)',wavS2,8000);
                    pesqb(i,ceil((j+1)/5),k,count)=pesq(csig(1:n,1)',wavS2,8000);
                    count=count+1;
                end
            end
        end
    end
save(['Data_' cellstrs{p} '.mat'],'ssnrw','ssnrb','pesqw','pesqb');     %Saving the dataset
end