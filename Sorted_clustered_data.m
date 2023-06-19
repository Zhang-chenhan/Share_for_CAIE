function [Sorted_data,Sorted_split_data] = Sorted_clustered_data(Clustered_data, k)

Sorted_data = zeros(size(Clustered_data,1),size(Clustered_data,2));
num = 0;
for j = 1:k
    for i = 1:size(Clustered_data,1)
        if Clustered_data(i,end) == j
            num = num+1;
            Sorted_data(num,:) = Clustered_data(i,:);
        end
    end
end

Sorted_split_data = cell(1,k);
for j = 1:k
    temp = [];
    for i = 1:size(Sorted_data,1)
        if Sorted_data(i,end) == j
            temp = [temp;Sorted_data(i,1:2)];
        end
    end
    Sorted_split_data{1,j} = temp;
end

end