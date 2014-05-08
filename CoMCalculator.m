%% CoM Calculation
    %This script first generates masks for each cell at all time points in
    %the movie. It then makes histograms for the x and y axis in the mask,
    %computes the mean along each axis, and identifies the intersecting
    %point. This point is the CoM.
[frame_num,a,cell_num] = size(Vertx_pix)   
[xdim,ydim] = size(membranestack(:,:,1));

cellmask = zeros(xdim,ydim);

%% Making cell masks

SE = ones(2);%structuring element for eroding the edges of cells. This is to account for the uncertainty about pixel-cell assignment at membranes

for time = 1:frame_num
    time
    for cell = 1:cell_num
        if isnan(Vertx_pix{time,1,cell}) == 1 % checks to see whether there is actually a cell here.
            CellMask{cell,time} = (zeros(xdim,ydim));
     
        else
            xdata = Vertx_pix{time,1,cell};
            ydata = Verty_pix{time,1,cell};%loads x and y vertex coordinates for input to patch
           
            cellmask = poly2mask(xdata,ydata,xdim,ydim);
            CellMask{cell,time} = logical(cellmask);
            clear xdata ydata
        end
    end
    %Fmembranes(time) = getframe %capture movie
    %clear figure
end
%% Filtering Signal
    %Filters using a logistic function where the inflection point of the
    %logistic function lies at the 90th percentile.

K = 255 %max pixel intensity
No = 1 %min pixel intensity
thresh = 90 %use this value to determine the percentile in the pixel intensity distribution, and then use this to set the inflection point of the logistic function here.

%finding r
    %the strategy here is to find r so that the inflection point of the
    %logistic function is equal to the mean of the pixel intensity
    %distribution. The inflection point can be found by setting the second
    %derivative to 0, which leads to the expression:
        % 0 = r - 2rN/K
    %which shows that the inflection point occurs at N(t) = K/2. Plug this
    %into the logistic function to get:
        % K/2 = NoK/(No + (K - No)e^-rt))
    %solving for r, and assuming No = 1, 
        % r = ln(K-1)/t
    %This is useful because it lets you put the inflection point at
    %whatever value of t (or in our case, pixel intensity) you like by
    %changing r.

    %from empirical approaches, a good value for r is at the 90th
    %percentile of the pixel intensity distribution.

pixdist = regionprops(ones(xdim,ydim,frame_num),rokstack(:,:,:),'PixelValues');
pix = prctile(pixdist.PixelValues,thresh);

r = double(log(K-1)/pix)


for time = 1:frame_num
    for row = 1:xdim
        for col = 1:ydim
            pixel = double(rokstack(row,col,time));
            rokstackF(row,col,time) = (K*No)/(No+(K-No)*exp(-r*pixel));; %logistic function (population growth form)
        end
    end
    time
end

%figure
%tit(x) = getframe(imagesc(rokstackF(:,:,1)))
%imwrite(rokstackF(:,:,1),'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/TestImage.tif','tif')


%% Isolating Cells and Identifying Weighted Centroid coordinates

CoM_x = zeros(frame_num,cell_num);
CoM_y = zeros(frame_num,cell_num);
PixelList_x{frame_num,cell_num} = [];
PixelList_y{frame_num,cell_num} = [];
Area = zeros(frame_num,cell_num);
BBox{frame_num,cell_num} = [];
%structuring element for eroding the edges of cells. This is to account for the uncertainty about pixel-cell assignment at membranes

for time = 1:frame_num
    time
    for cell = 1:cell_num
        if isnan(Vertx_pix{time,1,cell}) == 1 % checks to see whether there is actually a cell here.
            continue;
        else
            BWMask = CellMask{cell,time}; %This is where the erosion occurs.
            iso_cell = (rokstackF(:,:,time));
       
           STATS = regionprops(BWMask,iso_cell,'WeightedCentroid','PixelList');
           CoM_x(time,cell) = round(STATS.WeightedCentroid(:,1));
           CoM_y(time,cell) = round(STATS.WeightedCentroid(:,2));
           PixelList_x{time,cell} = STATS.PixelList(:,1);
           PixelList_y{time,cell} = STATS.PixelList(:,2);
           %Area(time,cell) = (STATS.Area);
           %BBox(time,cell) = {STATS.BoundingBox};
       clear STATS
        end
    end
end



%% Trash
%{

%% Cropping mask and roksack w bounding box

croppedmask{frame_num,cell_num} = [];
croppedcell{frame_num,cell_num} = [];

for time = 1:frame_num
    time
    for cell = 1:cell_num
        if isempty(BBox{time,cell}) == 1
            continue;
        else
            xmin = BBox{time,cell}(1);
            ymin = BBox{time,cell}(2);
            width = BBox{time,cell}(3);
            height = BBox{time,cell}(4);
            rect = [xmin ymin width height];
            maskcrop = imcrop(CellMask{cell,time},rect);
            cellcrop = imcrop(rokstackF(:,:,time),rect);
            croppedmask{time,cell}(:,:) = maskcrop;
            croppedcell{time,cell}(:,:) = cellcrop;
        end
    end
end


            
            %{
            plot(1:xdim,rowpix_norm)
            set(gca, 'XTick',0:xdim)
            set(gca, 'YTick',0:255)
            %}

%}