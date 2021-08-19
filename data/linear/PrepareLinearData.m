function [data, para] = PrepareLinearData(N, outlierRatio, dim, seed, noise_in, noise_out)
    FlagofBlance = 1;
    [data, theta, th_guide] = genSyntheticData(N, noise_in, noise_out, outlierRatio, dim, FlagofBlance, seed);
    para.N = N;
    papr.dim = dim;
    para.noise = noise_in;
    para.outlierRatio = outlierRatio;
    para.th_guide = th_guide;
    para.theta = theta;
end