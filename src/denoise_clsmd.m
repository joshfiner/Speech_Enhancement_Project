addpath(genpath('Data'));
addpath(genpath('functions'));
filename = 'sp10_street';
[nsig,Fs] = audioread([filename,'_sn0.wav']);
csig = audioread(['sp10','.wav']);
soundsc(nsig,Fs)
wavlength = length(nsig);

params.nfft = 1024;
params.win = 300;
params.hop = 180;
params.eps = 1e-4;
params.t_max = 100;
params.T = .2;
params.r = 1;

D = stft(nsig,params.nfft,params.win,params.hop,Fs);
% size(D)
Phase = angle(D);
%D_filtered = median_filt(abs(D),3);
%D_filtered = abs(D);
%D_filtered .*exp(1i*Phase)
% figure;
% printim(D,params.nfft,params.hop,Fs)
% figure;
% printim(D_filtered,params.nfft,params.hop,Fs)

[L,S,err] = clsmd(abs(D),params);

rank(L)

% figure;
% printim(D1,params.nfft,params.hop,Fs)
% figure;
% printim(L1,params.nfft,params.hop,Fs)
% figure;
% printim(S1,params.nfft,params.hop,Fs)

figure;
subplot(131)
printim(abs(D),params.nfft,params.hop,Fs,'Y')
subplot(132)
printim(abs(L),params.nfft,params.hop,Fs,'L')
subplot(133)
printim(abs(S),params.nfft,params.hop,Fs,'S')
figure;
plot(err)
% %%
% figure(1);
% subplot(231)
% printim(abs(D1),params.nfft,params.hop,Fs,'Y')
% subplot(232)
% printim(abs(L1),params.nfft,params.hop,Fs,'L')
% subplot(233)
% printim(abs(S1),params.nfft,params.hop,Fs,'S')
% 
% subplot(234)
% printim(abs(D2),params.nfft,params.hop,Fs)
% subplot(235)
% printim(abs(L2),params.nfft,params.hop,Fs)
% subplot(236)
% printim(abs(S2),params.nfft,params.hop,Fs)
% saveas(figure(1),'CLSMD.png'); 

% %%
% figure(1);
% printim(D,params.nfft,params.hop,Fs)
% saveas(figure(1),'D.png'); 
% figure(2);
% printim(L,params.nfft,params.hop,Fs)
% saveas(figure(2),'L.png'); 
% figure(3);
% printim(S,params.nfft,params.hop,Fs)
% saveas(figure(3),'S.png'); 

% Reconstruct Signal
[wavL, wavS] = rec(L.*exp(1i.*Phase),S.*exp(1i.*Phase),params);
% soundsc(nsig,Fs)
% pause(wavlength/Fs)
% soundsc(wavS,Fs)
% pause(wavlength/Fs)
% soundsc(csig,Fs)

% Binary Masking
gain = 5;
Mask = S>gain*L;
S2 = Mask.*S;

figure(1);
subplot(121)
printim(S,params.nfft,params.hop,Fs,'No Mask')
subplot(122)
printim(S2,params.nfft,params.hop,Fs,'Mask')
saveas(figure(1),'BM.png'); 
% figure(1);
% printim(S,params.nfft,params.hop,Fs)
% saveas(figure(1),'NoBM.png'); 
% figure(2);
% printim(S2,params.nfft,params.hop,Fs)
% saveas(figure(2),'BM.png'); 

[~, wavS2] = rec(L.*exp(1i.*Phase),S2.*exp(1i.*Phase),params);
% soundsc(wavS,Fs)
% pause(wavlength/Fs)
% soundsc(wavS2,Fs)
% pause(wavlength/Fs)

% [bl,al] = ellip(10, 3, 80, [2000]/(Fs/2));
% sigf = filter(bl,al,wavS);
% sigf2 = filter(bl,al,wavS2);

% soundsc(nsig,Fs)
% pause(wavlength/Fs)
% soundsc(sigf,Fs)
% pause(wavlength/Fs)
% soundsc(sigf2,Fs)
% pause(wavlength/Fs)

%%
% Plot signals
figure(1);
subplot(311);
plot((1:length(csig))/Fs,csig);
ylim([-.5 .5])
subplot(312);
plot((1:length(wavS))/Fs,wavS./max(abs(wavS)));
ylim([-.5 .5])
subplot(313);
plot((1:length(wavS2))/Fs,wavS2./max(abs(wavS2)));
ylim([-.5 .5])
saveas(figure(1),'signals.png'); 