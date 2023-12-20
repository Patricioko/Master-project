clc();
clear();

%world coord.-------------------------------------------------------------------------
filename='xyz.csv';
orig_data=csvread(filename);

wframe=ones(4,100);
for ii=1:100
    wframe(1,ii)=orig_data(5,ii);
    wframe(2,ii)=orig_data(7,ii);
    wframe(3,ii)=orig_data(9,ii);
end



%camera0(right)--------------------------------------------------------------------
%關閉 for imshow
%input image

%for iii=1:99
want_check_num=24;

image_name0=['D:\study\Robotics_vision\fianl_projext\image0\',num2str(want_check_num),'.jpg'];
image0=imread(image_name0);

%camera0 model(right)
t0=[1.5 -5 1.5];
t0=t0';
Xrot0=[1 0 0;0 cosd(-100) -sind(-100);0 sind(-100) cosd(-100)];
Yrot0=[cosd(-15) 0 sind(-15);0 1 0;-sind(-15) 0 cosd(-15)];
%Zrot0=[cosd(-100) -sind(-100) 0;sind(-100) cosd(100) 0;0 0 1];
rot0=Xrot0*Yrot0;
rot0=inv(rot0);
t0=-rot0*t0;
T0=[rot0(1,1) rot0(1,2) rot0(1,3) t0(1,1);rot0(2,1) rot0(2,2) rot0(2,3) t0(2,1);rot0(3,1) rot0(3,2) rot0(3,3) t0(3,1);0 0 0 1];

P0=[450 0 0;0 450 0;0 0 1];

to3=[1 0 0 0;0 1 0 0;0 0 1 0];
Z0=T0*wframe(:,want_check_num);
uv0=(P0*to3*T0*wframe(:,want_check_num))/Z0(3,1);


figure(want_check_num);
imshow(image0); 
% hold on;
% plot(uv0(1,1)+256,uv0(2,1)+256,'*');
%plot(256,500,'*');

%end

%camera1 (left)------------------------------------------------------------------------------
%關閉 for imshow
%input image
%for iii=1:99
want_check_num=24;
image_name1=['D:\study\Robotics_vision\fianl_projext\image1\',num2str(want_check_num),'.jpg'];
image1=imread(image_name1);

%camera1 model(left)
t1=[-1.5, -5, 1.5];
t1=t1';
Xrot1=[1 0 0;0 cosd(-100) -sind(-100);0 sind(-100) cosd(-100)];
Yrot1=[cosd(15) 0 sind(15);0 1 0;-sind(15) 0 cosd(15)];
rot1=Xrot1*Yrot1;
rot1=inv(rot1);
t1=-rot1*t1;
T1=[rot1(1,1) rot1(1,2) rot1(1,3) t1(1,1);rot1(2,1) rot1(2,2) rot1(2,3) t1(2,1);rot1(3,1) rot1(3,2) rot1(3,3) t1(3,1);0 0 0 1];

P1=[450 0 0;0 450 0;0 0 1];

to3=[1 0 0 0;0 1 0 0;0 0 1 0];
Z1=T1*wframe(:,want_check_num);
uv1=(P1*to3*T1*wframe(:,want_check_num))/Z1(3,1);

figure(want_check_num+1)
imshow(image1+1); 
% hold on;
% plot(uv1(1,1)+256,uv1(2,1)+256,'*');
% %plot(256,500,'*');
%end


%stereo vision------------------------------------------------------------

%for iiii=1:99

%找圓心------------------------------    
want_check_num=25;
image_name0=['D:\study\Robotics_vision\fianl_projext\image0\',num2str(want_check_num),'.jpg'];
image0=imread(image_name0);

image_name1=['D:\study\Robotics_vision\fianl_projext\image1\',num2str(want_check_num),'.jpg'];
image1=imread(image_name1);

%imshow(image0);
image0_hsv = rgb2hsv(image0);      
image1_hsv = rgb2hsv(image1);    
% 創建一?黑色圖像，將特定?色提取到此處
image0_new = 0*ones(size(image0));
image1_new = 0*ones(size(image1));
% 將該圖像轉至hsv色彩空?
image0_new_hsv = rgb2hsv(image0_new);
image1_new_hsv = rgb2hsv(image1_new);
% 找出圖像中綠色的像素
[row0, col0] = ind2sub(size(image0_hsv),find(image0_hsv(:,:,1)>0.12...
& image0_hsv(:,:,1)< 0.6 & image0_hsv(:,:,2)>0.16 & image0_hsv(:,:,3)>0.18));
[row1, col1] = ind2sub(size(image1_hsv),find(image1_hsv(:,:,1)>0.12...
& image1_hsv(:,:,1)< 0.6 & image1_hsv(:,:,2)>0.16 & image1_hsv(:,:,3)>0.18));

% 將圖像中的綠色像素複製到剛才新建的白色圖像中
for i = 1 : length(row0)
    image0_new_hsv(row0(i),col0(i),:) = image0_hsv(row0(i),col0(i),:);
end

for i = 1 : length(row1)
    image1_new_hsv(row1(i),col1(i),:) = image1_hsv(row1(i),col1(i),:);
end


% 將提取出來的綠色，轉化至rgb空?，進行展示
image0_green = hsv2rgb(image0_new_hsv);
image1_green = hsv2rgb(image1_new_hsv);

[centers0,radii0,metric0] = imfindcircles(image0_green,[7,30],'ObjectPolarity','bright','Sensitivity',0.95,'EdgeThreshold',0.3);
[centers1,radii1,metric1] = imfindcircles(image1_green,[7,40],'ObjectPolarity','bright','Sensitivity',0.95,'EdgeThreshold',0.3);

centers0
centers1

right_name=['right_',num2str(want_check_num)];
figure('Name',right_name,'NumberTitle','off');
imshow(image0_green);
hold on;
if isempty(centers0)==1
    %continue
else 
    plot(centers0(1,1),centers0(1,2),'*');
    hBright = viscircles(centers0, radii0,'Color','b');
end


left_name=['left_',num2str(want_check_num)];

figure('Name',left_name,'NumberTitle','off');
imshow(image1_green);
hold on;
if isempty(centers1)==1
    %continue
else 
    plot(centers1(1,1),centers1(1,2),'*');
    hBright = viscircles(centers1, radii1,'Color','b');
end


%回推world frame
if isempty(centers0)==1 || isempty(centers1)==1
    %continue
else
    m0=[centers0(1,1) centers0(1,2) 1];
    A0=[1 0 256;0 1 256;0 0 1];
    v00=m0*(A0*P0*to3*T0);
    
    m1=[centers1(1,1) centers1(1,2) 1];
    A1=[1 0 256;0 1 256;0 0 1]
    v11=m1*(A1*P1*to3*T1);
    
    V_uv2world=[v00(1,1) v00(1,2) v00(1,3);v11(1,1) v11(1,2) v11(1,3)];
    b=[-v00(1,4);-v11(1,4)];
    xyz=inv(transpose(V_uv2world)*V_uv2world)*transpose(V_uv2world)*b
end
wframe(:,want_check_num)

%end



%check imfindcircle is useful---------------------------------------------
% image_ex=imread('D:\study\Robotics_vision\fianl_projext\circcle.png');
% image_gray=rgb2gray(image_ex);
% [centers,radii] = imfindcircles(image_ex,[10,35],'ObjectPolarity','dark','Sensitivity',0.9)
% imshow(image_ex);
% h = viscircles(centers,radii);
% centers