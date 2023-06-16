labloc = 'D:\Rashid Data\AnncientImages\extracted_dataset2\labels\';

loc = 'D:\Rashid Data\AnncientImages\extracted_dataset2\train\';
list = dir([loc '*.bmp']);


for ii = 1:1:length(list)
    
    fn = list(ii).name;
    fName = [labloc fn];
    if ~exist(fName, 'file')
        continue;
    end
    
    img = imread(fName);
    imwrite(img, ['D:\Rashid Data\AnncientImages\extracted_dataset2\refined\cleaned\',fn] , 'bmp');
    img = imread([loc fn]);
    imwrite(img, ['D:\Rashid Data\AnncientImages\extracted_dataset2\refined\noisy\',fn] , 'bmp');

end
