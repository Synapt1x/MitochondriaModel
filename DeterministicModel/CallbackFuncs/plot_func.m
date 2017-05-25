function [hObject, handles] = plot_func(hObject, handles)
%Function handling the callback for plotting the output of the model

%store variables for differntiating control and experimental parameter sets
graphColor = {'black','r--'};
types = {'control','experimental'};
params = {handles.ctrlParams,handles.expParams};

%clear all axes graphs using arrayfun to distribute cla to each axes
arrayfun(@cla,findall(0,'type','axes'))
drawnow()

for type=1:2
    
    %plug in the equations into the ode solver
    [t,y] = solver(handles.parameters,params{type}, handles.data, ...
        handles.selected_model.Tag, handles.models);
    
    if strcmp(handles.selected_model.String, 'CC MP Model')
        %store the values calculated for each variable
        [cytcred, o2, psi] = deal(y(:,1),y(:,2),y(:,3));
        
        %calculate the OCR values from the oxygen
        calcOCR = calculateOCR(handles,types{type},cytcred,o2, psi);
        calcOCR = calcOCR * -1000;
    else
        %store the values calculated for each variable
        [cytcred, o2, Hn, Hp] = deal(y(:,1),y(:,2),y(:,3),y(:,4));
        
        %calculate the OCR values from the oxygen
        calcOCR = calculateOCR(handles,types{type},cytcred,o2,Hn,Hp);
        calcOCR = calcOCR * -1000;
    end
    
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
    
    if strcmp(handles.selected_model.String, 'CC MP Model')
        %plot the Cyt c concentration over time
        axes(handles.Cytc_plot_mp);
        hold on
        plot(t(2:end),cytcred(2:end),graphColor{type},'lineWidth',2);
        hold off
        
        %plot the membrane potential over time
        axes(handles.psi_plot_mp);
        hold on
        plot(t(2:end),psi(2:end),graphColor{type},'lineWidth',2);
        hold off
    else
        %plot the Cyt c concentration over time
        axes(handles.Cytc_plot);
        hold on
        plot(t(2:end),cytcred(2:end),graphColor{type},'lineWidth',2);
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
end

if ~strcmp(handles.selected_model.String, 'CC Baseline Model')
    %add vertical lines to all graphs for injection times
    for graph = 1:numel(handles.graphs)
        axes(handles.graphs{graph});
        vertScale = get(gca,'yLim'); % get the y resolution

        % draw oligo line
        line([handles.data.oligo_t, handles.data.oligo_t], ...
            vertScale, 'Color','b','LineWidth',0.01);
        text(handles.data.oligo_t,vertScale(2),'Oligomycin', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');

        % draw fccp lines   
        line([handles.data.fccp_25_t, handles.data.fccp_25_t], ...
            vertScale,'Color','b');
        text(handles.data.fccp_25_t,vertScale(2),'FCCP_{125}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_50_t, handles.data.fccp_50_t], ...
            vertScale,'Color','b');
        text(handles.data.fccp_50_t,vertScale(2),'FCCP_{250}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_75_t, handles.data.fccp_75_t], ...
            vertScale,'Color','b');
        text(handles.data.fccp_75_t,vertScale(2),'FCCP_{375}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');
        line([handles.data.fccp_100_t, handles.data.fccp_100_t], ...
            vertScale,'Color','b');
        text(handles.data.fccp_100_t,vertScale(2),'FCCP_{500}', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');

        % draw inhibit line
        line([handles.data.inhibit_t, handles.data.inhibit_t], ...
            vertScale, 'Color','b');
        text(handles.data.inhibit_t,vertScale(2),'Rot/AA', ...
            'FontSize',6,'HorizontalAlignment','center','Color','b');

        % while iterating over graphs, also set xLim
        set(gca,'xLim',[t(1), t(end)]);

    end
end