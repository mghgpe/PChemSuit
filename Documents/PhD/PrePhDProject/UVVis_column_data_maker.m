%%
clear
% get data from .DX file

dataOnDir = dir('*.DX');

noHeaderLines = 21;

for i = 1:length(dataOnDir)
    fileName = dataOnDir(i).name;
    fieldNames = fileName(1:(end-3));
    A.(genvarname(fieldNames)) = importdata(fileName,' ',noHeaderLines);
end;



%%

%Enter Data Interval Dialog
prompt = {'Enter Data Interval (nm):'};
dlg_title = 'Data Interval Input';
num_lines = 1;
dataInterval = inputdlg(prompt,dlg_title, num_lines);


%%

fieldNames = fieldnames(A);
for i = 1:length(fieldNames)
%initialise
numRow = 1;
dimsMat = size(A.(fieldNames{i}).data);
%Check first column for NaNs
nanCheck = (A.(fieldNames{i}).data(1,1));
if isnan(nanCheck) == 1
    A.(fieldNames{i}).data = A.(fieldNames{i}).data(:,2:dimsMat(2));
end;
dimsMat = size(A.(fieldNames{i}).data);
totalNumRows = dimsMat(1);
% colTwo = absortion vector
colTwo = A.(fieldNames{i}).data(numRow,2:dimsMat(2));
waveLengthRange = A.(fieldNames{i}).data(1,1)-A.(fieldNames{i}).data(totalNumRows,1);
lastWLPoint = A.(fieldNames{i}).data(1,1)-waveLengthRange;
firstWLPoint = A.(fieldNames{i}).data(1,1);
dataIntervalNum = str2double(dataInterval{1,1});
%colOne = wavelength vector
colOne = firstWLPoint:-dataIntervalNum:lastWLPoint;
numRow = 2;
%%

%put absorbance data columns into one column
for n = numRow:(totalNumRows-1)
    
    colTwoLower = A.(fieldNames{i}).data(n,2:6);
    colTwo = [colTwo colTwoLower];
    
end;

%deal with last line
n = n+1;

getLastLineDataColumns = isfinite(A.(fieldNames{i}).data(n, 2:dimsMat(2)));
j = sum(getLastLineDataColumns);
colTwo = [colTwo A.(fieldNames{i}).data(n, 2:(j+1))];
%%
%coalation process
colOne = colOne';
colTwo = colTwo.*0.0000001192;
colTwo = colTwo';
outPutMatrix = [colOne colTwo];


%Output check
%plot(colOne, colTwo)

%%
%save data to excel and .txt formats
%prompt = {'Enter Filename'};
%dlg_title = 'Get Output Filename';
%num_lines = 1;
%fn = inputdlg(prompt,dlg_title,num_lines);
nameTxtStr = strcat((fieldNames{i}),'.txt');
xlswrite((fieldNames{i}), outPutMatrix);

fileID = fopen(nameTxtStr, 'wt');

for ii = 1:size(outPutMatrix,1)
    fprintf(fileID,'%f\t',outPutMatrix(ii,:));
    fprintf(fileID,'\n');
end
fclose(fileID);
end
%END