function [] = createModelEquivalenceTestHarness(model_name,th_name)
%CREATEMODELEQUIVALENCETESTHARNESS Summary of this function goes here
%   Detailed explanation goes here
SLTestInstalled = license('test', 'Simulink Test');
if SLTestInstalled
    % CASE: Simulink Test is installed,
    % ACTION:create a test harness using the Simulink Test command
    sltest.harness.create(model_name, ...
        'Name', ['Equivalence test harness for ', model_name], ...
        'Description', ['Equivalence test harness for ', model_name], ...
        'Source', 'Test Sequence', ...
        'SeperateAssessment', 'false', ...
        'SynchronizationMode', 'SyncOnOpenAndClose', ...
        'CreateWithoutCompile', 'false', ...
        'VerificationMode', 'Normal', ...
        'RebuildOnOpen', 'true', ...
        'SaveExternally', 'true');
    
    % Set the model to use the data dictionary
    set_param(gcs, 'DataDictionary', 'DataDictionary.sldd')
else
    % CASE: Simulink Test is not installed
    % ACTION: create a test harness manually
    
    open_system(new_system(th_name));
    
    % Set the model to use the data dictionary
    set_param(gcs, 'DataDictionary', 'DataDictionary.sldd')
    
    % Add an constant block
    add_block('simulink/Sources/Constant', [gcs, '/Constant']);
    set_param([gcs, '/Constant'], 'position', [100 100 130 130]);
    
    % Add a model reference
    add_block('simulink/Ports & Subsystems/Model', [gcs, '/ReferencedModel'])
    set_param([gcs, '/ReferencedModel'], 'position', [200 75 430 150]);
    
    % Add a difference block
    add_block('simulink/Math Operations/Sum',[gcs, '/Difference']);
    set_param([gcs, '/Difference'], 'position', [500 100 550 130]);
    
    % Add an display
    add_block('simulink/Sinks/Display', [gcs, '/Display']);
    set_param([gcs, '/Display'], 'position', [655 100 705 130]);
    
    save_system(gcs)
    
    % Set the model reference to point at the previously created model
    set_param([gcs, '/ReferencedModel'], 'ModelName', fullfile(model_name));
    
    % Connect the constant to the model reference
    add_line(gcs, 'Constant/1', 'ReferencedModel/1');
    
    % Connect the Output of the model reference to the difference
    add_line(gcs, 'ReferencedModel/1', 'Difference/1');
    
    % Connect the Output of the difference to the Display
    add_line(gcs, 'Difference/1', 'Display/1');
    
    % Add a second model reference (for equivalence)
    add_block('simulink/Ports & Subsystems/Model', [gcs, '/ReferencedModel1'])
    set_param([gcs, '/ReferencedModel1'], 'position', [200 232 430 308]);
    set_param([gcs, '/ReferencedModel1'], 'ModelName', fullfile(model_name));
    set_param([gcs, '/ReferencedModel1'], 'SimulationMode', 'Software-in-the-loop (SIL)');
    
    % Connect the constant to the model reference for SIL
    add_line(gcs, 'Constant/1', 'ReferencedModel1/1');
    
    % Connect the model reference for SIL to the second input of the
    % difference
    add_line(gcs, 'ReferencedModel1/1', 'Difference/2');
    
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
    
    save_system(gcs)
    close_system(th_name);    
end
end

