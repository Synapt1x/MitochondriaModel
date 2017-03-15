function [hObject, handles] = plot_fit_func(hObject, handles)
%Function handling the callback for plotting the fitting of the model in
%comparison to experimental data

%store variables for differntiating control and experimental parameter sets
params = handles.ctrlParams;

%clear all axes graphs using arrayfun to distribute cla to each axes
arrayfun(@cla,findall(0,'type','axes'))

%plug in the equations into the ode solver
[t,y] = solver(handles.parameters,params, handles.data);

%store the values calculated for each variable
[cytcred, o2, Hn, Hp] = deal(y(:,1),y(:,2),y(:,3),y(:,4));

%calculate the OCR values from the oxygen
calcOCR = calculateOCR(handles,cytcred,o2,Hn,Hp,'control');
calcOCR = calcOCR * -1000;

%plot the O2 concentration over time with real O2 data on top
axes(handles.O2_plot);
hold on
plot(t(2:end),handles.data.(handles.data.data_types{...
    handles.parameters.data_fitting})(2:end),'red', ...
    'lineWidth',2);
plot(t(2:end),o2(2:end),'black','lineWidth',2);
hold off

%plot the OCR over time with real OCR data on top
axes(handles.OCR_plot);
hold on
plot(t(2:end),handles.data.(handles.data.data_types{...
    handles.parameters.data_fitting+2})(2:end),'red', ...
    'lineWidth',2);
plot(t(2:end),calcOCR(2:end),'black','lineWidth',2);
hold off

%add vertical lines to all graphs for injection times
for graph = 1:numel(handles.graphs)
    axes(handles.graphs{graph});
    vertScale = get(gca,'yLim'); % get the y resolution
    vertRange = [vertScale(1), vertScale(end)*0.98];
    
    % draw oligo line
    line([handles.parameters.oligoTimes(1), handles.parameters.oligoTimes(1)], ...
        vertRange, 'Color','b','LineWidth',0.01);
    text(handles.parameters.oligoTimes(1),vertRange(end)*1.005,'Oligomycin', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    
    % draw fccp lines
    line([handles.parameters.fccp_25_t, handles.parameters.fccp_25_t], vertRange,'Color','b');
    text(handles.parameters.fccp_25_t,vertRange(end)*1.005,'FCCP_{125}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([handles.parameters.fccp_50_t, handles.parameters.fccp_50_t],vertRange,'Color','b');
    text(handles.parameters.fccp_50_t,vertRange(end)*1.005,'FCCP_{250}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([handles.parameters.fccp_75_t, handles.parameters.fccp_75_t], vertRange,'Color','b');
    text(handles.parameters.fccp_75_t,vertRange(end)*1.005,'FCCP_{375}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([handles.parameters.fccp_100_t, handles.parameters.fccp_100_t], vertRange,'Color','b');
    text(handles.parameters.fccp_100_t,vertRange(end)*1.005,'FCCP_{500}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    
    % draw inhibit line
    line([handles.parameters.inhibitTimes(1), handles.parameters.inhibitTimes(1)], ...
        vertRange, 'Color','b');
    text(handles.parameters.inhibitTimes(1),vertRange(end)*1.005,'Rot/AA', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    
    % while iterating over graphs, also set xLim
    set(gca,'xLim',[t(1), t(end)]);
    
end