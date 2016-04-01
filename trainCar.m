addpath('util')

I = imread('aerial_color.jpg');
subsample_size = 8;
%% subsample I to speed things up (10 pixels for now)
[nr_raw, nc_raw, ~] = size(I);
[I_sampled, I_gray] = SubSample(I, subsample_size);


imshow(I_sampled);
hold on

%% plot all the previous paths
cardir = dir('CarTrainingData/car*.mat');

for i = 1:length(cardir)
    filenamei = strcat('CarTrainingData/', cardir(i).name);
    load(filenamei);
    plot(path(:,1), path(:,2), 'r')
end

%% GUI to choose one reasonable path
temp = ginput(1);
figure(1)
h_path = plot(temp(1), temp(2), 'LineWidth', 3);

wayptX = [];
wayptY = [];

while(~isempty(temp))
    wayptX = [wayptX; temp(1)];
    wayptY = [wayptY; temp(2)];
    set(h_path, 'xdata', wayptX, 'ydata', wayptY);
    temp = ginput(1);
end

%% TraceRay to make path

x_path = [];
y_path = [];

for i = 1:(length(wayptX)-1)
    x_start = ceil((wayptX(i)));
    y_start = ceil((wayptY(i)));
    x_end = ceil((wayptX(i+1)));
    y_end = ceil((wayptY(i+1)));
    [x_cell_temp, y_cell_temp] = getMapCellsFromRay(x_start, y_start, x_end, y_end);
    dist2start = (x_cell_temp(1) - x_start)^2 + (y_cell_temp(1) - y_start)^2;
    dist2end = (x_cell_temp(1) - x_end)^2 + (y_cell_temp(1) - y_end)^2;
    
    if dist2end < dist2start
        x_cell_temp = x_cell_temp(end:-1:1);
        y_cell_temp = y_cell_temp(end:-1:1);
    end
    x_path= [x_path; x_cell_temp];
    y_path= [y_path; y_cell_temp];  
end

path = [x_path, y_path];

for i = 1:length(x_path)
    plot(path(i, 1), path(i, 2), 'r.');
    pause(0.001)
end


%% save it in a file
filename = strcat('car', datestr(now, 'HHMMSSddmmyy'), '.mat');
save(strcat('CarTrainingData/', filename), 'path')