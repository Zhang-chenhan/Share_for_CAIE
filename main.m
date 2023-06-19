% "Optimal Scheduling of Ethylene Plants under Uncertainty: An Unsupervised Learning-based Data-Driven Strategy"
% submitted to "Computers & Industrial Engineering"

% Share for CAIE
% Three-level data mining + uncertainty set construction
clc;clear;close all;

% uncertain data
load 'test_data.mat'; 
[dim_m,dim_n] = size(data);

%========================================================
%            Step 1：Canopy
%========================================================
kk = zeros(dim_m,1);
for t = 1:dim_m
    D = pdist(data);
    mean_D = sum(D) / size(D,2);
    T2 = 2 * mean_D;    
    
    K_max = 20;
    kk(t) = 0;
    YB = [data zeros(dim_m,1)]; 
    Centr = zeros(K_max,dim_n);
    while size(YB,1) && (kk(t) < K_max)
        kk(t) = kk(t) + 1;
        Centr(kk(t),:) = YB(1,1:dim_n);
        YB(1,:) = [];          
        L = size(YB,1);
        if L
            dist1 = (YB(:,1:dim_n) - ones(L,1) * Centr(kk(t),1:dim_n)).^2;  
            dist2 = sum(sqrt(dist1),2);   
        end
        for i = 1:L-1
            if(dist2(i) < T2)   
               YB(i,dim_n+1) = 1;
            end
        end
        YB(YB(:,dim_n+1) == 1,:) = [];    
    end
end

result_canopy = tabulate(kk(:))
[M,I] = max(result_canopy(:,end));

%========================================================
%           Step 2：K-means ++
%========================================================
k_km = I;                  
iterations = 50;           

[idx_km,mean_km,sumd_km,D_km] = kmeans(data(:, 1 : end), k_km,...
    'distance', 'sqeuclidean', 'maxIter', iterations);
Clustered_data_km = [data(:, 1 : end) idx_km];

figure(1);
Plot_clustered_data(Clustered_data_km, k_km, mean_km);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Center');
xlabel('\it t_{U1}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman'); 
ylabel('\it t_{U2}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman');
title('Stage 1 Clustering (K-means ++)', 'FontSize', 15, 'FontName', 'Times New Roman');
grid on

[Sorted_data,Sorted_split_data] = Sorted_clustered_data(Clustered_data_km, k_km);

%========================================================
%           Elbow rule
%========================================================
for k = 2:8
    rng(100);
    [lable,c,sumd,d] = kmeans(data,k,'dist','sqeuclidean');
    sse1 = sum(sumd.^2);
    D(k,1) = k;
    D(k,2) = sse1;
end

for i = 1:k_km
    Num_clusters(i) = sum(idx_km == i); 
    sumd_mean_km(i) = sumd_km(i) / Num_clusters(i); 
end

D_clusters = cell(1,k_km);
for j = 1:k_km
    temp = [];
    temp_out = 0;
    for i = 1:size(data,1)
        if idx_km(i,:) == j
            temp = [temp D_km(i,j)];
            if D_km(i,j) >= sumd_mean_km(j)
                temp_out = temp_out + 1;
            end
        end
    end
    D_clusters{1,j} = temp;
    Num_outliers(j) = temp_out;
end

Pro_out = Num_outliers ./ Num_clusters;

%========================================================
%           Step 3：K-means ++
%========================================================
Clustered_data_cell = cell(1,k_km);
mean_km_2 = [];
Clustered_data_km_2 = [];
k_km_2 = 0;                          

for i = 1:k_km
    k = 2;                    
    iterations_2 = 50;        
    [idx, mu]  = kmeans(Sorted_split_data{1,i}, k,...
    'distance', 'sqeuclidean', 'maxIter', iterations_2);
    Clustered_data_cell{1,i} = [Sorted_split_data{1,i} idx];
    indexed_data = cell(1,k);
    for j = 1:k
        test_data = Clustered_data_cell{1,i};
        id = find(idx == j);
        indexed_2 = test_data(id,1:end-1);
        k_km_2 = k_km_2 + 1;    
        indexed_data{1,j} = [indexed_2 k_km_2*ones(size(indexed_2,1),1)];
    end
    mean_km_2 = [mean_km_2;mu];
    Clustered_data_km_2 = [Clustered_data_km_2;indexed_data{1,1};indexed_data{1,2}];
end

figure(2);
Plot_clustered_data(Clustered_data_km_2, k_km_2, mean_km_2);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6','Cluster 7','Cluster 8','Center');
xlabel('\it t_{U1}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman'); 
ylabel('\it t_{U2}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman');
title('Stage 2 Clustering (K-means ++)', 'FontSize', 15, 'FontName', 'Times New Roman');
grid on

[~,Sorted_split_data_2] = Sorted_clustered_data(Clustered_data_km_2, k_km_2);
for i = 1:k_km_2
    Proportion(i) = size(Sorted_split_data_2{1,i},1) / dim_m;
end

%================================================
%          uncertainty set
%================================================
figure(3);
Plot_clustered_data_svc(Clustered_data_km_2, k_km_2);
hold on;
grid on

Kernel = cell(1,k_km_2);
W = cell(1,k_km_2);
L = cell(1,k_km_2);
alpha = cell(1,k_km_2);
theta = cell(1,k_km_2);
SV = cell(1,k_km_2);
BSV = cell(1,k_km_2);
outlier = cell(1,k_km_2);

for i = 1:k_km_2
    sum_N(i) = size(Sorted_split_data_2{1,i},1);  
    if mean_km_2(i,1) <= 36.8 && mean_km_2(i,1) >= 33.5
        v = 0.015;
        C(i) = 1 / (sum_N(i) * v);  
    else
        v = 0.22;
        C(i) = 1 / (sum_N(i) * v);  
    end
end

for i = 1:k_km_2
    data_svc = Sorted_split_data_2{1,i};
    [Kernel{1,i}, W{1,i}, L{1,i}, alpha{1,i}, theta{1,i}, SV{1,i}, BSV{1,i}, outlier{1,i}] = svc(data_svc', C(i));
end

Plot_uncertainty_set(Sorted_split_data_2, k_km_2, BSV, Kernel, L, alpha, W);
xlabel('\it t_{U1}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman'); 
ylabel('\it t_{U2}(\xi)', 'FontSize', 15, 'FontName', 'Times New Roman');
title('Uncertainty Sets', 'FontSize', 15, 'FontName', 'Times New Roman');
    