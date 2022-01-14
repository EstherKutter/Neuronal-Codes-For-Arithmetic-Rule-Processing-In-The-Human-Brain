clear, clc
close all

load('data_ANOVA.mat', 'anovaTable','areaCounter')

%% ----- Visualization Parameters -----------------------------------------

areas                = {'TOTAL','PHC','EC','HIPP','AMY'};

phaseNames           = {'Calculation Rule^1','Rule Delay^1','Operand 2^2','Delay 2^2'};
xtickPhase           = [ 3.5                  11             19            28];
xtickPhaseDelimiters = [            7.5             14.5           23.5];

factorNames          = {'Rule',      'Only Rule',  'Cue',        'Only Cue',  'Format',     'Operand 1',  'Operand 2', 'Calculation Result'};
colors               =  [128 0 0;    166 76 76;    209 191 39;   223 210 103; 162 203 65;   70 39 154;    125 103 184; 181 169 215] / 255;
xtickPerFac          = {[1,9,16,25], [2,10,17,26], [3,11,18,27], [4],         [5,12,19,28], [6,13,20,29], [21,30],     [22,31]};

ticks                = {'A','B','C','D','E'};
stars                = {'','*','*','*'};

percs                = squeeze(cell2mat(anovaTable(1:end-1,1:end-1,2,:)));
binoms               = squeeze(cell2mat(anovaTable(1:end-1,1:end-1,3,:)));

% --- positions ---

xlims = [0 32];
ylims = [zeros(numel(areas),1)   ceil(squeeze(max(max(percs)))/5)*5];

posFig      = [.1  1.2  18  25];

% area panels
panSizeX = 14;
panSizeY = 17/sum(ylims(:,2)/5) .* ylims(:,2)/5;
panSizeY = flip(panSizeY);
posPanels = [3  3.5 panSizeX panSizeY(1)];
for ar=2:numel(areas)
    posPanels(ar,:) = [3 posPanels(ar-1,2)+panSizeY(ar-1)+.9  panSizeX panSizeY(ar)];
end % ar areas
posPanels = flip(posPanels,1);
posPanels(1,2) = posPanels(1,2)+.4;

% ticks A-E
posTicks = [repmat(.01,5,1)  posPanels(:,2)+posPanels(:,4)-.1  repmat([.5 .5],5,1)];

