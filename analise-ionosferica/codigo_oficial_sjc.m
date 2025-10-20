clear all;
close all;
clc;

% Load the data from the provided file
filename1 = 'dados_juntos_laura_sjc.txt';
filename2 = 'dados_juntos_josy_sjc.txt';
filename3 = 'dados_juntos_gabi_sjc.txt';

% Open the file for reading
fileID = fopen(filename1, 'r');
data1 = textscan(fileID, '%s %s %s %f %f %f', 'HeaderLines', 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true);
fclose(fileID);

% Open the file for reading
fileID = fopen(filename2, 'r');
data2 = textscan(fileID, '%s %s %s %f %f %f', 'HeaderLines', 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true);
fclose(fileID);

% Open the file for reading
fileID = fopen(filename3, 'r');
data3 = textscan(fileID, '%s %s %s %f %f %f', 'HeaderLines', 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true);
fclose(fileID);



% Extract columns from data
date_str = data1{1};    % Date strings
time_str = data1{3};    % Time strings



foF2 = nanmean([data1{4} data2{4} data3{4}],2);        % foF2 data
hF = nanmean([data1{5} data2{5} data3{5}],2);           % h'F data
hmF2 = nanmean([data1{6} data2{6} data3{6}],2);         % hmF2 data



% Load data from the provided file
data = importdata('omni-010817_310817.txt');

% Extract necessary variables
Vsw = data(:,6);   % Solar wind speed (km/s)
Nsw = data(:,7);   % Proton density (N/cm^3)
Bz = data(:,5);    % IMF Bz (nT)
SymH = data(:,9);  % Sym-H index (nT)
AE = data(:,8);    % AE index (nT)

% Define the time axis (assuming time is represented as minutely data points)
time2 = linspace(datenum(2017,8,1), datenum(2017,09,1), length(Vsw));

% Combine date and time strings into a single datetime array
datetime_str = strcat(date_str, {' '}, time_str);
time = datetime(datetime_str, 'InputFormat', 'yyyy.MM.dd HH:mm:ss');



% Generate a complete time series with 15-minute intervals
start_time = min(time);
end_time = max(time);
full_time = time;

% Convert datetime to serial date numbers for plotting
full_time_numeric = datenum(full_time);

% Initialize arrays to store complete data
full_foF2 = NaN(size(full_time));
full_hF = NaN(size(full_time));
full_hmF2 = NaN(size(full_time));

% Fill the complete data arrays
[~, ia, ib] = intersect(full_time, time);
full_foF2(ia) = foF2(ib);
full_hF(ia) = hF(ib);
full_hmF2(ia) = hmF2(ib);

% Load the variables from the 'mediasedesvios.mat' file
load('mediasedesvios.mat', 'mediahF', 'desviohF', 'mediaf0F2', 'desviof0F2', 'mediahmF2', 'desviohmF2');

grayColor = [0.7, 0.7, 0.7];  % Light gray

% Create a single figure with 7 subplots
figure;



% substituí os NaN do desviohmF2 por 0
desviohmF2(isnan(desviohmF2)) = 0;

% substituí os NaN do desviof0F2 por 0
desviof0F2(isnan(desviof0F2)) = 0;


figure1=figure(1)


% Plot Sym H
subplot(7,1,1);
plot(time2, SymH, 'b-', 'LineWidth', 2);

% Set major ticks larger and custom labels with days
ax = gca;

% Definir os mesmos limites de eixo X para todos os subplots
x_limits = [min(full_time_numeric), max(full_time_numeric)]; % Usar os limites dos dados ionosféricos
xlim(x_limits);

ax.XAxis.LineWidth = 2; % Increase major tick line width

% Destacar ticks principais
ax.TickDir = 'in';
ax.TickLength = [0.01 0.01]; % Ticks principais mais longos

ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
ylabel('SymH (nT)');
%datetick('x','mm/dd','keeplimits');
set(gca, 'XTickLabel', []); % Remove x-tick labels
grid on;

% Set minor ticks on the x-axis
ax = gca;
% Configurar ticks menores
ax.XMinorTick = 'on';
ax.MinorGridAlpha = 0.5;
minor_ticks = x_limits(1):0.2498:x_limits(2); % Ticks menores
ax.XAxis.MinorTickValues = minor_ticks;

