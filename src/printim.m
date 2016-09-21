function  printim( S ,nFFT,hop,sr,s)
tt = [0:size(S,2)]*hop/sr;
ff = [0:size(S,1)]*sr/nFFT;
imagesc(tt,ff,20*log10(abs(S)));
if nargin > 4
title(s,'fontsize',15,'FontName','Calibri')
end
axis('xy');
xlabel('time / sec');
ylabel('freq / Hz')
end

