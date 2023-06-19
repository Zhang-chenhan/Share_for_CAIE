function [] = Plot_uncertainty_set(Sorted_split_data_2, k_km_2, BSVindex, KernelMat, L, alpha, W)

    for i = 1:k_km_2
        data_svc = Sorted_split_data_2{1,i};
        
        BSV_value = BSVindex{1,i};
        Kernel_value = KernelMat{1,i};
        R(i) = sqrt(sum(L{1,i}) - 2 * Kernel_value(BSV_value(1),:) * alpha{1,i} + alpha{1,i}' * Kernel_value * alpha{1,i});

        syms m n 
        var = 0;
        plotdata = [m,n];
        for r = 1:size(data_svc,1)
            alpha_test = alpha{1,i};
            var = var + alpha_test(r) * (sum(L{1,i}) - norm(W{1,i} * (plotdata - data_svc(r,:))',1));
        end
        fun = R(i)^2 - sum(L{1,i}) + 2 * var - alpha{1,i}' * Kernel_value * alpha{1,i};
        hold on
        h = ezplot(fun,[-100,100]);
        set(h, 'LineWidth', 1.2);
    end
end