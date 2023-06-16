load('D:\Rashid Data\models\trainedCNN\', 'convnet', 'TR')
loc= 'D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse images-refined\background_only\';
loc2='D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse images-refined\bleedthrough_only\';
loc3='D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse label-refined\bleedthrough_text\';
loc4='D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse images-refined\text_only\';
list = dir([loc '*.bmp']);
L1 = length(list);
count1 = 0;
for i = 1:1:length(list)
    spatch = imread([loc list(i).name]);
    rm = mean(spatch(:,1)); 
    gm = mean(spatch(:,2));
    bm = mean(spatch(:,3));
    spatch(:,1) = spatch(:,1)-rm;
    spatch(:,2) = spatch(:,2)-gm;
    spatch(:,3) = spatch(:,3)-bm;
    result = classify(convnet,spatch);
    if result == 'background_only'
        count1 = count1 + 1;
    end
    
end
list = dir([loc2 '*.bmp']);
L2 = length(list);
count2 = 0;
for i = 1:1:length(list)
    spatch = imread([loc2 list(i).name]);
    rm = mean(spatch(:,1)); 
    gm = mean(spatch(:,2));
    bm = mean(spatch(:,3));
    spatch(:,1) = spatch(:,1)-rm;
    spatch(:,2) = spatch(:,2)-gm;
    spatch(:,3) = spatch(:,3)-bm;
    result = classify(convnet,spatch);
    if result == 'bleedthrough_only'
        count2 = count2 + 1;
    end
    
end
list = dir([loc3 '*.bmp']);
L3 = length(list);
count3 = 0;
for i = 1:1:length(list)
    spatch = imread([loc3 list(i).name]);
    rm = mean(spatch(:,1)); 
    gm = mean(spatch(:,2));
    bm = mean(spatch(:,3));
    spatch(:,1) = spatch(:,1)-rm;
    spatch(:,2) = spatch(:,2)-gm;
    spatch(:,3) = spatch(:,3)-bm;
    result = classify(convnet,spatch);
    if result == 'bleedthrough_text'
        count3 = count3 + 1;
    end
    
end
list = dir([loc4 '*.bmp']);
L4 = length(list);
count4 = 0;
for i = 1:1:length(list)
    spatch = imread([loc4 list(i).name]);
    rm = mean(spatch(:,1)); 
    gm = mean(spatch(:,2));
    bm = mean(spatch(:,3));
    spatch(:,1) = spatch(:,1)-rm;
    spatch(:,2) = spatch(:,2)-gm;
    spatch(:,3) = spatch(:,3)-bm;
    result = classify(convnet,spatch);
    if result == 'text_only'
        count4 = count4 + 1;
    end
    
end
acc_background_only = count1/L1;
acc_bleedthrough_only = count2/L2;
acc_bleedthrough_text = count3/L3;
acc_text_only = count4/L4;

figure('Name','Full Class Accuracy','NumberTitle','off');
Y = [acc_background_only,acc_bleedthrough_only,acc_bleedthrough_text,acc_text_only];
Y= Y.*100;
X = categorical({'Background','Bleedthrough','Bleedthrough & Text','Text'});
%X= reordercats(X,{'Background','Bleedthrough','Bleedthrough & Text','Text'});
b= bar(X,Y);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')