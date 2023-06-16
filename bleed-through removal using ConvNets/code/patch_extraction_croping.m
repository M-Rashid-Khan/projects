labloc = 'D:\Rashid Data\AnncientImages\extracted_dataset\labels\';

loc = 'D:\Rashid Data\AnncientImages\extracted_dataset\coarse samples\coarse images-refined\bleedthrough_text\';
list = dir([loc '*.bmp']);


for ii = 1:1:length(list)
    
    fn = list(ii).name;
    fName = [labloc fn];
    if ~exist(fName, 'file')
        continue;
    end
    
    img = imread(fName);
    imwrite(img, './cleanversion.bmp', 'bmp');
    img = imread([loc fn]);
    imwrite(img, './noisyversion.bmp', 'bmp');

end
