%% Building cell polygons


%% Making membrane overlay
for time = 1:frame_num;
    figure
    imagesc(membranestack(:,:,time))
        hold on
    for cell = 1:cell_num
        
        if isnan(Centx{time,1,cell}) == 1
            cell = cell+1
        else
            xdata = Vertx_pix{time,1,cell}; %loads x and y vertex coordinates for input to patch
            ydata = Verty_pix{time,1,cell};
            patch(xdata,ydata,'white','FaceColor','none')
            clear xdata ydata
        end
    end
    Fmembranes(time) = getframe %capture movie
    clear figure
end

%% Making rok overlay
for time = 1:frame_num;
    figure
    imagesc(rokstack(:,:,time))
        hold on
    for cell = 1:cell_num
        
        if isnan(Centx{time,1,cell}) == 1
            cell = cell+1
        else
            xdata = Vertx_pix{time,1,cell};
            ydata = Verty_pix{time,1,cell};
            patch(xdata,ydata,'white','FaceColor','none')
            clear xdata ydata
        end
    end
    Frok(time) = getframe %capture movie
    clear figure
end


    
    % testing to make sure that coordinat system is correctly calibrated
%{
imagesc(membranestack(:,:,time))
hold on
for cell = 1:cell_num;
scatter(Centx_pix{time,1,cell},Centy_pix{time,1,cell},'*','o')
end
%}  
    
   
    
%% Play and save movie
movie(Fmembranes) %(F,x), where x is the number of times to repeat the movie
movie2avi(Fmembranes,'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/membranesoverlay.avi')

movie(Frok)
movie2avi(Frok,'/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/rokoverlay.avi')