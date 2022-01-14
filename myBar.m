function myBar (XData,YData, FaceColor, FaceAlpha, EdgeColor)

if length(XData)~=length(YData)
    error('Vectors must be the same length.')
end

hold on
for x=1:length(XData)
    fill([XData(x)-.4 XData(x)+.4 XData(x)+.4 XData(x)-.4], [0 0 repmat(YData(x),1,2)],...
        FaceColor, 'FaceAlpha',FaceAlpha, 'EdgeColor',EdgeColor)
end