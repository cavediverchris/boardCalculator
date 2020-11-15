%% Project Set Up
% This script sets up the environment for the current Simulink Project.
% This script needs to be added to the Shortcuts to Run at Start to ensure
% all the initialisation is conducted at project start.

%% Clear the workspace and command window
% The workspace is cleared of all current variables and all windows are
% closed.
clc
clear vars
close all

%% Acquire SIMULINK Project Information
% Set up the SIMULINK Project object based upon the release.

projObj = currentProject;
%% Back Up - Project Folder
% This schedules an aut-export of the Simulink project every day, it simply
% checks whether a folder with the project name / date exists in the export
% location

% Print message to screen.
disp('Back Up Process');

% Set this flag to false to disable archiving
BackUpFlag = true;

% Define the location for export. This is based upon taking the highest
% level possible on the same drive as the project location.
CurrentFolder = char(projObj.RootFolder);
slashIdx = strfind(CurrentFolder, '\');
exportLocation = CurrentFolder(1:slashIdx(1));
exportLocation = exportLocation + "SLProjBackUps\";

% Check that exportLocation is a valid path
if exist(exportLocation, 'dir') == 0
    % CASE: exportLocation does not exist as a path
    % ACTION: create folder at exportLocation
    try
        mkdir(exportLocation);
    catch ME
        % TODOD
        if strcmp(ME.identifier, 'MATLAB:MKDIR:OSError')
            disp("Cannot create folder at path: " + exportLocation);
        end
    end
end

backupFile = exportLocation + projObj.Name + "_backup_" + date + ".zip";

% Check if the backup file exists for today, if not, create it.
if BackUpFlag == false
    % Print message to screen.
    disp('... Secondary back-up disabled.')
elseif exist(backupFile , 'file') == 0 && (BackUpFlag == true)
    % Print message to screen.
    disp("... No archive file found, exporting project to " + backupFile)
    
    %dbstop if caught error
    export(projObj, backupFile);
    %dbclear all
    
    % Print message to screen.
    disp('... Back up completed.')
elseif exist(backupFile , 'file') == 2
    % Print message to screen.
    disp ('... Archive file found for current project - skipping export')
end

clear slashIdx backupFile BackUpFlag CurrentFolder exportLocation
%% Update Template Folder
% In this section the path that contains templates for use by other projects is defined.
myTemplate = Simulink.exportToTemplate(projObj, 'TemplateProject_DataAnalytics', ...
                 'Group', 'Simulink', ...
                 'Author', getenv('username'), ...
                 'Description', 'This is a Project Template for Data Analytics', ...
                 'Title', 'Template Data Analytics Project', ...
                 'ThumbnailFile', projObj.RootFolder + "\AuxiliaryFunctions\ProjectManagement\TemplateThumbnailImage.png");

% Move the newly created template to the communal templates folder
movefile(myTemplate, userpath, 'f');

clear myTemplate projObj
%% Clean Up
% clear up the workspace
clear vars;