%% Extracting Data from Edge Output
timestep = 8.3;
xydim = 0.13; %this is the xy dimension from the metadata, where xydim = microns/pixel. This number needs to be the same as was used in 
                %Edge, which can be verified by looking at the .csv file in Matlab/EDGE-1.06/
    conv_fact = (1/xydim); % pixels/micron
zkeep = '_z008'; %zslice to keep
memchannel = '_c002'; %membrane channel
rokchannel = '_c001'; %Rok (or other signal) channel

%% File Names

rokfileRoot = '/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/Image5_011113/Myosin/Image5_011113_t';
%moefile = '/Users/Jonathan/MATLAB/BlebQuant/FixedMoeBlebs/PhallSqhMoe_2/PhallSqhMoe_2_z007_c003.tif'; %adjust the 'z007' here to change the slice.
membraneRoot = '/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/Image5_011113/Membranes/Raw/Image5_011113_t';%make this the file used for Edge membrane segmentation
measdir = '/Users/jcoravos/Documents/MATLAB/EDGE-1.06/DATA_GUI/Image5_011113/Measurements/';
    measCenty = 'Membranes--basic_2d--Centroid-y.mat';
    measCentx = 'Membranes--basic_2d--Centroid-x.mat';
    measVerty = 'Membranes--vertices--Vertex-y.mat';
    measVertx = 'Membranes--vertices--Vertex-x.mat';
    measArea =  'Membranes--basic_2d--Area.mat';
    measPerim = 'Membranes--basic_2d--Perimeter.mat';
    myoInt = 'Myosin--myosin_intensity--Myosin intensity.mat';
    
    
%% Load Measurements
    % this section extracts a single slice (specified by the y coordinate in .data(...).
    % the x coordinate is the cell index, and the y coordinate is time step.
    
    %NOTE: NEED TO VERIFY THAT THE second value in Centy.data(a,b,c)
    %corresponds to the slice of the embryo you edged! 1 is the first
    %slice, 2, is the second, etc.
    
    slice = 2
Centy = load(strcat(measdir,measCenty));
    Centy = Centy.data(:,slice ,:);
    %[m n p] = size(Centy);
    %Centy = reshape(Centy,p,m);
Centx = load(strcat(measdir,measCentx));
    Centx = Centx.data(:,slice,:);
    %[m n p] = size(Centx);
    %Centx = reshape(Centx,p,m);
Verty = load(strcat(measdir,measVerty));
    Verty = Verty.data(:,slice,:);
    %[m n p] = size(Verty);
    %Verty = reshape(Verty,p,m);
Vertx = load(strcat(measdir,measVertx));
    Vertx = Vertx.data(:,slice,:);
    %[m n p] = size(Vertx);
    %Vertx = reshape(Vertx,p,m);
Area = load(strcat(measdir,measArea));
     Area = squeeze(cell2mat(Area.data(:,slice,:)));
     %[m n p] = size(Area);
     %Area = reshape(Area,p,m);
Perim = load(strcat(measdir,measPerim));
    Perim = Perim.data(:,slice,:);
    %[m n p] = size(Perim);
    %Perim = reshape(Perim,p,m);
RokInt = load(strcat(measdir,myoInt));
%% Determine framenum and cellnum
    [frame_num,cell_num] = size(Area)

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
%imread(strcat(membraneRoot,'001_z005_c002.tif'));   %declaring membranestack matrix
%[m,n] = size(ans); %this size is in pixels, not microns
%membranestack = zeros(m,n,frame_num); %x position is frame 
%rokstack = zeros(m,n,frame_num);

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


