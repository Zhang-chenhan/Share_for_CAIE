function [Kernel, W, L] = get_K(X)

N = size(X,2);
meanX = mean(X, 2);
Y = X - meanX * ones(1, N);
cov_Mat = Y * Y' / (N - 1);
[U,V,~] = svd(cov_Mat);
W = U * sqrt(inv(V)) * U';

X_norm = W * X;
max_X = max(X_norm');
min_X = min(X_norm');
L = 1e-3 + max_X - min_X;
Kernel = sum(L) * ones(N, N);

for i = 1:N
    for j = (i+1):N
        Kernel(i, j) = Kernel(i, j) - norm(X_norm(:,i) - X_norm(:,j) ,1);
        Kernel(j, i) = Kernel(i, j);
    end
end

end

