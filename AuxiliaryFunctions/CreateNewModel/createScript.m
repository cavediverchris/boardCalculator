function [] = createScript(model_name)
%CREATESCRIPT Summary of this function goes here
%   Detailed explanation goes here
model_name = sprintf('%s.m', model_name);
fid = fopen(model_name, 'wt');

fprintf(fid, '%% %s \n', model_name);
fprintf(fid, '%s \n', '% The purpose of this script is to ... ');
fprintf(fid, '%s \n', '%% INPUTS');
fprintf(fid, '%s \n', '% This script uses the following inputs:');
fprintf(fid, '%s \n', '% Input 1: Input 1 Name');
fprintf(fid, '     %s \n', '% Dimensions: Input variable dimensions');
fprintf(fid, '     %s \n', '% Data Type: Input data type');
fprintf(fid, '     %s \n', '% Other comments / information:');

fprintf(fid, '%s \n', '%% OUTPUTS');
fprintf(fid, '%s \n', '% This script produces the following outputs:');
fprintf(fid, '%s \n', '% Output 1: Output 1 Name');
fprintf(fid, '     %s \n', '% Dimensions: Output variable dimensions');
fprintf(fid, '     %s \n', '% Data Type: Output data type');
fprintf(fid, '     %s \n', '% Other comments / information:');

fprintf(fid, '%s \n', '%% MAIN FUNCTION');
fclose(fid);
end

