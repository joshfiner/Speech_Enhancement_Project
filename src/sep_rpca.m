% Separates a signal spectrogram D into low rank and sparse components
% using the alm-rpca method. Output is magnitude of S and L
function [ Lout, Sout ] = sep_rpca( D, params,method)
    %[K,N] = size(D); 
    lambda = params.lambda;
    if method == 'alm'
        [L_mag S_mag] = inexact_alm_rpca(abs(D),lambda/sqrt(max(size(D))));
    elseif method == 'apg'
        [L_mag S_mag] = partial_proximal_gradient_rpca(abs(D),lambda/sqrt(max(size(D))));
    end
    err = norm(abs(D)-L_mag-S_mag,'fro');
    
    %Sout = S_mag;
    %Lout = L_mag;
    PHASE = angle(D);
    Lout = L_mag.*exp(1i.*PHASE);
    Sout = S_mag.*exp(1i.*PHASE);
end

