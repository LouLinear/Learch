addpath('util')

I = imread('aerial_color.jpg');
subsample_size = 8;
%% subsample I to speed things up (10 pixels for now)
[nr_raw, nc_raw, ~] = size(I);
[I_sampled, I_gray] = SubSample(I, subsample_size);
imshow(I_sampled);
[nr, nc, ~] = size(I_sampled);
hold on

%% feature extraction
feature_num = 5;
f = zeros(nr, nc, feature_num);
w = zeros(feature_num, 1);
ycbcrmap = rgb2ycbcr(I_sampled);
f(:, :, 1) = ycbcrmap(:, :, 2)./256;
f(:, :, 2) = ycbcrmap(:, :, 3)./256;
hsvmap = rgb2hsv(I_sampled);
f(:, :, 3) = hsvmap(:, :, 1);
f(:, :, 4) = hsvmap(:, :, 2);
f(:, :, 5) = hsvmap(:, :, 3);

%% gradient descent 
cardir = dir('CarTrainingData/car*.mat');
ada = 1e-2/feature_num;

paths = cell(length(cardir),1);
h_dij = cell(length(cardir),1);
%h_dij = cell(1);
%paths = cell(1);

for i = 1:length(cardir)
    filenamei = strcat('CarTrainingData/', cardir(i).name);
    load(filenamei);
    h_dij{i} = plot(0, 0, 'b');
    paths{i} = path;
    plot(path(:,1), path(:,2), 'r')
end

while(1)
    g = zeros(feature_num, 1);
    %calculate cost map
    w3 = reshape(w, 1, 1, feature_num);
    costmap = sum(bsxfun(@times, f, w3), 3);
    costmap = exp(costmap);
    %calculate gradient
    for path_i = 1:numel(paths)
        
        path = paths{path_i};
        start = [path(1, 2), path(1, 1)];
        goal = [path(end, 2), path(end, 1)];
        ctg = dijkstra_matrix(costmap, goal(1), goal(2));
        [r_dij, c_dij] = dijkstra_path(ctg, costmap, start(1), start(2));
        set(h_dij{path_i}, 'xdata', c_dij, 'ydata', r_dij)
        dij_ind = sub2ind([nr, nc], r_dij, c_dij);
        path_ind = sub2ind([nr, nc], path(:, 2), path(:, 1));
        
        for g_i = 1:feature_num
            
            f_i = f(:, :, g_i);
            newgrad = (sum(f_i(path_ind).*costmap(path_ind)) - sum(f_i(dij_ind).*costmap(dij_ind)));
            g(g_i) = g(g_i) + newgrad;
            
        end
    end
    w = w - ada*g;
end