clear all;
clc;

load('D:\Rashid Data\CNN\26022020\CNN2', 'convnet', 'TR');
load('D:\Rashid Data\CNN\Datasaved.mat');

YTest = classify(convnet,testDigitData);
TTest = testDigitData.Labels;
accuracy = sum(YTest == TTest)/numel(TTest);
class1 = sum(TTest(:)=='background_only');
class2 = sum(TTest(:)=='bleedthrough_only'); 
class3 = sum(TTest(:)=='bleedthrough_text');
class4 = sum(TTest(:)=='text_only');
s1=0;
s2=0;
s3=0;
s4=0;
for n = 1:length(TTest)
    if TTest(n) == 'background_only'
        if YTest(n)== 'background_only'
            s1 = s1 +1;
        end
    end
    if TTest(n) == 'bleedthrough_only'
        if YTest(n)== 'bleedthrough_only'
            s2 = s2 +1;
        end
    end
    if TTest(n) == 'bleedthrough_text'
        if YTest(n)== 'bleedthrough_text'
            s3 = s3 +1;
        end
    end
    if TTest(n) == 'text_only'
        if YTest(n)== 'text_only'
            s4 = s4 +1;
        end
    end
end

acc_background_only = s1/class1;
acc_bleedthrough_only = s2/class2;
acc_bleedthrough_text = s3/class3;
acc_text_only = s4/class4;
figure('Name','Per Class Accuracy','NumberTitle','off');
set(0, 'DefaultAxesFontName', 'Times new roman')
Y = [acc_background_only,acc_bleedthrough_only,acc_bleedthrough_text,acc_text_only];
Y= Y.*100;
X = categorical({'Background','Bleedthrough','Bleedthrough and Text','Text'});
%X= reordercats(X,{'Background','Bleedthrough','Bleedthrough & Text','Text'});
b= bar(X,Y);
b.EdgeColor = 'none';

ylim([0 110])
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
saveas(b,'perClassAccuracy.png')