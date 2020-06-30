clc;clear;close all;
workdir='C:\Users\xujiahua\Desktop\Rachel_EM'
[ ~,~,database]=xlsread([workdir filesep 'database' filesep 'database.xlsx'])
filename = [workdir filesep 'EM_Raw' filesep 'EM72.csv']
delimiter = ',';
formatSpec = '%*s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%*s%*s%s%*s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4]
    % 将输入元胞数组中的文本转换为数值。已将非数值文本替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 将数值文本转换为数值。
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
raw(R) = {NaN}; 
EMdata = cell2mat(raw([2:length(raw)],[1:4]));
id=cell2mat(database(:,1))'
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData ...
    rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
for i=id(1,[1:length(id)])
    temp=EMdata(EMdata(:,1)==i,:)
      if isempty(temp),
        continue;
     end
    fp=fopen('SWUEM72.txt','a');
    for kk=1:length(temp)
      fprintf(fp,'%f\t%f\t%f\t%f\t\n',temp(kk,:));
    end
     
end
fclose(fp)
    
