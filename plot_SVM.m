clear, clc
close all

load('data_SVM.mat', 'dataSVM','classLabels')

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
fontsize_titles  = fac*16;
fontsize_labels  = fac*14;
fontsize_axticks = fac*11;
fontsize_ticks   = fac*20;

colmap           = 'jet';
colors_contour   = 'k';

colors           = [  0 114 189]/255;

% colorbar 0-blue -> white -> red-100
pr = 20; % how fine-grained steps are
colormapRedBlue = ...
    [[linspace(0,255*pr/(pr+1),pr); linspace(0,255*pr/(pr+1),pr); repmat(255,1,pr)]';...
    [255 255 255];...
    flip([repmat(255,1,pr); linspace(0,255*pr/(pr+1),pr); linspace(0,255*pr/(pr+1),pr)]')] / 255;

% --- positions of figure elements ---

posFig      = fac*[ .1    1.3    39.6  27];

% area label
posArea     = fac*[ .5    26.1    11.1    .7];
areaShift   = fac*[[0 : 9.2 : 35]' zeros(4,3)];

% diagonal curve
posCurve    = fac*[1.7   22.1   8.5   3.7];

% confusion matrix
posMatrix   = fac*[4.55               14.225                    5.75  5.75];
% stimuli      posX                   posY                      sizeX + sizeY
posStimX    = fac*[[4.55 7.45];       repmat(13.325,1,2);       repmat(2.825,2,2)]';
posStimY    = fac*[repmat(3.05,1,4);  flip(14.225:1.47:19.67);  repmat(1.37,2,4)]';
posStimY2   = fac*[repmat(2.15,1,2);  [17.175 14.225];          repmat(2.825,2,2)]';

% legend - confusion matrix
posFW       = fac*[28.3  11.95  10    .5];
posFWstart  = fac*[27.7  11.95    .5  .5];
posFWend    = fac*[38.3  11.95    .5  .5];
posFWlabel  = fac*[20.7  11.85  18.8  .7];

% crosstemporal matrix
posMatSVM   = fac*[1.7   2.7   8.5   8.5];

% legend - crosstemporal matrix
posCT       = fac*[28.5  .2  10    .5];
posCTstart  = fac*[27.9  .2    .5  .5];
posCTend    = fac*[38.5  .2    .5  .5];
posCTlabel  = fac*[24.1  .1  15.4  .7];

% panel ticks
tickShift  = areaShift; tickShift(1,1) = -.8;
posTicks    = [repmat(posCurve(1)-.3,3,1) ...
               [ posCurve(2)+posCurve(4) ; posMatrix(2)+posMatrix(4) ; posMatSVM(2)+posMatSVM(4) ] ...
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
    currData = dataSVM.(currArea);
    
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
    cur_ylim = [45 75];

    yyaxis left
    ax_curve(a).YAxis(1).Color = 'k';
    axis([cur_xlim  cur_ylim])
    set(ax_curve(a),...
        'xtick',phaseIntervals_scaled, 'xticklabel',phaseIntervals_txt1, 'xticklabelrotation',90,...
        'ytick',0:10:cur_ylim(2), 'yticklabel',[], 'yminortick','on', ...
        'ticklength',[.03 .01], 'FontSize',fontsize_axticks)
    ax_curve(a).YAxis(1).MinorTickValues = 0:5:cur_ylim(2);
    
    yyaxis right
    ax_curve(a).YAxis(2).Color = 'k';
    axis([cur_xlim  cur_ylim])
    set(ax_curve(a),...
        'ytick',0:10:cur_ylim(2), 'yticklabel',[], 'yminortick','on',...
        'FontSize',fontsize_axticks)
    ax_curve(a).YAxis(2).MinorTickValues = 0:5:cur_ylim(2);
    
    xlabel('Time (ms)', 'FontSize',fontsize_labels);
    if a==1
        yyaxis left
        set(ax_curve(a), 'yticklabel',0:10:cur_ylim(2))
        ylabel('Accuracy (%)', 'FontSize',fontsize_labels)
    elseif a==4
        yyaxis right
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
    
    % true data
    plot([1:nTimesteps], currData.diagonalCurve, 'Color',colors, 'LineStyle','-', 'Marker','none', 'LineWidth',2);
    fill([1:nTimesteps flip(1:nTimesteps)],...
        [currData.diagonalCurve+currData.diagonalCurve_sem   flip(currData.diagonalCurve-currData.diagonalCurve_sem)],...
        colors, 'FaceAlpha',.5, 'EdgeColor','none');
    
    % clusters
    for cl=1:size(currData.significanceCurve,1)
        xc = [currData.significanceCurve(cl,1) , currData.significanceCurve(cl,2)]+.5;
        line(ax_curve(a), xc,repmat(.99*cur_ylim(2),1,2), 'Color','k', 'LineWidth',3)
        fl = fill([xc(1) xc(1) xc(2) xc(2)],[cur_ylim flip(cur_ylim)],...
            'k', 'FaceAlpha',.1, 'EdgeColor','none');
        uistack(fl,'bottom')
    end    
    
    
    % ... B: Fixed-Window SVM ..........................................................................................................
    
    nlabels     = 2;
    nconditions = 4;

    % --- stimulus images ---
    
    pathStim = 'StimulusImages/';
    
    % addition/subtraction
    for n=1:nlabels
        % x-axis
        axStimX(a,n) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posStimX(n,:)+areaShift(a,:));
        labImg = imread([pathStim,classLabels.classes{n},'_xaxis.png']);
        image(labImg)
        axis square off
        % y-axis
        axStimY2(a,n) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posStimY2(n,:)+areaShift(a,:));
        labImg = imread([pathStim,classLabels.classes{n},'_yaxis.png']);
        image(labImg)
        axis square off
    end
    
    % rule cues
    for n=1:nconditions
        axStimY(a,n) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posStimY(n,:)+areaShift(a,:));
        stimImg = imread([pathStim,classLabels.labels{n},'.png']);
        image(stimImg)
        axis square off
    end
    
    % --- confusion matrix ---
    
    axMat(a) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posMatrix+areaShift(a,:));
    colormap(axMat(a),colormapRedBlue)
    imagesc(currData.confusionMatrix,[0 100])
    % axis stuff
    axis square
    axis([.5 nlabels+.5 .5 nconditions+.5])
    set(axMat(a), 'xtick',[], 'ytick',[])
    % axis labels
    text(axMat(a), -0.45,2.5,  'True Class',...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', 'FontSize',fontsize_labels, 'Rotation',90)
    text(axMat(a), 1.5,5.35, 'Predicted Class',...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', 'FontSize',fontsize_labels)

    % --- external legend ---
    
    if a==1
        cbFW = colorbar;
        set(cbFW, 'Units','centimeters', 'Position',posFW, 'Orientation','Horizontal',...
            'Limits',[0 100], 'TickLength',.03,'Ticks',0:20:100, 'TickLabels',[], 'FontSize',fontsize_axticks)
        annotation('textbox','String','Classification Probability (%):',...
            'Units','centimeters', 'Position',posFWlabel, 'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',fontsize_labels)
        annotation('textbox','String','0',...
            'Units','centimeters', 'Position',posFWstart, 'HorizontalAlignment','right', 'VerticalAlignment','middle', 'EdgeColor','none', 'FontSize',fontsize_labels)
        annotation('textbox','String','100',...
            'Units','centimeters', 'Position',posFWend, 'HorizontalAlignment','left', 'VerticalAlignment','middle', 'EdgeColor','none', 'FontSize',fontsize_labels)
    end
    
    
    % ... C: Cross-Temporal SVM matrix ....................................................................................................
    
    ax_MatSVM(a) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posMatSVM+areaShift(a,:));
    axis square
    hold on
    
    % --- axis dimensions & labels ---
    
    mat_xylim = cur_xlim;
    mat_zlim  = [50 65];

    yyaxis left
    ax_MatSVM(a).YAxis(1).Color = 'k';
    axis([mat_xylim mat_xylim])
    set(ax_MatSVM(a),...
        'YDir','reverse',...
        'xtick',phaseIntervals_scaled, 'xticklabel',phaseIntervals_txt1, 'xticklabelrotation',90, ...
        'ytick',phaseIntervals_scaled, 'yticklabel',[],...
        'FontSize',fontsize_axticks);
    
    yyaxis right
    ax_MatSVM(a).YAxis(2).Color = 'k';
    axis([mat_xylim mat_xylim])
    set(ax_MatSVM(a),...
        'YDir','reverse',...
        'ytick',phaseIntervals_scaled, 'yticklabel',[],...
        'FontSize',fontsize_axticks);
    
    xlabel('Testing Time (ms)',  'FontSize',fontsize_labels);
    if a==1
        yyaxis left
        set(ax_MatSVM(a), 'yticklabel',phaseIntervals_txt1);
        ylabel('Training Time (ms)', 'FontSize',fontsize_labels);
    elseif a==4
        yyaxis right
        set(ax_MatSVM(a), 'yticklabel',phaseIntervals_txt2);
        ylabel('Training Time (ms)', 'FontSize',fontsize_labels);
    end
    
    % --- data & phase labels ---
    
    % true data
    colormap(colmap)
    imagesc(currData.crossTrainingMatrix, mat_zlim)
    
    % phase boundaries
    plot(repmat(phaseIntervals_scaled(2:end),2,1), repmat(mat_xylim,numel(phaseIntervals_scaled)-1,1)', ...
        'Color','w', 'Marker','none', 'LineStyle',':', 'LineWidth',2); % x-axis
    plot(repmat(mat_xylim,numel(phaseIntervals_scaled)-1,1)', repmat(phaseIntervals_scaled(2:end),2,1), ...
        'Color','w', 'Marker','none', 'LineStyle',':', 'LineWidth',2); % y-axis
    
    % phase labels
    labelPos = diff(phaseIntervals_scaled)/2 + phaseIntervals_scaled(1:end-1);
    for lp=1:numel(phaseNames)-1
        text(labelPos(lp),mat_xylim(2)-.004*nTimesteps, phaseNames{lp},... % x-axis
            'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',fontsize_axticks, 'FontAngle','italic');
        if a==1
            text(mat_xylim(1)-.0125*nTimesteps, labelPos(lp),phaseNames{lp},... % y-axis
                'Rotation',90, 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'FontSize',fontsize_axticks, 'FontAngle','italic');
        elseif a==4
            text(mat_xylim(2)+.07*nTimesteps, labelPos(lp),phaseNames{lp},... % y-axis
                'Rotation',90, 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'FontSize',fontsize_axticks, 'FontAngle','italic');
        end
    end
    
    % clusters
    contour(currData.significanceMatrix, 1, 'Color',colors_contour, 'LineWidth',2)
    
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
    
    clear diagonalCurve diagonalCurve_sem significanceCurve ...
         confusionMatrix ...
         crossTrainingMatrix significanceMatrix
         
end % a areas