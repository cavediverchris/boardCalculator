function [] = createModel(model_name)
%CREATEMODEL Summary of this function goes here
%   Detailed explanation goes here

open_system(new_system(model_name));

% Add an inport
add_block('simulink/Sources/In1', [gcs, '/Inport']);
set_param([gcs, '/Inport'], 'position', [100 100 130 114]);

% Add a unity gain block
add_block('simulink/Math Operations/Gain', [gcs, '/UnityGain']);
set_param([gcs, '/UnityGain'], 'position', [200 100 230 130]);

% Add an outport
add_block('simulink/Sinks/Out1', [gcs, '/Outport']);
set_param([gcs, '/Outport'], 'position', [300 100 330 114]);

% save current model
save_system(gcs)


% Connect the inport to the gain block
add_line(gcs, 'Inport/1', 'UnityGain/1');

% Connect the gain block to the outport
add_line(gcs, 'UnityGain/1', 'Outport/1');

% Set the model to use the data dictionary
set_param(gcs, 'DataDictionary', 'DataDictionary.sldd')

% Set the configuration to use the configuration reference defined in teh
% data dictionary

% Firstly open the data dictiomary
dataDictionaryName = 'DataDictionary.sldd';
ddData = Simulink.data.dictionary.open(dataDictionaryName);

% Then get the configuration value
sectionObj	= getSection(ddData, 'Configurations');
entryObj	= getEntry(sectionObj,'ConfigurationReference');
FixedStepConfiguration  = getValue(entryObj);

attachConfigSet(gcs, FixedStepConfiguration);
setActiveConfigSet(gcs, 'ConfigurationReference');

% save current model
save_system(gcs)
close_system(model_name);
end

