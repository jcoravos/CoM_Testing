%% Extracting Data from Edge Output

frame_num = 90; %time frames in stack
xydim = 0.15; %this is the xy dimension from the metadata, where xydim = microns/pixel. This number needs to be the same as was used in 
                %Edge, which can be verified by looking at the .csv file in Matlab/EDGE-1.06/
    conv_fact = (1/xydim); % pixels/micron
zkeep = '_z005'; %zslice to keep
memchannel = '_c002'; %membrane channel
rokchannel = '_c001'; %Rok (or other signal) channel

%% File Names

rokfileRoot = '/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/Myosin/Image35_082013_t';
%moefile = '/Users/Jonathan/MATLAB/BlebQuant/FixedMoeBlebs/PhallSqhMoe_2/PhallSqhMoe_2_z007_c003.tif'; %adjust the 'z007' here to change the slice.
membraneRoot = '/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/Membranes/Raw/Image35_082013_t';%make this the file used for Edge membrane segmentation
measdir = '/Users/Jonathan/Documents/Matlab/EDGE-1.06/DATA_GUI/CoM Testing/Measurements/';
    measCenty = 'Membranes--basic_2d--Centroid-y.mat';
    measCentx = 'Membranes--basic_2d--Centroid-x.mat';
    measVerty = 'Membranes--vertices--Vertex-y.mat';
    measVertx = 'Membranes--vertices--Vertex-x.mat';
    measArea =  'Membranes--basic_2d--Area.mat';
    measPerim = 'Membranes--basic_2d--Perimeter.mat';
    
    
%% Load Measurements
    % this section extracts a single slice (specified by the y coordinate in .data(...).
    % the x coordinate is the cell index, and the y coordinate is time step.
Centy = load(strcat(measdir,measCenty));
    Centy = Centy.data(:,1,:);
    %[m n p] = size(Centy);
    %Centy = reshape(Centy,p,m);
Centx = load(strcat(measdir,measCentx));
    Centx = Centx.data(:,1,:);
    %[m n p] = size(Centx);
    %Centx = reshape(Centx,p,m);
Verty = load(strcat(measdir,measVerty));
    Verty = Verty.data(:,1,:);
    %[m n p] = size(Verty);
    %Verty = reshape(Verty,p,m);
Vertx = load(strcat(measdir,measVertx));
    Vertx = Vertx.data(:,1,:);
    %[m n p] = size(Vertx);
    %Vertx = reshape(Vertx,p,m);
Area = load(strcat(measdir,measArea));
     Area = Area.data(:,1,:);
     %[m n p] = size(Area);
     %Area = reshape(Area,p,m);
Perim = load(strcat(measdir,measPerim));
    Perim = Perim.data(:,1,:);
    %[m n p] = size(Perim);
    %Perim = reshape(Perim,p,m);
%% Convert from microns to pixels
    % all the above cells are in microns. Multiply each cell by the
    % conversion factor (above) to convert to pixels
    Centy_pix = gmultiply(Centy,conv_fact);
    Centx_pix = gmultiply(Centx,conv_fact);
    Verty_pix = gmultiply(Verty,conv_fact);
    Vertx_pix = gmultiply(Vertx,conv_fact);
    Area_pix = gmultiply(Area,conv_fact);
    Perim_pix = gmultiply(Perim,conv_fact);

%% Load Membrane and Rok movie
    %loads tif image sequences from Edge analysis into time stacks (3d) 
imread(strcat(membraneRoot,'001_z005_c002.tif'));   %declaring membranestack matrix
[m,n] = size(ans); %this size is in pixels, not microns
membranestack = zeros(m,n,frame_num); %x position is frame 
rokstack = zeros(m,n,frame_num);

for frame = 1:frame_num;
    if frame < 10
        timestep = strcat('00',num2str(frame));
    else
        timestep = strcat('0',num2str(frame));
    end
    mem_file = strcat(membraneRoot,timestep,zkeep,memchannel,'.tif');
    rok_file = strcat(rokfileRoot, timestep, zkeep,rokchannel,'.tif');
    
    membranestack(:,:,frame) = imread(mem_file);
    rokstack(:,:,frame) = imread(rok_file);

end
    
    
%% Clean up

clear measCenty measCentx measVerty measVertx measArea measPerim measdir


