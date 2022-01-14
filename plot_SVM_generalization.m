clear, clc
close all

load('data_SVM_generalization.mat', 'dataSVMgeneralization','classLabels')

%% ----- Visualization Parameters -----------------------------------------

% --- paradigm-specific stuff ---

areas                 = {'PHC','EC','HIPP','AMY'};
areasFull             = {'Parahippocampal Cortex ({\itn}=126)','Entorhinal Cortex ({\itn}=107)','Hippocampus ({\itn}=199)','Amygdala ({\itn}=153)'};

phaseNames            = {'F',   'O1',  'D1',  'CR',  'RD',  'O2',  'D2',  'R'};
phaseIntervals        = [    0    500   1000   1800   2300   3100   3600   4400];
phaseIntervals_scaled = ceil((phaseIntervals) / 50) + .5; % correct due to stepsize = 50
phaseIntervals_txt1   = {'   0',' 500','1000','1800','2300','3100','3600','4400'};
phaseIntervals_txt2   = {'0   ','500 ','1000','1800','2300','3100','3600','4400'};
nTimesteps            = 90;

ticks                 = {'A','B','C','D';    'E','F','G','H';    'I','J','K','L'};

% --- fonts & colors ---

fac = .9;
fontsize_titles  = 16;
fontsize_labels  = 14;
fontsize_axticks = 11;
fontsize_ticks   = 20;

colmap           = 'jet';
colors_contour   = 'k';

colors           = [  0 117   0;...     % word
                    114 185  91 ] / 255; % sign

% --- positions of figure elements ---

posFig      = fac*[ .1    .1      40    29.4]; % 28.4];

