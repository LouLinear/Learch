I = imread('aerial_color.jpg');
%% subsample I to speed things up (10 pixels for now)
[nr_raw, nc_raw, ~] = size(I);

r_sample = 1:8:nr_raw;
c_sample = 1:8:nc_raw;
rgb_sample = 1:3;

[c_sample_mesh, r_sample_mesh, rgb_sample_mesh] = meshgrid(c_sample, r_sample, rgb_sample);
sampleInd = sub2ind([nr_raw, nc_raw, 3], r_sample_mesh, c_sample_mesh, rgb_sample_mesh);
I_sampled = I(sampleInd);

I_gray = rgb2gray(I_sampled);
imshow(I_sampled);
hold on

%% GUI to choose one reasonable path
temp = ginput(1);
figure(1)
h_path = plot(temp(1), temp(2), 'LineWidth', 10);

wayptX = [];
wayptY = [];

while(~isempty(temp))
    wayptX = [wayptX; temp(1)];
    wayptY = [wayptY; temp(2)];
    set(h_path, 'xdata', wayptX, 'ydata', wayptY);
    temp = ginput(1);
end

%% TraceRay to make path