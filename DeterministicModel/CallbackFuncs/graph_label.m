function graph_label(handles)
%{
Function for labelling all graphs in the GUI.

Since updating the axes elements resets the axis properties such as title,
this function is called each time a figure is plotted so as to reset the
titles and labels to the proper text.
%}
for i=1:numel(handles.parameters.title)
    axes(handles.graphs{i})
    set(handles.graphs{i},'FontSize',8);
    xlabel(handles.parameters.xlab,'FontName','Helvetica','FontSize',8);
    ylabel(handles.parameters.ylab{i},'FontName','Helvetica','FontSize',8);
    title(textwrap({handles.parameters.title{i}},30), ...
        'FontWeight','bold','FontName','Helvetica','FontSize',9);
end