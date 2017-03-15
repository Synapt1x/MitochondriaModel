function varargout = open_graph(varargin)
% Open clicked figure in a new figure

%determine which object was clicked
whichgraph = gco;
obj=get(gca);
% set(whichgraph,'DefaultPlotFontSize',16);

%open a new figure using the graph from the relevant axes
h2copy = allchild(whichgraph); %extract all children from hObject
if isempty(h2copy) %check to see if the graph exists yet
    msgbox(['This function has not been plotted yet. Please use the ', ...
        'plot button below to graph the function before opening it.'],'No Plot');
else
    if ~isempty(varargin)
        % create the figure
        newgraph = figure('Visible','Off','units','normalized','outerposition',[0 0 1 1]);
    else
        % create the figure
        newgraph = figure('units','normalized','outerposition',[0 0 1 1]); %create the figure
    end
    hParent = axes; %create handle for axes child
    copyobj(h2copy,hParent) %copy the original graph to the new fig
    
    %now add the correct labels to the new figure
    xlabel(obj.XLabel.String,'FontName','Calibri','FontSize',16);
    ylabel(obj.YLabel.String,'FontName','Calibri','FontSize',16);
    title(obj.Title.String,'FontSize',22,'FontWeight','bold','FontName','Calibri');
    
    %change the children to change the reagent text sizes
    textChildren = findobj(hParent,'FontSize',6); % get the text objects
    set(textChildren,'FontSize',12); % increase their font size
    
    %optionally output the figure for the 'save' feature
    varargout{1}=newgraph;
    
end