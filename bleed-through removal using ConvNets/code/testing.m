disp('Loading the save model')
load('D:\Rashid Data\models\trainedCNN\', 'convnet', 'TR')
load('D:\Rashid Data\datasets\extracted_dataset\', 'testDigitData')

YTest = classify(convnet,testDigitData);
TTest = testDigitData.Labels;

accuracy = sum(YTest == TTest)/numel(TTest);
accuracy = accuracy.* 100;
%fprintf('Over All Accuracy %d\n',accuracy);
figure('Name','Training Returns','NumberTitle','off');
subplot(2,1,1), plot(TR.TrainingAccuracy(1:100:end))
title('TrainingAccuracy')
subplot(2,1,2), plot(TR.TrainingLoss(1:100:end))
title('TrainingLoss')
% 
rm = mean(spatch(:,1)); 
gm = mean(spatch(:,2));
bm = mean(spatch(:,3));
spatch(:,1) = spatch(:,1)-rm;
spatch(:,2) = spatch(:,2)-gm;
spatch(:,3) = spatch(:,3)-bm;
[predictions, scores] = classify(convnet,spatch)