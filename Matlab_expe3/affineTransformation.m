function outputImg = affineTransformation(inputImg)
%�����任����
s = 0.7;
m = 0.4;
theta = pi / 6;
T = [m*cos(theta)  s*sin(theta) 0;
     -m*sin(theta) s*cos(theta) 0;
     0 0 1];
%���νṹ�任��ʽΪaffine
tform = maketform('affine', T);
%���з���任
outputImg = imtransform(inputImg, tform);