% legend
posLegend = [3 .3 14 2.3];
rectPosX = linspace(posLegend(1)+.1,sum(posLegend([1,3])),5);
rectPosX(2) = rectPosX(2)-.2;  rectPosX(3) = rectPosX(3)+.9;  rectPosX(4) = rectPosX(4)+.5;  % corrections due to different factorText lengths
rectPosY = linspace(posLegend(2)+.1,sum(posLegend([2,4])),5);
rectSizeXY = [.8 .4];
posFacsRect = [reshape(repmat(rectPosX(1:4),2,1),8,1)+.2 ... % posX
               repmat(rectPosY([3,2])',4,1) ... % posY
               repmat(rectSizeXY,8,1)]; % sizeXY
posFacsRect = posFacsRect([5:8,1:4],:);  % reorder
posFacsLabel = posFacsRect;
posFacsLabel(:,1) = posFacsLabel(:,1)+rectSizeXY(1);
posFacsLabel(:,3) = 3;


%% ----- Visualization ----------------------------------------------------

figSVM = figure('Units','centimeters','Position',posFig,...
    'Color','w', 'PaperPositionMode','auto', 'visible','on');

% --- legend ---

annotation('textbox', 'Units','centimeters', 'Position',posLegend)
annotation('textbox', 'Units','centimeters', 'Position',[rectPosX(1) rectPosY(4) posLegend(3) rectSizeXY(2)],...
    'String','Number Conditions',...
    'LineStyle','none', 'VerticalAlignment','middle', 'FontSize',9, 'FontWeight','bold')
annotation('textbox', 'Units','centimeters', 'Position',[rectPosX(3) rectPosY(4) posLegend(3) rectSizeXY(2)],...
    'String','Operator Conditions',...
    'LineStyle','none', 'VerticalAlignment','middle', 'FontSize',9, 'FontWeight','bold')
for f=1:numel(factorNames)
    annotation('rectangle', 'Units','centimeters', 'Position',posFacsRect(f,:),...
        'FaceColor',colors(f,:))
    annotation('textbox', 'Units','centimeters', 'Position',posFacsLabel(f,:),...
        'String',factorNames{f},...
        'LineStyle','none', 'FontSize',9, 'VerticalAlignment','middle')
end
annotation('textbox', 'Units','centimeters', 'Position',[rectPosX(1) rectPosY(1)-.03 posLegend(3) rectSizeXY(2)],...
    'String', 'Analysis:',...
    'LineStyle','none', 'VerticalAlignment','middle', 'FontSize',9, 'FontWeight','bold')
annotation('textbox', 'Units','centimeters', 'Position',[rectPosX(1)+1.6 rectPosY(1) posLegend(3) rectSizeXY(2)],...
    'String', '^{1}4-Factor ANOVA     ^{2}6-Factor ANOVA',...
    'LineStyle','none', 'VerticalAlignment','middle', 'FontSize',9)

% --- area panels ---

for a=1:numel(areas)
    
    % panel tick
    annotation('textbox', 'Units','centimeters', 'Position',posTicks(a,:),...
        'String', ticks{a},...
        'LineStyle','none', 'HorizontalAlignment','left', 'VerticalAlignment','top', 'FontSize',14, 'FontWeight','bold')
    
    % current data
    currPercs  = {percs(1,:,a),  percs(2,:,a),  percs(3,:,a),  percs(4,1,a),  percs(5,:,a),  percs(6,:,a),  percs(7,3:4,a),  percs(8,3:4,a)};
    currBinoms = {binoms(1,:,a), binoms(2,:,a), binoms(3,:,a), binoms(4,1,a), binoms(5,:,a), binoms(6,:,a), binoms(7,3:4,a), binoms(8,3:4,a)};
    %             RULE           RULE-ONLY      CUE            CUE-ONLY       FOR            NUM1           NUM2             NUMR

    axData(a) = axes('Parent',figSVM, 'Units','centimeters', 'Position',posPanels(a,:));
    hold on
    axis([xlims ylims(a,:)])
    % data
    for d=1:length(currPercs)
        myBar(xtickPerFac{d}, currPercs{d},colors(d,:),1,'k');
        % p-values from binomial test
        for t=1:length(xtickPerFac{d})
            text(xtickPerFac{d}(t), currPercs{d}(t)+1, ...
                [stars{[10 .05 .01 .001] >= currBinoms{d}(t)}],...
                'HorizontalAlignment','center')
        end        
    end
    
    % task delimiter
    plot(repmat(xtickPhaseDelimiters,2,1), repmat(ylims(a,:),numel(xtickPhaseDelimiters),1)', 'Color','k', 'LineStyle',':')
    % area label + number of units in area
    text(xlims(1)-4.5,.5*diff(ylims(a,:)), {areas{a},['({\itn}=',num2str(areaCounter(a)),')']}, 'Rotation',90, 'FontSize',12, 'FontWeight','bold', 'HorizontalAlignment','center')
    
    % axis labeling
    set(gca, 'XTick',xtickPhase, 'XTickLabel',phaseNames)
    set(gca, 'YTick',ylims(a,1):5:ylims(a,2), 'ygrid','on')
    if ylims(a,2) <= 10
        ylabel('Sig. Units (%)')
    else
        ylabel('Significant Units (%)')
    end

end % a areas

% delimiter between TOTAL and single areas
annotation('line',[.5 17.5]/posFig(3),repmat(posPanels(1,2)-.9,1,2)/posFig(4), 'LineWidth',2)