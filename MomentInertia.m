%% Moment of inertia Calculation
%First each cell needs to be scaled to have the same area. Do this by
%determining the mean area, and scaling each cell to that area.


%% calculate mu20 + mu02 to determine the moment of inertia

I = zeros(frame_num,cell_num);
for time = 1:frame_num
    time
    for cell = 1:cell_num
        if isempty(CellMask{cell,time}) == 1
            I(time,cell) = NaN;
        else
            
        lowx = min(PixelList_x{time,cell});
        highx = max(PixelList_x{time,cell});
        lowy = min(PixelList_y{time,cell});
        highy = max(PixelList_y{time,cell});
        xrange = [lowx:highx];
        yrange = [lowy:highy];
   
        
        cellmass_x = sum(CellMask{cell,time}.*rokstackF(:,:,time));
        cellmass_y = sum(CellMask{cell,time}.*rokstackF(:,:,time),2)';
        xrange_cent = xrange - CoM_x(time,cell);
        yrange_cent = yrange - CoM_y(time,cell);
            
        mu20 = sum((xrange_cent.^2).*cellmass_x(lowx:highx));
        mu02 = sum((yrange_cent.^2).*cellmass_y(lowy:highy));
        M00 = sum(sum(CellMask{cell,time}.*rokstackF(:,:,time)));
                
        eta20 = mu20/(M00^2);
        eta02 = mu20/(M00^2);
            
        I(time,cell) = eta20+eta02;
        end
    end
end


%% Plotting moment of inertia for individual cells
    Iscaled = (I - nanmin(nanmin(I)))/(max(max(I))-min(min(I)));
    a = isnan(Iscaled);
    IscaledNaN = Iscaled
    IscaledNaN(a) = 0;

    figure
    hold on
    xdata = 1:frame_num;
    ydata = Iscaled;
    plot(xdata,ydata)
    ylim([0 1])
    xlim([0 90])
    
    
    figure
    hold on
    ymeandata = nanmean(Iscaled,2)';
    Y = prctile(Iscaled,[2.5,97.5],2)';
    Y2(1,:) = Y(2,:);
    Y2(2,:) = Y(1,:);
    ylim([0 1])
    xlim([0 90])
  
    
   
    shadedErrorBar(xdata,ymeandata,Y2)
 

%% Plotting moment of inertia on membrane/rok signal overlay

Iscaled = (I - nanmin(nanmin(I)))/(max(max(I))-min(min(I)));
a = isnan(Iscaled);
Iscaled(a) = 0;

for time = 1:frame_num;
    figure
    imagesc(rokstackF(:,:,time))
    colormap(gray);
        hold on
    for cell = 1:cell_num
        
        %if isnan(Centx{time,1,cell}) == 1
           %cell = cell+1
        %else
            xdata = Vertx_pix{time,1,cell};
            ydata = Verty_pix{time,1,cell};
            patch(xdata,ydata,'white','FaceColor','green','FaceAlpha',Iscaled(time,cell),'EdgeColor','white')
            clear xdata ydata
            %text(CoM_x(time,cell)+2,CoM_y(time,cell),num2str(cell),'Color','white');
        %end
        
    end
    
    scatter(CoM_x(time,:),CoM_y(time,:),'o','cyan') %CoM centroid
    
    Frok(time) = getframe %capture movie
    clear figure
end

movie(Frok) %(F,x), where x is the number of times to repeat the movie
movie2avi(Frok,'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/MoIoverFrok_r0.16.avi')


%% Plotting Individual Cells
%dimensions of subplot matrix:
rowdim = 5
coldim = cell_num/5

figure
for p = 1:cell_num
    subplot(rowdim,coldim,p)
    xdata = 1:frame_num;
    ydata = Iscaled(:,p);
    sp = plot(xdata,ydata,'red',xdata,ymeandata,'black');
    title(strcat('Cell #',num2str(p)),'FontSize',8);
    set(gca,'XTick',0:15:90,'FontSize',3)
    ylabel('MoI');
    xlabel('frame');
    ylim([0 0.4]);
    xlim([0 90]);
end

%% Trash
%{
%% Area normalization
%{
AreaMean = sum(Area,2)./sum(Area~=0,2); %computes mean of non-zero elements in each row of Area, representing the area mean at each time point.

ScaleFactor = zeros(frame_num,cell_num);
for col = 1:cell_num
    ScaleFactor(:,col) = Area(:,col)./AreaMean;
end
%}

%alternative area normalization

for time = 1:frame_num
    time
    for cell = 1:cell_num
        [m,n] = size(croppedmask{time,cell});
        area = m*n;
        areamat(time,cell) = area;
    end
end

AreaMean2 = (sum(areamat,2))./(sum(areamat~=0,2))

ScaleFactor = zeros(frame_num,cell_num);
for col = 1:cell_num
    ScaleFactor(:,col) = sqrt(AreaMean2./areamat(:,col)); %square root of the scaling factor to account for the difference in area quotient vs. dimension scaling.
end


%% Resizing Cropped images from CoMCaluculator

cellmaskS{frame_num,cell_num} = [];
cellimageS{frame_num,cell_num} = [];

for time = 1:frame_num
    time
    for cell = 1:cell_num
        if isempty(croppedmask{time,cell}) == 1
            continue
        else
            sf = (ScaleFactor(time,cell)); 
            cellmask = croppedmask{time,cell};
            cellimage = croppedcell{time,cell};
            cellmaskS{time,cell} = imresize(cellmask,sf);  
            cellimageS{time,cell} = imresize(cellimage,sf);
        end
    end
end

%}