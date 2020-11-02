%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here is a sample classification algorithm, it is the simple (yet very competitive) one-nearest
% neighbor using the Euclidean distance.
% If you are advocating a new distance measure you just need to change the line marked "Euclidean distance"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [distance, predicted_class, index] = Classification_Algorithm_ED(TRAIN,TRAIN_class_labels,unknown_object)
best_so_far = inf;
for i = 1 : length(TRAIN_class_labels)
    compare_to_this_object = TRAIN(i,:);
    distance(i,1) = sqrt(sum((compare_to_this_object - unknown_object).^2)); % Euclidean distance
    %       distance(i,1)=dtw(compare_to_this_object,unknown_object); % Dynamic Time Warping distance
    
    if distance(i,1) < best_so_far
        predicted_class = TRAIN_class_labels(i);
        best_so_far = distance(i,1);
        index = i;
    end
end



