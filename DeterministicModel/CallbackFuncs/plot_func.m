function [hObject, handles] = plot_func(hObject, handles)
%Function handling the callback for plotting the output of the model

%store variables for differntiating control and experimental parameter sets
graphColor = {'black','r'};
types = {'control','experimental'};
params = {handles.ctrlParams,handles.expParams};

%clear all axes graphs using arrayfun to distribute cla to each axes
arrayfun(@cla,findall(0,'type','axes'))

for type=1:2
    
    %plug in the equations into the ode solver
    [t,y] = solver(handles.parameters,params{type}, handles.data);
    
    %store the values calculated for each variable
    [cytcred, o2, Hn, Hp] = deal(y(:,1),y(:,2),y(:,3),y(:,4));
    
    %calculate the OCR values from the oxygen
    calcOCR = calculateOCR(handles,cytcred,o2,Hn,Hp,types{type});
    calcOCR = calcOCR * -1000;
    
    %plot the Cyt c concentration over time
    axes(handles.Cytc_plot);
    hold on
    plot(t(2:end),cytcred(2:end),graphColor{type},'lineWidth',2);
    hold off
    
    %plot the O2 concentration over time with real O2 data on top
    axes(handles.O2_plot);
    hold on
    plot(t(2:end),o2(2:end),graphColor{type},'lineWidth',2);
    hold off
    
    %plot the OCR over time with real OCR data on top
    axes(handles.OCR_plot);
    hold on
    plot(t(2:end),calcOCR(2:end),graphColor{type},'lineWidth',2);
    hold off
    
    %plot the Hn concentration over time
    axes(handles.H_N_plot);
    hold on
    plot(t(2:end),Hn(2:end),graphColor{type},'lineWidth',2);
    hold off
    
    %plot the Hp concentration over time
    axes(handles.H_P_plot);
    hold on
    plot(t(2:end),Hp(2:end),graphColor{type},'lineWidth',2);
    hold off
    
end

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
    t_25 = handles.parameters.timePoints(handles.parameters.ctrlParams.fccp_25);
    t_50 = handles.parameters.timePoints(handles.parameters.ctrlParams.fccp_50);
    t_75 = handles.parameters.timePoints(handles.parameters.ctrlParams.fccp_75);
    t_100 = handles.parameters.timePoints(handles.parameters.ctrlParams.fccp_100);
    
    line([t_25, t_25], vertRange,'Color','b');
    text(t_25,vertRange(end)*1.005,'FCCP_{125}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([t_50, t_50],vertRange,'Color','b');
    text(t_50,vertRange(end)*1.005,'FCCP_{250}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([t_75, t_75], vertRange,'Color','b');
    text(t_75,vertRange(end)*1.005,'FCCP_{375}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    line([t_100, t_100], vertRange,'Color','b');
    text(t_100,vertRange(end)*1.005,'FCCP_{500}', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    
    % draw inhibit line
    line([handles.parameters.inhibitTimes(1), handles.parameters.inhibitTimes(1)], ...
        vertRange, 'Color','b');
    text(handles.parameters.inhibitTimes(1),vertRange(end)*1.005,'Rot/AA', ...
        'FontSize',6,'HorizontalAlignment','center','Color','b');
    
    % while iterating over graphs, also set xLim
    set(gca,'xLim',[t(1), t(end)]);
    
end