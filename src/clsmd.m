% Implenetation of CLSMD
function [ Lout, Sout, err ] = clsmd( M, params)
t = 1;
r = params.r; T = params.T; eps = params.eps; t_max = params.t_max;
n = size(M,1);
k = size(M,2);
Y = M;
S = zeros(n,k);
while(1)
    [U,D,V] = svd(Y);
    diagD = diag(D);
    %L = U(:,1:r)*diag(diagS(1:r))*V(:,1:r)';
    L = U(:,1:r)*diag(diagD(1:r))*V(:,1:r)';
    X = Y - L + S;
    
    S = X.*(X>T);
    err(t) = norm(M-L-S,'fro')/norm(M,'fro');
    if  err(t) < eps || t == t_max
        break;
    end
    Y = L + X - S;
    t = t + 1;
end

Lout = L;
Sout = S;

end