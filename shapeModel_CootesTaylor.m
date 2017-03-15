% SHAPEMODEL_COOTESTAYLOR
%
%
%
%
%   Shape analysis techniques based on this paper:
%   Cootes, T. F., Taylor, C. J., Cooper, D. H., & Graham, J. (1995).
%       "Active Shape Models-Their Training and Application. Computer Vision and
%       Image Understanding."
%
%
%
% John W. Miller
% 16-Feb-2017


%% Faces
% [landmarks,idxs] = placeLandmarks(pathToImages,20,10);
% load('landmarks_faces_set01')
load('./Landmarks/landmarks_faces_A_23')
landmarksTraining = allLandmarks;
alignedShapes = alignShapes(landmarksTraining,0);
plotLandmarks(alignedShapes)

% Create PCA model (on a subset of shapes)
x = alignedShapes(:,1:20);
xBar = mean(x,2);  % Mean shape
S = cov(x');       % Covariance matrix
[V,D] = eig(S);    % Eigenvectors
D = sort(diag(D),'descend');
V = fliplr(V);

%% Get weights for first 3 PCs and plot them to check for independence between the PCs
P = V(:,1:3);
weights = P'*(alignedShapes-repmat(xBar,1,size(alignedShapes,2)));
figure
plot3(weights(1,:),weights(2,:),weights(3,:),'o')
xlabel('b1','fontsize',FS), ylabel('b2','fontsize',FS), zlabel('b3','fontsize',FS), grid on


%% Get weights for a new shape
n_pcs = 3;
y = alignedShapes(:,21);

% Solve for the weights that will approximate the new shape using the model
P = V(:,1:n_pcs);
b = P'*(y-xBar);

newShape = xBar + P*b;
figure, hold on
plot(y(1:2:end),y(2:2:end),'ko','linewidth',1)
plot(newShape(1:2:end),newShape(2:2:end),'r.','markersize',10,'linewidth',2)
set(gca,'ydir','reverse')
legend({'Real','Model'},'location','best')
title(sprintf('Approximation of new shape using first %d PCs from the model',n_pcs),'fontsize',FS)





%% Connect dots around the face
faceLabels = cell(7,1);
faceLabels{1} = 1:3;
faceLabels{2} = 4:6;
faceLabels{3} = 7:9;
faceLabels{4} = 10:12;
faceLabels{5} = 13:15;
faceLabels{6} = [16:19 16];
faceLabels{7} = 20;


%% Examine variations from individual PCs
n_pc = 1;
b = sqrt(D(n_pc))*(-3:3);
n_vars = length(b);

% Create some shape variations
P = V(:,n_pc);
shapeVariations = repmat(xBar,1,n_vars) + P*b;
xLim = [floor(min(min(shapeVariations(1:2:end,:)))) ceil(max(max(shapeVariations(1:2:end))))];
yLim = [floor(min(min(shapeVariations(2:2:end,:)))) ceil(max(max(shapeVariations(2:2:end))))];


% Color variation
mew(:,1) = xBar(1:2:end);
mew(:,2) = xBar(2:2:end);
figure, hold on
colors = hsv(n_vars);
for n = 1:n_vars    
    iVar = zeros(size(shapeVariations,1)/2,2);
    iVar(:,1) = shapeVariations(1:2:end,n);
    iVar(:,2) = shapeVariations(2:2:end,n);
    
    % Plot the PC variations
    plot(iVar(:,1),iVar(:,2),'o','color',colors(n,:))
    
    % Connect the dots
    for i = 1:length(faceLabels)
        plot(mew(faceLabels{i},1), mew(faceLabels{i},2), 'k-','linewidth',1)
        plot(iVar(faceLabels{i},1),iVar(faceLabels{i},2), '-','linewidth',1,'color',colors(n,:))
    end
    
end
plot(xBar(1:2:end),xBar(2:2:end),'k.','linewidth',3)
set(gca,'ydir','reverse'), axis square
xlim(xLim), ylim(yLim)
title(sprintf('Variation of PC #%d'n,n_pc),'fontsize',20)

% % Subplots
% figure, subplot(1,n_vars,1);
% for n = 1:n_vars
%     subplot(1,n_vars,n);
%     plot(shapeVariations(1:2:end,n),shapeVariations(2:2:end,n),'o')
%     set(gca,'ydir','reverse')
%     axis square
%     xlim(xLim), ylim(yLim)
% end