% 4. Ajuste dos limites para evitar espaço extra
xlim([min(time2) max(time2)]);





% Plot h'F with area fill for standard deviation
subplot(7,1,2);
plot(full_time_numeric, full_hF, '-b');
% Set major ticks larger and custom labels with days
ax = gca;
ax.XAxis.LineWidth = 2; % Increase major tick line width
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
hold on;
mediahF=repmat(mediahF,31,1);
desviohF=repmat(desviohF,31,1);
plot(full_time_numeric, mediahF, 'k-', 'LineWidth', 2);
fill_area_x = [full_time_numeric; flipud(full_time_numeric)];
fill_area_y = [mediahF + desviohF; flipud(mediahF - desviohF)];
fill(fill_area_x, fill_area_y, grayColor, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
ylabel('h''F (km)');
set(gca, 'XTickLabel', []); % Remove x-tick labels
grid on;


% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on'; % Enable minor ticks
ax.MinorGridAlpha = 0.5; % Make minor grid lines semi-transparent

% Correctly set minor ticks for datetime x-axis using datenum
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
ax.XAxis.MinorTickValues = minor_ticks; % Set minor tick values

% 4. Ajuste dos limites para evitar espaço extra
xlim([min(time2) max(time2)]);




% Plot hmF2 with area fill for standard deviation
subplot(7,1,3);
plot(full_time_numeric, full_hmF2, '-b');
% Set major ticks larger and custom labels with days
ax = gca;
ax.XAxis.LineWidth = 2; % Increase major tick line width
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
%ax.XTickLabel = datestr(linspace(min(full_time_numeric), max(full_time_numeric), 12), 'dd-mmm'); % Label major ticks with days
hold on
grid on;
hold on;
find(isnan(desviohmF2))

mediahmF2=repmat(mediahmF2,31,1);
desviohmF2=repmat(desviohmF2,31,1);

plot(full_time_numeric, mediahmF2, 'k-', 'LineWidth', 2);
fill_area_x = [full_time_numeric; flipud(full_time_numeric)];
fill_area_y = [mediahmF2 + desviohmF2; flipud(mediahmF2 - desviohmF2)];
fill(fill_area_x, fill_area_y, grayColor, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
ylabel('hmF2 (km)');
set(gca, 'XTickLabel', []); % Remove x-tick labels
grid on;

% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on'; % Enable minor ticks
ax.MinorGridAlpha = 0.5; % Make minor grid lines semi-transparent

% Correctly set minor ticks for datetime x-axis using datenum
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
ax.XAxis.MinorTickValues = minor_ticks; % Set minor tick values

% 4. Ajuste dos limites para evitar espaço extra
xlim([min(time2) max(time2)]);




% Plot foF2 with area fill for standard deviation
subplot(7,1,4);
plot(full_time_numeric, full_foF2, '-b'); % Plot foF2 data
% Set major ticks larger and custom labels with days
ax = gca;
ax.XAxis.LineWidth = 2; % Increase major tick line width
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
%ax.XTickLabel = datestr(linspace(min(full_time_numeric), max(full_time_numeric), 12), 'dd-mmm'); % Label major ticks with days
hold on
grid on;
hold on;
mediaf0F2=repmat(mediaf0F2,31,1);
desviof0F2=repmat(desviof0F2,31,1);
plot(full_time_numeric, mediaf0F2, 'k-', 'LineWidth', 2);
fill_area_x = [full_time_numeric; flipud(full_time_numeric)];
fill_area_y = [mediaf0F2 + desviof0F2; flipud(mediaf0F2 - desviof0F2)];
fill(fill_area_x, fill_area_y, grayColor, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
ylabel('foF2 (MHz)');
set(gca, 'XTickLabel', []); % Remove x-tick labels
grid on;

% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on'; % Enable minor ticks
ax.MinorGridAlpha = 0.5; % Make minor grid lines semi-transparent

% Correctly set minor ticks for datetime x-axis using datenum
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
ax.XAxis.MinorTickValues = minor_ticks; % Set minor tick values

% 4. Ajuste dos limites para evitar espaço extra
xlim([min(time2) max(time2)]);


% Create a new figure for point-by-point differences

%calculo das médias noturnas
MAEnoitehF = mean(abs(mediahF(253:288,1)));
MAEnoitef0F2 = mean(abs(mediaf0F2(253:288,1)));
MAEnoitehmF2 = mean(abs(mediahmF2(253:288,1)));


% Create combined plot with separate y-axes for differences
subplot(7,1,5);

% Plot differences for h'F
yyaxis left;
diff_hF = full_hF - mediahF;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - LINHA AZUL
diff_hF_plot = diff_hF;  % Manter cópia original
nan_mask = isnan(diff_hF_plot);
%diff_hF_plot = fillmissing(diff_hF_plot, 'linear');  % Interpolação linear

plot(full_time_numeric, diff_hF_plot, 'b.-');
ylim([-200,200])
ax = gca;
ax.YColor = 'k';
hold on;
ylabel('\Delta h''F');
set(gca, 'XTickLabel', []);
ax.XAxis.LineWidth = 2;
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric);
grid on;

yyaxis right;
diff_hF = full_hF - mediahF;
diff_std = desviohF;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - BARRAS VERDES (ANTES DO PROCESSAMENTO)
%diff_hF = fillmissing(diff_hF, 'spline');  % Interpolação linear

for i = 1:length(diff_hF)
    if diff_hF(i,:) > diff_std(i,:)
        diff_hF(i,:) = diff_hF(i,:) - diff_std(i,:);
    elseif diff_hF(i,:) < -diff_std(i,:)
        diff_hF(i,:) = diff_hF(i,:) + diff_std(i,:);
    else
        diff_hF(i,:) = 0;    
    end
end

diff_hF = (diff_hF / MAEnoitehF) * 100;

% MANTER NaN NOS PONTOS ORIGINAIS (opcional - se quiser mostrar onde havia dados faltantes)
% diff_hF(nan_mask) = NaN;  % Descomente esta linha se quiser manter NaN

bar(full_time_numeric, diff_hF, 'FaceColor', 'g', 'FaceAlpha', 0.5);
ylabel('Index h''F');
ylim([-50,50])
grid on;

% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on';
ax.MinorGridAlpha = 0.5;
ax.YColor = 'k';
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric);
ax.XAxis.MinorTickValues = minor_ticks;




subplot(7,1,6);
% Plot differences for hmF2
yyaxis left;
diff_hmF2 = full_hmF2 - mediahmF2;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - LINHA AZUL
diff_hmF2_plot = diff_hmF2;  % Manter cópia original
nan_mask_hmF2 = isnan(diff_hmF2_plot);
%diff_hmF2_plot = fillmissing(diff_hmF2_plot, 'linear');  % Interpolação linear

plot(full_time_numeric, diff_hmF2_plot, 'b.-');
ylim([-200,200])
ax = gca;
ax.YColor = 'k';
hold on;
ylabel('\Delta hmF2');
set(gca, 'XTickLabel', []);
ax.XAxis.LineWidth = 2;
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric);
grid on;

