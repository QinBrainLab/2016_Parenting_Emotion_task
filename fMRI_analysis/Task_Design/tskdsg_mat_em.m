% written by xu, modified by hao (ver_19.09.11)
% 18009445566@163.com, rock3.hao@gmail.com
% qinlab.BNU
clear; clc

%% Set up
datasets  = 'CBDPC';
test_time = 'A';
sessions  = 's02';

emerge_dir = 'C:\Users\hao1ei\OneDrive\Projects\2019_haol_functional-atlas\behavior\emerge';
output_dir = 'C:\Users\hao1ei\Desktop\taskdesign\spm';

%% Generate experimental design
emrgdata = fullfile(emerge_dir, ['emrg_t', test_time, '_em_', datasets, '.txt']);
formatSpec = ['%*s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s', ...
    '%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]'];
edata_all = fopen(emrgdata, 'r');
dataArray = textscan(edata_all, formatSpec, 'Delimiter', '\t', 'ReturnOnError', false);
fclose(edata_all);
raw = repmat({''}, length(dataArray{1}), length(dataArray) - 1);
for col = 1:length(dataArray)-1
    raw(1:length(dataArray{col}), col) = dataArray{col};
end
numericData = NaN(size(dataArray{1}, 1), size(dataArray, 2));
for col = [1, 2, 3]
    rawData = dataArray{col};
    for row = 1:size(rawData, 1)
        regexstr = ['(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]', ...
            '{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)'];
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if any(numbers == ',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw);
raw(R) = {NaN}; raw_em = raw;
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData ...
    rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

sublist = csvread(fullfile(emerge_dir, ['list_t', test_time, '_em_', datasets, '.csv']));
em = cell2mat(raw_em(2:length(raw_em), :));
for isub = 1:size(sublist, 1)
    em_temp = em(em(:, 1) == sublist(isub,1), :);
    type = em_temp(:, 3);
    onset_raw = em_temp(:, 2);
    onset_new = (onset_raw - onset_raw(1, 1)) / 1000;
    emo = onset_new(type == 11)';
    con = onset_new(type == 22)';
    dura = [30, 30, 30, 30, 30];
    
    % Save experimental design
    if sublist(isub,1) < 10
        subid = ['000', num2str(sublist(isub,1))];
    elseif sublist(isub,1) > 9 && sublist(isub,1) < 100
        subid = ['00', num2str(sublist(isub,1))];
    elseif sublist(isub,1) > 99
        subid = ['0', num2str(sublist(isub,1))];
    end
    save_dir = fullfile(output_dir, ['sub-', datasets, subid, test_time], ...
        ['ses-', sessions], 'func');
    if ~exist(save_dir, 'dir'); mkdir(save_dir); end
    
    taskfile = fullfile(save_dir, ['sub_', datasets, subid, test_time, ...
        '_ses_', sessions, '_task_em_events.m']);
    if exist(taskfile, 'file'); delete(taskfile); end
    
    tskdsg = fopen(taskfile, 'a');
    % fprintf(tskdsg, '%s\n', 'sess_name =''em'';');
    
    fprintf(tskdsg, '%s\n','names{1} = [''emotion''];');
    con_emo = num2cell(emo(1, 1:6:30));
    fprintf(tskdsg, ['onsets{1} = [', repmat('%f ', 1, length(con_emo)), '];\n'], con_emo{:});
    dura_temp = num2cell(dura);
    fprintf(tskdsg, ['durations{1} = [', repmat('%f ', 1, length(dura_temp)), '];\n'], dura_temp{:});
    
    fprintf(tskdsg, '%s\n','names{2} = [''control''];');
    con_con = num2cell(con(1, 1:6:30));
    fprintf(tskdsg, ['onsets{2} = [', repmat('%f ', 1, length(con_con)), '];\n'], con_con{:});
    dura_temp = num2cell(dura);
    fprintf(tskdsg, ['durations{2} = [', repmat('%f ', 1, length(dura_temp)), '];\n'], dura_temp{:});
    
    % fprintf(tskdsg, '%s\n', 'rest_exists  = 1;');
    % fprintf(tskdsg, '%s\n', 'save task_design.mat sess_name names onsets durations rest_exists');
    fprintf(tskdsg, '%s\n', 'save task_design.mat names onsets durations');
    
    fclose(tskdsg);
end

%% Completed
disp(['Completed at: ', datestr(now)]);
