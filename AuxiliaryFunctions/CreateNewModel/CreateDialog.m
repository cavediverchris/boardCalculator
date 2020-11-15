function [NewModelName, FileType] = CreateDialog()
%CREATEDIALOG Summary of this function goes here
%   Detailed explanation goes here

% Initialise temporary values
name = 'TBD2';
FileType = 'TBD3';

dlg = dialog('Position', [300 300 500 150],'Name','Specify New Script Name');

    buttonGroup = uibuttongroup('parent', dlg, ...
                    'Visible', 'off', ...
                    'Position', [0.05 0.1 .4 0.8]);
                
    rad1 = uicontrol(buttonGroup, ...
            'Style', 'radiobutton', ...
            'Position',[10 75 200 30],...
            'String','High-Level Live Script');
        
    rad2 = uicontrol(buttonGroup, ...
            'Style', 'radiobutton', ...
            'Position',[10 25 300 30],...
            'String','Low-Level MATLAB Function');

    buttonGroup.Visible = 'on';
    
    txt2 = uicontrol('Parent',dlg,...
            'Style','text',...
            'Position',[250 85 150 40],...
            'String','Provide a name (with spaces)');
       
    edit1 = uicontrol('Parent',dlg,...
            'Style','edit',...
            'Callback', @edit_callback, ...
            'Position',[250 75 150 25]);
        
        
    btn = uicontrol('Parent',dlg,...
            'Position',[425 75 70 25],...
            'String','Done',...
            'Callback',@btn_callback);
        

uiwait(dlg)

    function edit_callback(edit1, event)      
        % Deduce name given
        name = char(edit1.String);
    end

    function btn_callback(btn, event)      
            % Deduce name given
            edit_callback(edit1, event);
            NewModelName = name;
            
            if rad1.Value == true && rad2.Value == false
                % User wants a High-Level Live Script
                FileType = 'Script';
            elseif rad1.Value == false && rad2.Value == true
                % User wants a low-level MATLAB function
                FileType = 'Function';
            end
            delete(gcf);
    end
end