yyaxis right;
diff_hmF2 = full_hmF2 - mediahmF2;
diff_std = desviohmF2;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - BARRAS VERDES (ANTES DO PROCESSAMENTO)
%diff_hmF2 = fillmissing(diff_hmF2, 'linear');  % Interpolação linear

for i = 1:length(diff_hmF2)
    if diff_hmF2(i,:) > diff_std(i,:)
        diff_hmF2(i,:) = diff_hmF2(i,:) - diff_std(i,:);
    elseif diff_hmF2(i,:) < -diff_std(i,:)
        diff_hmF2(i,:) = diff_hmF2(i,:) + diff_std(i,:);
    else
        diff_hmF2(i,:) = 0;    
    end
end

diff_hmF2 = (diff_hmF2 / MAEnoitehmF2) * 100;

% MANTER NaN NOS PONTOS ORIGINAIS (opcional)
% diff_hmF2(nan_mask_hmF2) = NaN;  % Descomente esta linha se quiser manter NaN

bar(full_time_numeric, diff_hmF2, 'FaceColor', 'g', 'FaceAlpha', 0.5);
ylabel('Index hmF2');
ylim([-50,50])
grid on;

% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on';
ax.MinorGridAlpha = 0.5;
ax.YColor = 'k';
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric);
ax.XAxis.MinorTickValues = minor_ticks;
ax.XAxis.LineWidth = 2;
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric);



