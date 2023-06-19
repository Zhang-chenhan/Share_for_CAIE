function [] = Plot_clustered_data_svc(Clustered_data, k)

    dim = size(Clustered_data, 2) - 1;
    color = [231 135 125;
             248 213 129;
             138 202 223;
             245 198 226;
             193 169 162;
             192 198 131;
             142 131 204
             92  158 173
             210 204 161
             71  51  53 ]./255;
    if dim == 2
        for i_for = 1 : k
            idx = find(Clustered_data(:, end) == i_for);

            plot(Clustered_data(idx, 1), Clustered_data(idx, 2),...
                ['w', 'o'], 'MarkerSize',  5, 'MarkerFacecolor', color(i_for,:), 'LineWidth', 1.5);
            hold on;
        end
    end
end