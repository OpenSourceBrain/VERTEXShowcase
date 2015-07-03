function cellpositions(VERTEX_params,directory,filename)
% Function cellpositions extracts cell positions form VERTEX structure
% of the model parameters (named params) and puts cell positions into txt
% file. cellpositions receives three input arguments: name of the structure of
% VERTEX parameters, name of the directory in a string, and name of the txt
% file in a string. A newly created txt file can be saved in the same
% directory as simulation results (RecordingSettings.saveDir) or
% in a different directory. To save a file as filename.txt, there has to be \  at the end
% of directory path.
if isfield(VERTEX_params,'TissueParams')~=1
    errorMessage='Parameter structure must contain the field named TissueParams';
    error('cellpositions:fieldNotFound',errorMessage);
end
if isfield(VERTEX_params.TissueParams,'somaPositionMat')~=1
    errorMessage='TissueParams must contain the field named somaPositionMat';
    error('cellpositions:fieldNotFound',errorMessage);
end
Position_mat=VERTEX_params.TissueParams.somaPositionMat;
width=length(num2str(max(max([Position_mat(:,1) Position_mat(:,2) Position_mat(:,3)]))))+2;
dim=size(Position_mat);
r=length(num2str(dim(1)));
a=length('instance id');
if r>a
    a=r;
end
Formatted_data=[round(Position_mat(:,4)');Position_mat(:,1)';Position_mat(:,2)';Position_mat(:,3)'];
t=sprintf('%s%s.txt',directory,filename);
format_of_txt_heading=sprintf('%%%ds %%%ds %%%ds %%%ds\\r\\n',a,width,width,width);
format_of_txt_content=sprintf('%%%dd %%%df %%%df %%%df\\r\\n',a,width,width,width);
fileID=fopen(t,'w');
for i=1:VERTEX_params.TissueParams.numGroups
    Index_vector=(VERTEX_params.TissueParams.groupBoundaryIDArr(i)+1):VERTEX_params.TissueParams.groupBoundaryIDArr(i+1);
    if isempty(Index_vector)==1
        population_heading=sprintf('population id=%d',i-1); % normalize population indexing
        fprintf(fileID,'%s\r\n',population_heading);
        fprintf(fileID,'%s\r\n','population is empty');
    else
        population_data=Formatted_data(:,Index_vector(1):Index_vector(end));
        dim=size(population_data);
        population_data(1,:)=0:1:dim(2)-1; %normalize the indexing so that it is compatible with neuroml
        population_heading=sprintf('population id=%d',i-1); % normalize population indexing
        fprintf(fileID,'%s\r\n',population_heading);
        fprintf(fileID,format_of_txt_heading,'instance id','x','y','z');
        fprintf(fileID,format_of_txt_content,population_data);
    end

end
a=fclose(fileID);
if a==-1
    disp('File closing is not successful');
end





            
        
        
  
        
        
        