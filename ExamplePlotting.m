%% Verification Stuff

imwrite(uint8(rokstack(:,:,70)),'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/rokstack70.tif','tif');
imwrite(uint8(rokstackF(:,:,70)),'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/rokstackF70.tif','tif');
%% image histogram plotting before and after filtering

% add one 255 intensity pixel to the unfiltered image to spread the
% histogram across the full x range
rokstack1 = rokstack;
rokstack1(1,1,70) = 255;


%% Regionprops
STATS2 = regionprops(ones(xdim,ydim,frame_num),rokstack1(:,:,:),'PixelValues');
STATS3 = regionprops(ones(xdim,ydim,frame_num),rokstackF(:,:,:),'PixelValues');
%% Histograms alone
binnum = 30;
xdata = 1:255;
figure(2) % unfiltered image w logistic filter
[f2,x2] = hist(STATS2.PixelValues,binnum);
bar(x2,f2,'FaceColor','blue')
title('Unfiltered Pixel Intensity')
xlabel('Pixel Intensity')
ylabel('Pixel Count')
ymax = max(f2);
xlim([0 255])
ylim([0 ymax+5000])

%use no adjusted rokstack for dispersion statistics:
STATS4 = regionprops(ones(xdim,ydim,frame_num),rokstack(:,:,:),'PixelValues');
[f4,x4] = hist(STATS4.PixelValues,100);
meanx4 = mean(STATS4.PixelValues);
modex4 = mode(STATS4.PixelValues);
hold on
line([meanx4,meanx4],[0,ymax+5000],'LineWidth',3,'Color','cyan')

%%
hold on

for x = 1:255
    y(x) = double(K*No)/(No+(K-No)*exp(-r*x));
end


%%
yscaled = (y - (nanmin(y)))/((max(y))-min(y)).*ymax;

plot(xdata,yscaled,'LineWidth',2,'Color','red')

figure(3) %filtered image
[f3,x3] = hist(STATS3.PixelValues,binnum);
bar(x3,f3,'FaceColor','green')
title('Filtered Pixel Intensity')
xlabel('Pixel Intensity')
ylabel('Pixel Count')
xlim([0 255])
ylim([0 ymax])


%% All figures superimposed

f4 = [f2;f3]'

figure %all three images together
hold on
h = bar(x2,f4,'BarWidth',1)
set(h(1),'FaceColor','blue')
set(h(2),'FaceColor','green')
plot(xdata,yscaled,'LineWidth',2,'Color','red')

xlim([0 255])
ylim([0 ymax+1000000])
title('Image Filtering')
legendstr = horzcat(['Logistic Function, r = ' num2str(r)]);
legend('Unfiltered Image','Filtered Image', legendstr)

