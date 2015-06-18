%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function matchColours(hObject)
% Set default colours for all components by switching to the correct skin
% colour matching scheme.  Each skin should have a function in this table.
% The default is no matching -- colours will appear as they do in guide.
%
if ~ishandle(hObject)
    return
end
%
QubistSkin_=getGUIData('QubistSkin_');
if isempty(QubistSkin_)
    % Do nothing.
    return
end
%
switch QubistSkin_
    case 'Windows'
        matchColoursWindows(hObject);
    case 'Mac'
        matchColoursMac(hObject);
    case 'Linux'
        matchColoursLinux(hObject);
    case 'Minimalist'
        matchColoursMinimalist(hObject);
end
%
% Set the background gray level for buttons.  This seems to drift between
% different MATLAB versions.
matchingColour=[0.929, 0.929, 0.929];
GUI_elements=[findall(hObject, 'Style', 'pushbutton');...
    findall(hObject, 'Style', 'togglebutton')];
for b=1:length(GUI_elements)
    colour=get(GUI_elements(b), 'BackgroundColor');
    if max(colour) == min(colour)
        % It's gray...
        set(GUI_elements(b), 'BackgroundColor', matchingColour);
    end
end

% ==================================================

function matchColoursWindows(hObject)
% Set default colours for all components if it's not a Windows computer or
% a Mac.  These opertating systems support transparent uipanels well.  Linux
% machines normally do not.
%
% Slightly bluish colour looks nice with metallic background.
matchingColour=[0.9, 0.89, 0.91];
%
GUI_elements=[findall(hObject, 'Style', 'radiobutton');...
    findall(hObject, 'Style', 'checkbox');...
    findall(hObject, 'Style', 'text');...
    findall(hObject, 'Type', 'uipanel')];
set(GUI_elements, 'BackgroundColor', matchingColour);

% ==================================================

function matchColoursMac(hObject)
% Set default colours for all components if it's not a Windows computer or
% a Mac.  These opertating systems support transparent uipanels well.  Linux
% machines normally do not.
%
% Slightly bluish colour looks nice with metallic background.
matchingColour=[0.9, 0.89, 0.91];
%
GUI_elements=[findall(hObject, 'Style', 'radiobutton');...
    findall(hObject, 'Style', 'checkbox');...
    findall(hObject, 'Style', 'text');...
    findall(hObject, 'Type', 'uipanel')];
set(GUI_elements, 'BackgroundColor', matchingColour);

% ==================================================

function matchColoursLinux(hObject)
% Set default colours for all components if it's not a Windows computer or
% a Mac.  These opertating systems support transparent uipanels well.  Linux
% machines normally do not.
%
% Slightly bluish colour looks nice with metallic background.
matchingColour=[0.9, 0.89, 0.91];
%
GUI_elements=[findall(hObject, 'Style', 'radiobutton');...
    findall(hObject, 'Style', 'checkbox');...
    findall(hObject, 'Style', 'text');...
    findall(hObject, 'Type', 'uipanel')];
set(GUI_elements, 'BackgroundColor', matchingColour);

% ==================================================

function matchColoursMinimalist(hObject)
% Set default colours for all components to be the same as the system
% default background colour.
%
% matchingColour depends on the actual operating system.
matchingColour=get(0,'defaultUicontrolBackgroundColor');
%
set(hObject, 'Color', matchingColour);
GUI_elements=[findall(hObject, 'Style', 'radiobutton');...
    findall(hObject, 'Style', 'checkbox');...
    findall(hObject, 'Style', 'text');...
    findall(hObject, 'Style', 'pushbutton');...
    findall(hObject, 'Type', 'uipanel')];
set(GUI_elements, 'BackgroundColor', matchingColour);
