%% Plotting CoM on Membrane or Rok Making membrane overlay


%This is a compilation of BuildPolygons.m and the stuff below. It
%simultaneously plots membrane overlay, CoM coordinates, and a background
%image.

for time = 1:frame_num;
    
    colscatter(1:cell_num) = 0; %declare/clear column coordinate matrix for CoM
    rowscatter(1:cell_num) = 0; %declare/clear row coordinate for CoM
    centcolscatter(1:cell_num) = 0;
    centrowscatter(1:cell_num) = 0;
    
    figure %establish frame
    imagesc(rokstack(:,:,time))%print correct timepoint background image
    colormap(gray)
    hold on
    for cell = 1:cell_num
        if isempty(CoM_x(time,cell)) == 1
            continue
        else
        colscatter(cell) = CoM_x(time,cell); %populate CoM matrices with coordinate data
        rowscatter(cell) = CoM_y(time,cell);
        
        centcolscatter(cell) = Centx_pix{time,1,cell}; %use this code to plot the Vertex-derived centroids as well. Useful comparison.
        centrowscatter(cell) = Centy_pix{time,1,cell};
        
        end
    end
    
    for cell = 1:cell_num
        
        if isnan(Centx{time,1,cell}) == 1
            cell = cell+1
        else
            xdata = Vertx_pix{time,1,cell}; %loads x and y vertex coordinates for input to patch
            ydata = Verty_pix{time,1,cell};
            patch(xdata,ydata,'white','FaceColor','none','EdgeColor','white')
            clear xdata ydata
        end
    end
        
    scatter(colscatter,rowscatter,'o','cyan') %CoM centroid
    scatter(centcolscatter,centrowscatter,'*','red') %Vertex-derived centroid
    handle = gca
   
    Frok(time) = getframe;  %capture movie for making the movie.
    clear figure
    
    % imwrite(frame2im(Frok(70)),'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/rokstackF70_CoM_Memb.tif','tif')
   
end


%% Play and save movie
%movie(Fmembranes) %(F,x), where x is the number of times to repeat the movie
%movie2avi(Fmembranes,'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/membranesoverlay.avi')

movie(Frok)
movie2avi(Frok,'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/CoMregionprops_filteredr_0.15.avi')


%this is the original script used to convert the CoM coordinates into a
%plottable format
%{ 
for time = 1:frame_num
    colscatter = zeros(cell_num,1);
    rowscatter = zeros(cell_num,1);
    
    imagesc(rokstack(:,:,time))
    hold on
    
    for cell = 1:cell_num
        cell
        colscatter(cell) = CoM{time}(cell,1);
        rowscatter(cell) = CoM{time}(cell,2);
        
        xdata = Vertx_pix{time,1,cell};
        ydata = Verty_pix{time,1,cell};
        patch(xdata,ydata,'o','FaceColor','none')
    end
        
        scatter(colscatter,rowscatter,'o','o')
end
%}