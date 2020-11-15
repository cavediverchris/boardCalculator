function [] = createScriptTestHarness(th_name, scriptName)
%CREATESCRIPTTESTHARNESS Summary of this function goes here
%   Detailed explanation goes here
% Create the file
fid = fopen(th_name, 'wt');

% write a title;
fprintf(fid, '%% Test harness for %s', scriptName);
fprintf(fid, '%s', newline);

% write a quick introduction
fprintf(fid, '%s', '% This test harness is used to exercise the functionality for the System');
fprintf(fid, '%s', newline);

fprintf(fid, '%s', '% Under Test (SUT). This test harness may contain multiple tests for the');
fprintf(fid, '%s', newline);

fprintf(fid, '%s', '% SUT as well as the logic to confirm that the actual result meets the');
fprintf(fid, '%s', newline);

fprintf(fid, '%s', '% expected result.');
fprintf(fid, '%s', newline);

% write a template test
fprintf(fid, '%s', '%% Template Test 1: Insert Test Name');
fprintf(fid, '%s', newline);
fprintf(fid, '%s', newline);

fprintf(fid, '%s', 'inputData = 1;');
fprintf(fid, '%s', newline);

text2write = sprintf('functionOuput = functionName(inputData);');
fprintf(fid, '%s', text2write);
fprintf(fid, '%s', newline);

text2write = sprintf('assert(functionOutput == criteria, ''Error message if false'');');
fprintf(fid, '%s', text2write);
fprintf(fid, '%s', newline);
fclose(fid);
end

