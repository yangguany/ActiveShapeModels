
function plotLandmarks(landmarks,varargin)
% PLOTLANDMARKS plots all of the aligned landmarks from an active shapes model
%
%	INPUT
%       landmarks: The aligned landmarks from multiple images
%                  [2*n_landmarks x n_shapes]
%
%   See also PLACELANDMARKS, ALIGNSHAPES
%
% John W. Miller
% 14-Mar-2017

% Key-value pair varargin
keys = {'show_lines','hold_on'}; default_values = {0,0};
[show_lines,hold_on] = parseKeyValuePairs(varargin,keys,default_values);

% Plot the landmarks for each shape
n_shapes = size(landmarks,2);
if hold_on
    h = gcf;
else
    h = figure;
end
hold on
try colors = parula(n_shapes);
catch
    colors = hsv(n_shapes);
end
for n_shape = 1:n_shapes
    iShape = [landmarks(1:2:end,n_shape) landmarks(2:2:end,n_shape)];
    plot(iShape(:,1),iShape(:,2),'o','color', colors(n_shape,:),...
        'linewidth',2,'markersize',2,'markerfacecolor',colors(n_shape,:))
end

% Add mean shape to the plot
if n_shapes > 1
    meanShape = mean(landmarks,2); % x1, y1, x2, y2, ..., x20, y20
else
    meanShape = landmarks;
end
ax = plot(meanShape(1:2:end),meanShape(2:2:end),'ko',...
    'markersize',5,'linewidth',3,'markerfacecolor','k');

% Connect dots on the face (optional)
if show_lines    
    faceLabels = getFaceRegions();
    
    mew = [meanShape(1:2:end) meanShape(2:2:end)];
    for i = 1:length(faceLabels)
        plot(mew(faceLabels{i},1), mew(faceLabels{i},2), 'g-','linewidth',1)
    end
end

% Touch up the plot
legend(ax,{'Mean shape'},'fontsize',FS,'location','southeast')
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
axis off;
set(gca,'YDir','reverse');
text(0.05,0.5,sprintf('n=%d',n_shapes),'units','normalized','fontsize',FS,'fontweight','bold')

end % End of main