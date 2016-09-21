% Takes as input two spectrograms L and S and parameters and synthesises
% the separated waveforms using istft 
function [ wavL, wavS ] = rec( L, S, params )
    nfft = params.nfft;
    win = params.win;
    hop = params.hop;
    wavL = istft(L, nfft ,win, hop);   
    wavS = istft(S, nfft ,win, hop);
end

