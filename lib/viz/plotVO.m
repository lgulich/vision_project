function [last20FramesIdx_next, num_tracked_landmarks, t_W_C_all, ...
        trackedLandmarksOverLast20Frames] = plotVO( ...
    curr_state, T_W_C_curr, image, num_tracked_landmarks, t_W_C_all, ...
            trackedLandmarksOverLast20Frames, last20FramesIdx, ground_truth)

% Update plot data
curr_frame_idx = last20FramesIdx(end);
num_tracked_landmarks(curr_frame_idx) = size(curr_state.X,2);
t_W_C_all(:,curr_frame_idx) = T_W_C_curr([1,3],end);
% trackedLandmarksOverLast20Frames = circshift(trackedLandmarksOverLast20Frames,-1);
trackedLandmarksOverLast20Frames{end} = curr_state.X([1,3],:);

fig = figure(1);
fig.Position = [1 1 1920 1080];

% Top left plot
subplot(4,4,[1,2,5,6])
imshow(image), hold on
plot(curr_state.C(1,:)',curr_state.C(2,:)','rx'), hold on
plot(curr_state.P(1,:)',curr_state.P(2,:)','gx'), hold off
title('Current image.')
legend({'Candidate Keypoints $\quad\quad$', 'Actual Keypoints $\quad\quad$'}, 'FontSize', 8, ...
                                'Interpreter', 'latex')

% Bottom left
subplot(4,4,[9,13])
plot(last20FramesIdx-20, num_tracked_landmarks(last20FramesIdx))
title('Number of tracked landmarks over last 20 frames.')
axis('tight')
ylim([0,200])

% Bottom right
subplot(4,4,[10,14])
plot(t_W_C_all(1,1:curr_frame_idx), t_W_C_all(2,1:curr_frame_idx), ...
    'b-o', 'MarkerSize', 2.4, 'MarkerFaceColor', 'b'), grid off, axis equal
title('Full trajectory.')
set(gcf, 'GraphicsSmoothing', 'on')

% Right

% landmarks = cell2mat(trackedLandmarksOverLast20Frames);
% landmarks = unique(landmarks.', 'rows').';

subplot(4,4,[3,4,7,8,11,12,15,16])
plot(t_W_C_all(1,last20FramesIdx), t_W_C_all(2,last20FramesIdx),'b-o',...
            'MarkerSize', 1.6, 'MarkerFaceColor', 'b'), hold on
plot(trackedLandmarksOverLast20Frames{end}(1,:), trackedLandmarksOverLast20Frames{end}(2,:), 'kx', 'MarkerSize', 3.2)
grid off, axis equal, hold off
title('Trajectory of last 20 frames and landmarks.')
set(gcf, 'GraphicsSmoothing', 'on')

% xdist = abs(t_W_C_all(1,curr_frame_idx) - t_W_C_all(1,last20FramesIdx(1)))*2.4;
% zdist = abs(t_W_C_all(2,curr_frame_idx) - t_W_C_all(2,last20FramesIdx(1)))*2.4;
% xlim([t_W_C_all(1,curr_frame_idx)-xdist, t_W_C_all(1,curr_frame_idx)+xdist])
% ylim([t_W_C_all(2,curr_frame_idx)-zdist, t_W_C_all(2,curr_frame_idx)+zdist])
axis equal

% Update indexes
last20FramesIdx_next = last20FramesIdx + 1;

end