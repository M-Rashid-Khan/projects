dloc = 'D:\Rashid Data\FCN_SementicSeg\results\';% destination Classified images
loc = 'D:\Rashid Data\AnncientImages\extracted_dataset5\images\'; %read from location 
%list = dir([loc '*.bmp']);

a1 = imread([loc '1.bmp']);
a2 = imread([loc '2.bmp']);
a3 = imread([loc '3.bmp']);
a4 = imread([loc '4.bmp']);
a5 = imread([loc '5.bmp']);

a11 = imread([dloc '1_.bmp']);
a22 = imread([dloc '2_.bmp']);
a33 = imread([dloc '3_.bmp']);
a44 = imread([dloc '4_.bmp']);
a55 = imread([dloc '5_.bmp']);

figure;
subplot(1,2,1); imshow(a1)
subplot(1,2,2); imshow(a11)
figure;
subplot(1,2,1); imshow(a2)
subplot(1,2,2); imshow(a22)
figure;
subplot(1,2,1); imshow(a3)
subplot(1,2,2); imshow(a33)
figure;
subplot(1,2,1); imshow(a4)
subplot(1,2,2); imshow(a44)
figure;
subplot(1,2,1); imshow(a5)
subplot(1,2,2); imshow(a55)
