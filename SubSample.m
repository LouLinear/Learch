function [ I_sampled, I_gray ] = SubSample( I, subsample_size)
    [nr_raw, nc_raw, ~] = size(I);
    r_sample = 1:subsample_size:nr_raw;
    c_sample = 1:subsample_size:nc_raw;
    rgb_sample = 1:3;
    
    [c_sample_mesh, r_sample_mesh, rgb_sample_mesh] = meshgrid(c_sample, r_sample, rgb_sample);
    sampleInd = sub2ind([nr_raw, nc_raw, 3], r_sample_mesh, c_sample_mesh, rgb_sample_mesh);
    I_sampled = I(sampleInd);
    
    I_gray = rgb2gray(I_sampled);
end