% area label
posArea     = fac*[2.3     28.5  11.1    .7];
areaShift   = fac*[[0 : 9.25 : 35]' zeros(4,3)];

% diagonal curve
posCurve    = fac*[ 3.6   24.3   8.5  3.7];

% legend - diagonal curve
posClabel   =  fac*[20.4   21.5      19.5    .8];
posClines   = {fac*[20.9   21.85  ;  22    22]; ...
               fac*[30.8   31.75  ;  22    22]};

% crosstemporal matrix 
posMatSVM   = fac*[ 3.6   12.2   8.5  8.5;...
                    3.6    2.9   8.5  8.5];

% direction labels
posDirBox   = fac*[ .075  12.1   1.5  8.7;...
                    .075   2.8   1.5  8.7];
posDirStims = fac*[repmat(.2,2,1)  posDirBox(:,2)               repmat(1.25,2,2)];
stimShift   = {fac*[zeros(4,1)     [3.4 4.725 7.9 9.225]'-.7    zeros(4,2)];
               fac*[zeros(4,1)     [2.535 3.86 7.035 8.35]'-.7  zeros(4,2)]};

% legend - crosstemporal matrix
posCT       = fac*[28.9    .2  10     .5];
posCTstart  = fac*[28.3    .2    .5   .5];
posCTend    = fac*[38.9    .2    .5   .5];
posCTlabel  = fac*[24      .1  15.9   .7];

% panel ticks
tickShift   = areaShift; tickShift(1,1) = -1.1;
posTicks    = [repmat(posCurve(1)-.4,3,1) , ...
               [ posCurve(2)+posCurve(4)+.1 ; posMatSVM(1,2)+posMatSVM(1,4)+.1 ; posMatSVM(2,2)+posMatSVM(2,4)+.1 ] , ...
               repmat(.1,3,2)];

%% ----- VISUALIZATION ----------------------------------------------------

figSVM = figure('Units','centimeters','Position',posFig,...
    'Color','w', 'PaperPositionMode','auto', 'visible','on');

% --- panel ticks ---

for t=1:3
    for a=1:numel(areas)
        annotation('textbox', 'String',ticks{t,a},...
            'Units','centimeters', 'Position',posTicks(t,:)+tickShift(a,:), ...
            'HorizontalAlignment','center', 'VerticalAlignment','middle',...
            'LineStyle','none', 'FontSize',fontsize_ticks, 'FontWeight','bold', 'Color','k')
    end
end

% --- data panels for each area ---

for a=1:numel(areas)
    
    currArea = areas{a};
    currData = dataSVMgeneralization.(currArea);
    
    % ... Title ...........................................................................................................................
    
    annotation('textbox', 'String',areasFull{a},...
        'Units','centimeters', 'Position',posArea+areaShift(a,:), ...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom',...
        'LineStyle','none', 'FontSize',fontsize_titles, 'FontWeight','bold', 'Color','k')
    
    % ... A: Diagonal Curve ...............................................................................................................
    
    ax_curve(a) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posCurve+areaShift(a,:));
    hold on
    
    % --- axis dimensions & labels ---
    
    cur_xlim = [0.5 90.5];
    cur_ylim = [45 76];
    
    yyaxis left
    ax_curve(a).YAxis(1).Color = 'k';
    axis([cur_xlim  cur_ylim])
    set(ax_curve(a),...
        'xtick',phaseIntervals_scaled, 'xticklabel',phaseIntervals_txt1, 'xticklabelrotation',90,...
        'ytick',0:10:cur_ylim(2), 'yticklabel',[], 'yminortick','on',...
        'FontSize',fontsize_axticks)
    ax_curve(a).YAxis(1).MinorTickValues = 0:5:cur_ylim(2);
    
    yyaxis right
    ax_curve(a).YAxis(2).Color = 'k';
    axis([cur_xlim  cur_ylim])
    set(ax_curve(a),...
        'ytick',0:10:cur_ylim(2), 'yticklabel',[], 'yminortick','on',...
        'ticklength',[.03 .01], 'FontSize',fontsize_axticks)
    ax_curve(a).YAxis(2).MinorTickValues = 0:5:cur_ylim(2);
    
    xlabel('Time (ms)', 'FontSize',fontsize_labels);
    if a==1
        yyaxis left
        set(ax_curve(a), 'yticklabel',0:10:cur_ylim(2))
        ylabel('Accuracy (%)', 'FontSize',fontsize_labels)
    end
    
    % --- data & phase labels ---
    
    % phase boundaries
    plot(repmat(phaseIntervals_scaled(2:end),2,1), repmat(cur_ylim,numel(phaseIntervals_scaled)-1,1)',...
        'LineStyle',':', 'LineWidth',2, 'Color',[.6 .6 .6], 'Marker','none')

    % phase labels
    labelPos = diff(phaseIntervals_scaled)/2 + phaseIntervals_scaled(1:end-1);
    for lp=1:numel(phaseNames)-1
        text(labelPos(lp),cur_ylim(1)-.5, phaseNames{lp},...
            'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',fontsize_axticks, 'FontAngle','Italic');
    end

    % chance level
    plot([1 nTimesteps], [50 50], 'Color','k', 'LineStyle','-.', 'Marker','none', 'LineWidth',2);

    for gd = 1:2
        
        currColor     = colors(gd,:);

        % true data
        plot([1:nTimesteps], currData.diagonalCurve(:,gd), 'Color',currColor, 'LineStyle','-', 'Marker','none', 'LineWidth',2);
        fill([1:nTimesteps flip(1:nTimesteps)],....
            [[currData.diagonalCurve(:,gd)+currData.diagonalCurve_sem(:,gd)]'   flip(currData.diagonalCurve(:,gd)-currData.diagonalCurve_sem(:,gd))'],...
            currColor, 'FaceAlpha',.5, 'EdgeColor','none');

        % clusters
        for cl=1:size(currData.significanceCurve{gd})
            xc = [currData.significanceCurve{gd}(cl,1) , currData.significanceCurve{gd}(cl,2)]+.5;
            line(ax_curve(a), xc,repmat((1-(2*gd-1)*.01)*cur_ylim(2),1,2), 'Color',currColor, 'LineWidth',3)
        end
        
    end % genDir generalization direction
    
    % common sample window
    if ~isempty(currData.sampleWindow)
        for sw=1:size(currData.sampleWindow,1)
            xc = [currData.sampleWindow(sw,1) currData.sampleWindow(sw,2)]+.5;
            fl = fill([xc(1) xc(1) xc(2) xc(2)],[cur_ylim flip(cur_ylim)],...
                'k', 'FaceAlpha',.1, 'EdgeColor','none');
            uistack(fl,'bottom')
        end
    end

    % --- external legend ---
    
    if a==1
        annotation('textbox','String','',...
            'Units','centimeters', 'Position',posClabel, 'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',fontsize_labels)
        cues = classLabels.cues;
        for gd = 1:2
            trainStimulus = cues{mod(gd+1,2)+1};
            testStimulus  = cues{mod(gd,2)+1};
            annotation('textarrow',...
                flip(posClines{gd}(1,:))/posFig(3), posClines{gd}(2,:)/posFig(4),...
                'String',['Trained on ',upper(trainStimulus(1)),trainStimulus(2:end),'s (',trainStimulus,'\bf\rightarrow\rm',testStimulus,')'],...
                'HeadStyle','none', 'Color',colors(gd,:), 'LineWidth',3, 'FontSize',fontsize_labels)
        end
    end
    
    % ... B/C: Cross-Temporal SVM matrix ..................................................................................................

    for gd = 1:2
        
        ax_MatSVM(a,gd) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posMatSVM(gd,:)+areaShift(a,:));
        axis square
        hold on
        
        % --- axis dimensions & labels ---
    
        mat_xylim = cur_xlim;
        mat_zlim  = [50 65];

        yyaxis left
        ax_MatSVM(a,gd).YAxis(1).Color = 'k';
        axis([mat_xylim mat_xylim])
        set(ax_MatSVM(a,gd),...
            'YDir','reverse',...
            'xtick',phaseIntervals_scaled, 'xticklabel',phaseIntervals_txt1, 'xticklabelrotation',90, ...
            'ytick',phaseIntervals_scaled, 'yticklabel',[],...
            'FontSize',fontsize_axticks);

        yyaxis right
        ax_MatSVM(a,gd).YAxis(2).Color = 'k';
        axis([mat_xylim mat_xylim])
        set(ax_MatSVM(a,gd),...
            'YDir','reverse',...
            'ytick',phaseIntervals_scaled, 'yticklabel',[],...
            'FontSize',fontsize_axticks);

        if a==1
            yyaxis left
            set(ax_MatSVM(a,gd), 'yticklabel',phaseIntervals_txt1);
            ylabel('Training Time (ms)', 'FontSize',fontsize_labels);
        end
        if gd==1
            set(ax_MatSVM(a,gd), 'xticklabel',[])
        else
            xlabel('Testing Time (ms)',  'FontSize',fontsize_labels);            
        end
        
        % --- data & phase labels ---
        
        % true data
        colormap(colmap)
        imagesc(currData.crossTrainingMatrix(:,:,gd), mat_zlim)

        % phase boundaries
        plot(repmat(phaseIntervals_scaled(2:end),2,1), repmat(mat_xylim,numel(phaseIntervals_scaled)-1,1)', ...
            'Color','w', 'Marker','none', 'LineStyle',':', 'LineWidth',2); % x-axis
        plot(repmat(mat_xylim,numel(phaseIntervals_scaled)-1,1)', repmat(phaseIntervals_scaled(2:end),2,1), ...
            'Color','w', 'Marker','none', 'LineStyle',':', 'LineWidth',2); % y-axis

        % phase labels
        labelPos = diff(phaseIntervals_scaled)/2 + phaseIntervals_scaled(1:end-1);
        for lp=1:numel(phaseNames)-1
             % x-axis
            if gd==2
                text(labelPos(lp),mat_xylim(2)+.005*nTimesteps, phaseNames{lp},...
                    'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',fontsize_axticks, 'FontAngle','italic');
            end
            % y-axis
            if a==1
                text(mat_xylim(1)-.0125*nTimesteps, labelPos(lp),phaseNames{lp},... 
                    'Rotation',90, 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'FontSize',fontsize_axticks, 'FontAngle','italic');
            end
        end

        % clusters
        contour(currData.significanceMatrix(:,:,gd), 1, 'Color',colors_contour, 'LineWidth',2)

    end % genDir generalization direction

    % --- external legend ---

    if a==1
        cbCT = colorbar;
        set(cbCT, 'Units','centimeters', 'Position',posCT, 'Orientation','Horizontal',...
            'Limits',mat_zlim, 'TickLength',.03,'Ticks',0:5:100, 'TickLabels',[], 'FontSize',fontsize_axticks)
        annotation('textbox','String','Accuracy (%):',...
            'Units','centimeters', 'Position',posCTlabel, 'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',fontsize_labels)
        annotation('textbox','String',mat_zlim(1),...
            'Units','centimeters', 'Position',posCTstart, 'HorizontalAlignment','right', 'VerticalAlignment','middle', 'EdgeColor','none', 'FontSize',fontsize_labels)
        annotation('textbox','String',mat_zlim(2),...
            'Units','centimeters', 'Position',posCTend, 'HorizontalAlignment','left', 'VerticalAlignment','middle', 'EdgeColor','none', 'FontSize',fontsize_labels)
    end

    % --- direction labels ---
    
    pathStim = 'StimulusImages/';
    
    if a==1
        for gd = 1:2
            trainStimulus = cues{mod(gd+1,2)+1};
            testStimulus  = cues{mod(gd,2)+1};
            currColor = colors(gd,:);
            
            axes(ax_MatSVM(a,gd))
            annotation('textbox','String','',...
                'Units','centimeters', 'Position',posDirBox(gd,:), 'EdgeColor',currColor)
            text(-22, mat_xylim(2), {'Train','Data'},... % y-axis
                'Rotation',90, 'HorizontalAlignment','left', 'VerticalAlignment','bottom',...
                'FontSize',fontsize_labels, 'FontWeight','bold', 'Color',currColor);
            text(-26, mat_xylim(2)/2+2, '>',... % y-axis
                'Rotation',90, 'HorizontalAlignment','left', 'VerticalAlignment','bottom',...
                'FontSize',fontsize_labels, 'FontWeight','bold', 'Color',currColor);
            text(-22, mat_xylim(2)/2-2, {'Test','Data'},... % y-axis
                'Rotation',90, 'HorizontalAlignment','left', 'VerticalAlignment','bottom',...
                'FontSize',fontsize_labels, 'FontWeight','bold', 'Color',currColor);
            stimNames = vertcat(classLabels.labels(~cellfun(@isempty, strfind(classLabels.labels,trainStimulus))),...
                         classLabels.labels(~cellfun(@isempty, strfind(classLabels.labels,testStimulus))));
            for st=1:numel(stimNames)
                stimImg = imread([pathStim,stimNames{st},'.png']);
                axStimY(st) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posDirStims(gd,:)+stimShift{gd}(st,:));
                image(imrotate(stimImg,90))
                axis square off
            end
        end
    end
    
end % a areas