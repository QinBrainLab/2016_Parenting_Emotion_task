clc;clear;
workdir='C:\Users\xujiahua\Desktop\Rachel_EM'
[ ~,~,database]=xlsread([workdir filesep 'database.xlsx'])
filename = [workdir filesep 'cp_behavior_em_merged2.csv']
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
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
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
id=cell2mat(database(:,1))
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData ...
    rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
for i=1:max(id)
    temp=EMdata(EMdata(:,1)==i,:)
      if isempty(temp),
        continue;
     end
   fp=fopen('check2.txt','a');
 Num= length(temp(:,1))
   fprintf(fp,'%f,%f,\n',unique(temp(:,1)),Num);
     
end
fclose(fp)
