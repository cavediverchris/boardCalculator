%% New Script
% This script is designed to automate the process of creating a script.
% There are two types of script that this utility will automate the
% creation of:
%       1. A high-level Live Script, and
%       2. A low-level MATLAB function
%
% The high-level Live Scripts are to be used like a report: they contain
% the overall process, documenting the process and showing results
% throughout it without going into too much detail of how it is done.
% Typically the Live Script will contain minimal code, primarily to render
% and display results to support the discussion in the Live Script.
%
% On the other hand, the low-level MATLAB functions contain the "meat".
% Inside a function will perform the detailed analysis required. By
% splitting off this detailed analysis into seperate functions it
% simplifies the main Live Script to keep it conceptually simple. It also
% means that these functions which are likely to be more complex, can be
% wrapped up with unit tests to ensure that they work properly.

%% Clean Up Workspace
close all;
clear vars;
clc;

%% Create Custom Dialog Box for input

[NewScriptName, FileType] = CreateDialog();

if isempty(NewScriptName)
    % CASE: User pressed cancel
    % ACTION: stop executing the script
    return;
end

%% Update name to conform to camel case
% The standard convention to be used is known as camel case. This is where
% the first letter of the first word is in lower case, but the first letter
% in all subsequent words is capitalised.

isSpacesPresent = contains(NewScriptName, ' ');

if isSpacesPresent
    % CASE: Spaces are in the name, this means that the user provided a
    % name with multiple words
    % ACTION: ensure the first letter is set to lower case, and that the
    % first letter of all subsequent words are set to upper case
    
    % Set the first letter to be lower case
    NewScriptName(1) = lower(NewScriptName(1));
    
    spacesIdx = strfind(NewScriptName, ' ');
    
    for idx = 1:length(spacesIdx)
        currentSpaceIdx = spacesIdx(idx);
        
        % Set the first letter of each new "word" to upper case
        NewScriptName(currentSpaceIdx + 1) = upper(NewScriptName(currentSpaceIdx + 1));
    end
    
    % Remove all the spaces
    NewScriptName = erase(NewScriptName, " ");
end
%% Create folders for new scripts
% High-level Live Scripts will be contained in a dedicated folder,
% low-level analytical functions will be contained in a seperate, dedicated
% folder.

try
    Proj = currentProject;
    RootFolder = Proj.RootFolder;
catch ME
    if (strcmp(ME.identifier, 'SimulinkProject:api:NoProjectCurrentlyLoaded'))
        % CASE: A Simulink Project is not loaded
        % ACTION: The function is being used outside of SL Project, set a
        % rootfolder path
        RootFolder = pwd;
    end
end

% ParentFolder = '\Models\';
% folderName = NewScriptName;

% First need to check if the High-Level Scripts folder actually exists
highLevelScriptsFolder = strcat(RootFolder, "\HighLevelScripts");

if exist(highLevelScriptsFolder, 'dir') == 0
    % CASE: The High-Level Scripts folder does not exist
    % ACTION: Create the High-Level Scripts folder, and add it to the path,
    % and to the project
    mkdir(highLevelScriptsFolder);
    addPath(Proj,highLevelScriptsFolder);
    addFolderIncludingChildFiles(Proj, highLevelScriptsFolder);
end

% Second, need to check if the Low-Level Scripts folder actually exists
lowLevelScriptsFolder = strcat(RootFolder, "\LowLevelScripts");

if exist(lowLevelScriptsFolder, 'dir') == 0
    % CASE: The Low-Level Scripts folder does not exist
    % ACTION: Create the Low-Level Scripts folder, and add it to the path,
    % and to the project
    mkdir(lowLevelScriptsFolder);
    addPath(Proj,lowLevelScriptsFolder);
    addFolderIncludingChildFiles(Proj, lowLevelScriptsFolder);
end



%% Create file
% In this cell, we create the new file as specified by the user

% Now make the folder that contains the new script
if strcmp(FileType, 'Script')
    % CASE: User wants to create a High-Level Live Script
    % ACTION: Create a new Live Script in the High-Level Scripts folder
    % TODO
    ParentFolder = highLevelScriptsFolder;
    createScript(NewScriptName)
    % TODO - convert to live script
elseif strcmp(FileType, 'Function')
    % CASE: User wants to create a Low-Level Function
    % ACTION: Create a new MATLAB Function in the Low-Level Scripts folder
    ParentFolder = lowLevelScriptsFolder;
    createScript(NewScriptName)
end

%% Create (functional) test harness
% A functional test harness is used to provide the behaviour of a SUT
if strcmp(FileType, 'Function')
    % CASE: User is creating a MATLAB script
    % ACTION: Create a unit test script
    th_name = sprintf('test_%s.m', NewScriptName);
    createScriptTestHarness(th_name, NewScriptName)
end

%% Add Requirements Module

if strcmp(FileType, 'Function')
    
newReqSet = slreq.new(strcat(ParentFolder, '\', 'Reqts_', NewScriptName));
newDervReqSet = slreq.new(strcat(ParentFolder, '\', 'ReqtsDerived_', NewScriptName));
end
% Opens the requirements editor
% myReqSetObj = slreq.open(newReqSet);

% Load the requirements set
% myReqSetObj = slreq.load(newReqSet);

% Set the description of the linkset
% TODO

%% Move Files
% Main steps of functionality:
%
% # The directory is changed to ensure that only the intended files are
% renamed.
% # Copied files are renamed
% # Model referencing updated
% # Add to Project
% # directory returned to original
%

if strcmp(FileType, 'Script')
    movefile(strcat(NewScriptName, '.m'), strcat(ParentFolder, '\', NewScriptName, '.m'));
elseif strcmp(FileType, 'Function')
    movefile(strcat(NewScriptName, '.m'), strcat(ParentFolder, '\', NewScriptName, '.m'));
    movefile(th_name, strcat(ParentFolder, '\', th_name));
end

%% Add to project
folderContents = ls(strcat(ParentFolder, '\'));
[numFiles, ~] = size(folderContents);

% loop over each entry in folderContents, first two entries are just
% markers for higher levels
for fileIdx = 3:numFiles
    currentFile = folderContents(fileIdx,:);
    addFile(Proj, strcat(ParentFolder, '\', currentFile));
    disp(['Added file: ', folderContents(fileIdx,:), ' to project.']);
end


%% Set the test harness to have the Test label

for fileIdx = 3:numFiles
    % Search name for the test syntax
    fileName = folderContents(fileIdx,:);
    
    if contains(fileName, 'test_', 'IgnoreCase', true)
        % CASE: file name contains test
        % ACTION: Set the file classification label to test
        myFile = findFile(Proj, strcat(ParentFolder,'\',fileName) );
        myFile.addLabel("Classification", "Test");
    end
    
    
end

%% Add to path
% In this cell the folder is also added to the project path
%addPath(Proj,strcat(Path, '\'));