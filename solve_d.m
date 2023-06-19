function [alpha, SV, BSV, outlier] = solve_d(ker, c)

N = size(ker,2);
e = c * 1e-5;

cvx_solver gurobi
cvx_begin
    cvx_precision best
    variable alpha1(N)
    minimize(alpha1' * ker * alpha1);
    subject to
        0 <= alpha1 <= c;
        sum(alpha1) == 1;
cvx_end

alpha = alpha1;
SV = find(alpha >= e); 
BSV = find(alpha >= e & alpha <= c - e);
outlier = find(alpha >= c - e);
end

