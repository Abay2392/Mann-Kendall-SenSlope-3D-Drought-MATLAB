% Load the necessary data
load SPI_Data.mat
load spei_data.mat

% Assuming you have Z1, Z3, Z6, Z12, Z24, spei_1, spei_3, spei_6, spei_12, spei_24 as 3D arrays with dimensions 33x18x888
datasets = {'Z1', 'Z3', 'Z6', 'Z12', 'Z24', 'spei_1', 'spei_3', 'spei_6', 'spei_12', 'spei_24'};
alpha = 0.05; % Significance level for Mann-Kendall test
alpha_ac = 0.05; % Autocorrelation correction level

results = cell(1, numel(datasets)); % Initialize a cell array to store results

for d = 1:numel(datasets)
    % Get the current dataset
    eval(['data = ', datasets{d}, ';']);
    
    % Initialize matrices to store Mann-Kendall results
    NaN_matrix = NaN(size(data, 1), size(data, 2));
    tau = NaN(size(data, 1), size(data, 2));
    z = NaN(size(data, 1), size(data, 2));
    p = NaN(size(data, 1), size(data, 2));
    H = NaN(size(data, 1), size(data, 2));
    b_sen = NaN(size(data, 1), size(data, 2));
    
    % Loop through each grid cell
    for i = 1:size(data, 1)
        for ii = 1:size(data, 2)
            % Check number of NaN in grid cell
            NaN_matrix(i, ii) = sum(isnan(data(i, ii, :)));
            
            % Speed up computation by skipping grid cells with too many NaNs
            if NaN_matrix(i, ii) < 24
                % Squeeze the data to remove singleton dimensions
                data1 = squeeze(data(i, ii, :));
                
                % Remove NaN values from the series
                if sum(isnan(data1)) >= 1
                    data1(isnan(data1)) = [];
                end
                
                % Define a dummy time vector
                t1 = 1:numel(data1);
                
                % Perform Mann-Kendall test for autocorrelated data
                [tau(i, ii), z(i, ii), p(i, ii), H(i, ii), b_sen(i, ii)] = Modified_MannKendall_test(t1, data1, alpha, alpha_ac);
            else
                % If too many NaNs, set results to NaN
                tau(i, ii) = NaN;
                z(i, ii) = NaN;
                p(i, ii) = NaN;
                H(i, ii) = NaN;
            end
        end
    end
    
    % Store results for the current dataset
    results{d}.dataset = datasets{d};
    results{d}.tau = tau;
    results{d}.z = z;
    results{d}.p = p;
    results{d}.H = H;
    results{d}.b_sen = b_sen;
end

% Define the mapping parameters
shapefile = 'Italia_Regioni_GEO.shp';
s1 = shaperead(shapefile);
minlat = 36.2;
maxlat = 41;
minlon = 12;
maxlon = 17.6;
lon_map = ncread('EV_SIC_2023_12.nc', 'longitude');
lat_map = ncread('EV_SIC_2023_12.nc', 'latitude');

% Create the meshgrid for the map
[LATMAP, LONMAP] = meshgrid(double(lat_map), double(lon_map));

% Define the dataset names and titles
dataset_names = {'Z1', 'Z3', 'Z6', 'Z12', 'Z24', 'spei_1', 'spei_3', 'spei_6', 'spei_12', 'spei_24'};
titles = {'SPI 1', 'SPI 3', 'SPI 6', 'SPI 12', 'SPI 24', 'SPEI 1', 'SPEI 3', 'SPEI 6', 'SPEI 12', 'SPEI 24'};

% Define a custom colormap for the classifications (Increasing, No Trend, Decreasing)
custom_cmap = [0.6 1 0.6;  % Light Green for Decreasing (-1)
               1 1 1;      % White for No Trend (0)
               0.5 0 0];   % Dark Red for Increasing (1)

% Define a colormap for continuous b_sen values
b_sen_cmap = parula;

% Create a tiled layout with compact spacing
tiledlayout(2, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

% Loop through each dataset to plot the classified H values
for i = 1:length(results)
    % Get the current H dataset
    H_data = results{i}.H;
    
    % Plot the classified H values
    nexttile; % Move to the next tile
    ax = gca;
    axesm('MapProjection', 'mercator', 'MapLatLimit', [minlat maxlat], 'MapLonLimit', [minlon maxlon]);
    gridm on;
    h = surfm(LATMAP, LONMAP, H_data); % Plot H data
    set(h, 'FaceAlpha', 'flat', 'AlphaDataMapping', 'none', 'AlphaData', ~isnan(H_data)); % Set transparency
    plotm(s1(19).Y, s1(19).X, 'k', 'linewidth', 2); % Display the shapefile
    title(titles{i});
    
    % Set the custom colormap and color limits for classification
    colormap(ax, custom_cmap);
    caxis([-1 1]);
end

% Create a shared colorbar for H values
% cb = colorbar('southoutside');
% cb.Ticks = [-1, 0, 1];
% cb.Position = [0.1, 0.05, 0.8, 0.03];
% cb.FontSize = 14;
% cb.Label.FontWeight="bold";
% cb.TickLabels = {'Decreasing', 'No Trend', 'Increasing'};
% cb.Label.String = 'Trend Classification'; % Label for the colorbar
% cb.FontSize = 14; % Font size for colorbar labels

%% Create a new tiled layout for b_sen values
figure;
tiledlayout(2, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

% Loop through each dataset to plot the continuous b_sen values
for i = 1:length(results)
    % Get the current b_sen dataset
    b_sen_data = results{i}.b_sen;
    
    % Plot the continuous b_sen values
    nexttile; % Move to the next tile
    ax = gca;
    axesm('MapProjection', 'mercator', 'MapLatLimit', [minlat maxlat], 'MapLonLimit', [minlon maxlon]);
    gridm on;
    h = surfm(LATMAP, LONMAP, b_sen_data); % Plot b_sen data
    set(h, 'FaceAlpha', 'flat', 'AlphaDataMapping', 'none', 'AlphaData', ~isnan(b_sen_data)); % Set transparency
    plotm(s1(19).Y, s1(19).X, 'k', 'linewidth', 2); % Display the shapefile
    title([titles{i}]);
    
    % Set the colormap for continuous b_sen values
    colormap(ax, b_sen_cmap); % You can choose any other colormap as desired
    caxis([-1 1]); % Set color axis limits to [-1 1] for all subplots
end

% Create a shared colorbar for b_sen values
% Add a single colorbar at the bottom
cb.Ticks = [-1,0, -0,8, -0,6 -0,4, -0,2, 0, 0.2, 0.4, 0.6, 0.8, 1];
cb = colorbar('southoutside');
cb.Label.String = "Sen Slope Values"; % Label for the colorbar
cb.FontSize = 14; % Font size for colorbar labels
cb.Position = [0.1, 0.05, 0.8, 0.03];
cb.TickLabels = cellstr(num2str(cb.Ticks', '%.1f'));
cb.TickLabels = strrep(cb.TickLabels, '-', '−'); 
cb.Label.FontWeight="bold";
% Adjust the figure properties
set(gcf, 'Position', [100, 100, 1500, 800]); % Adjust the size of the figure window

% Adjust the figure properties
set(gcf, 'Position', [100, 100, 1500, 800]); % Adjust the size of the figure window
