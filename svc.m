function [Kernel, W, L, alpha, theta, SV, BSV, outlier] = svc(X, c)

[Kernel, W, L] = get_K(X);
[alpha, SV, BSV, outlier] = solve_d(Kernel, c);
if(length(BSV) >= 1)
    theta = Kernel(1, 1) - alpha' * Kernel(:, BSV(1));
else
    temp = min(alpha(SV));
    index = find(alpha == temp);
    theta = Kernel(1, 1) - alpha' * Kernel(:, index(1));
end

end

