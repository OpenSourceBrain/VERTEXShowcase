function cellpositions(VERTEX_params,directory,filename)
% Function cellpositions extracts cell positions form VERTEX structure
% of the model parameters (named params) and puts cell positions into txt
% file. Cellpositions receives three input arguments: name of the structure of
% VERTEX parameters, name of the directory in a string, and name of the txt
% file in a string. A newly created txt file can be saved in the same
% directory as simulation results (RecordingSettings.saveDir='results') or
% in a different directory. String, which specifies a directory, has to end with \.
if isfield(VERTEX_params,'TissueParams')~=1
    errorMessage='Parameter structure must contain the field named TissueParams';
    error('cellpositions:fieldNotFound',errorMessage);
end
if isfield(VERTEX_params.TissueParams,'somaPositionMat')~=1
    errorMessage='TissueParams must contain the field named somaPositionMat';
    error('cellpositions:fieldNotFound',errorMessage);
end
VERTEX_params=VERTEX_params.TissueParams.somaPositionMat;
width=length(num2str(max(max([VERTEX_params(:,1) VERTEX_params(:,2) VERTEX_params(:,3)]))))+2;
[r, c]=size(VERTEX_params);
r=length(num2str(r));
Formatted_data=[round(VERTEX_params(:,4)');VERTEX_params(:,1)';VERTEX_params(:,2)';VERTEX_params(:,3)'];
t=sprintf('%s%s.txt',directory,filename);
format_of_txt_heading=sprintf('%%%ds %%%ds %%%ds %%%ds\\r\\n',r,width,width,width);
format_of_txt_content=sprintf('%%%dd %%%df %%%df %%%df\\r\\n',r,width,width,width);
fileID=fopen(t,'w');
fprintf(fileID,format_of_txt_heading,'id','x','y','z');
fprintf(fileID,format_of_txt_content,Formatted_data);
fclose(fileID);





            
        
        
  
        
        
        