subplot(7,1,7);
% Overlay differences for foF2 on the same subplot with another y-axis
yyaxis left;
diff_f0F2 = full_foF2 - mediaf0F2;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - LINHA AZUL
diff_f0F2_plot = diff_f0F2;  % Manter cópia original
nan_mask_f0F2 = isnan(diff_f0F2_plot);
%diff_f0F2_plot = fillmissing(diff_f0F2_plot, 'linear');  % Interpolação linear

plot(full_time_numeric, diff_f0F2_plot, 'b.-');
ax = gca;
ax.YColor = 'k';
ylim([-5,5])
ylabel('\Delta foF2');
xlabel('Time');

yyaxis right;
diff_f0F2 = full_foF2 - mediaf0F2;
diff_std = desviof0F2;

% INTERPOLAÇÃO PARA SUBSTITUIR NaN - BARRAS VERDES (ANTES DO PROCESSAMENTO)
%diff_f0F2 = fillmissing(diff_f0F2, 'linear');  % Interpolação linear

for i = 1:length(diff_f0F2)
    if diff_f0F2(i,:) > diff_std(i,:)
        diff_f0F2(i,:) = diff_f0F2(i,:) - diff_std(i,:);
    elseif diff_f0F2(i,:) < -diff_std(i,:)
        diff_f0F2(i,:) = diff_f0F2(i,:) + diff_std(i,:);
    else
        diff_f0F2(i,:) = 0;    
    end
end

diff_f0F2 = (diff_f0F2 / MAEnoitef0F2) * 100;

% MANTER NaN NOS PONTOS ORIGINAIS (opcional)
% diff_f0F2(nan_mask_f0F2) = NaN;  % Descomente esta linha se quiser manter NaN

bar(full_time_numeric, diff_f0F2, 'FaceColor', 'g', 'FaceAlpha', 0.5);
ylabel('Index foF2');
xlabel('Time');
ylim([-50,50])
grid on;

% Set minor ticks on the x-axis
ax = gca;
ax.XMinorTick = 'on'; % Enable minor ticks
ax.MinorGridAlpha = 0.5; % Make minor grid lines semi-transparent
ax.YColor = 'k';

% Correctly set minor ticks for datetime x-axis using datenum
minor_ticks = min(full_time_numeric):0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
ax.XAxis.MinorTickValues = minor_ticks; % Set minor tick values

% Set major ticks larger and custom labels with days
ax.XAxis.LineWidth = 2; % Increase major tick line width
ax.XTick = min(full_time_numeric):4*0.2498: max(full_time_numeric); % 20 minor ticks for better distribution
dates = linspace(min(full_time_numeric), max(full_time_numeric), 31);
month_day = arrayfun(@(x) datestr(x, 'mm/dd'), dates(1:end-1), 'UniformOutput', false);
month_day{end+1} = '08/31';  % Adiciona o último dia manualmente
month_day{end+2} = '09/01';  % Adiciona o último dia manualmente
ax.XTickLabel = month_day;

% Create rectangle
annotation(figure1,'rectangle',...
    [0.879645833333333 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[1 0 0],...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.680166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[1 0 0],...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.605166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[1 0 0],...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.580166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[1 0 0],...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.530166666666665 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[1 0 0],...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.330166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[0.0745098039215686 0.623529411764706 1],...
    'FaceColor',[0.0745098039215686 0.623529411764706 1],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.805166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[0.0745098039215686 0.623529411764706 1],...
    'FaceColor',[0.0745098039215686 0.623529411764706 1],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.855166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[0.0745098039215686 0.623529411764706 1],...
    'FaceColor',[0.0745098039215686 0.623529411764706 1],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.480166666666666 0.11214953271028 0.0245208333333333 0.813084112149532],...
    'Color',[0.0745098039215686 0.623529411764706 1],...
    'FaceColor',[0.0745098039215686 0.623529411764706 1],...
    'FaceAlpha',0.3);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.155898731088335 0.109077336089696 0.0245208333333333 0.813084112149532],...
    'Color',[0.0745098039215686 0.623529411764706 1],...
    'FaceColor',[0.0745098039215686 0.623529411764706 1],...
    'FaceAlpha',0.3);
