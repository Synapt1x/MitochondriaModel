function [hObject, handles] = plot_fit_func(hObject, handles)
%Function handling the callback for plotting the fitting of the model in
%comparison to experimental data

%store variables for input parameter set
params = handles.expParams;

%clear all axes graphs using arrayfun to distribute cla to each axes
arrayfun(@cla,findall(0,'type','axes'))
drawnow()

%plug in the equations into the ode solver
[t,y] = solver(handles.parameters,params, handles.data, ...
    handles.selected_model.Tag, handles.models);

if strcmp(handles.selected_model.String, 'CC MP Model')
    %store the values calculated for each variable
    [cytcred, o2, psi] = deal(y(:,1),y(:,2),y(:,3));
    
    %calculate the OCR values from the oxygen
    calcOCR = calculateOCR(handles,'control',cytcred,o2, psi, t);
    calcOCR = calcOCR * -1000;
else
    %store the values calculated for each variable
    [cytcred, o2, Hn, Hp] = deal(y(:,1),y(:,2),y(:,3),y(:,4));
    
    %calculate the OCR values from the oxygen
    calcOCR = calculateOCR(handles,'control',cytcred,o2,Hn,Hp, t);
    calcOCR = calcOCR * -100000;
end

%plot the O2 concentration over time with real O2 data on top
axes(handles.O2_plot);
hold on
plot(t(2:end),handles.data.(handles.data.data_types{...
    handles.parameters.data_fitting})(2:end),'black', ...
    'lineWidth',2);
plot(t(2:end),o2(2:end),'r--','lineWidth',2);
hold off

%plot the OCR over time with real OCR data on top
axes(handles.OCR_plot);
hold on
plot(t(2:end),handles.data.(handles.data.data_types{...
    handles.parameters.data_fitting+2})(2:end) * -100,'black', ...
    'lineWidth',2);
plot(t(2:end),calcOCR(2:end),'r--','lineWidth',2);
hold off

if ~strcmp(handles.selected_model.String, 'CC Baseline Model')
    %add vertical lines to all graphs for injection times
    for graph = 1:numel(handles.graphs)
        axes(handles.graphs{graph});
        vertScale = get(gca,'yLim'); % get the y resolution
        vertRange = [vertScale(1), vertScale(end)*0.98];
        
        % draw oligo line
        line([handles.data.oligo_t, handles.data.oligo_t], ...
            vertRange, 'Color','b','LineWidth',0.01);
        text(handles.data.oligo_t,vertRange(end)*1.005,'Oligomycin', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        
        % draw fccp lines
        line([handles.data.fccp_25_t, handles.data.fccp_25_t], ...
            vertRange,'Color','b');
        text(handles.data.fccp_25_t,vertRange(end)*1.005,'FCCP_{125}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_50_t, handles.data.fccp_50_t], ...
            vertRange,'Color','b');
        text(handles.data.fccp_50_t,vertRange(end)*1.005,'FCCP_{250}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_75_t, handles.data.fccp_75_t], ...
            vertRange,'Color','b');
        text(handles.data.fccp_75_t,vertRange(end)*1.005,'FCCP_{375}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_100_t, handles.data.fccp_100_t], ...
            vertRange,'Color','b');
        text(handles.data.fccp_100_t,vertRange(end)*1.005,'FCCP_{500}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        
        % draw inhibit line
        line([handles.data.inhibit_t, handles.data.inhibit_t], ...
            vertRange, 'Color','b');
        text(handles.data.inhibit_t,vertRange(end)*1.005,'Rot/AA', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        
        % while iterating over graphs, also set xLim
        set(gca,'xLim',[t(1), t(end)]);
        
    end
end