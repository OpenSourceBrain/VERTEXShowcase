function varargout=cellpositions(VERTEX_params,output_type,varargin)
%  Function cellpositions extracts cell positions from VERTEX_params;
%  cellpositions() can then save cell positions into txt file, return formatted
%  soma position matrix or both. Cellpositions receives 
%  three input arguments: name of the structure or cell array of
%  VERTEX parameters, a string, output_type, specifying what is returned by the function,
%  and name of the txt file, also as a string. Output_type can be one of the following strings:
%  1) output_type='soma_matrix' - if this is specified, only soma position matrix
%  is returned by cellpositions(). 
%  2) output_type='soma_matrix+txt' - if this is specified soma position
%  matrix is returned and txt file of cell positions is generated. 
%  3) output_type='txt' - if this is specified only txt file of cell
%  positions is generated. In both cases (2 and 3), filename has to be
%  specified.
if isstruct(VERTEX_params)==1
    b=VERTEX_params.TissueParams;
end

if iscell(VERTEX_params)==1
    b=VERTEX_params{1};
end


Position_mat=b.somaPositionMat;
width=length(num2str(max(max([Position_mat(:,1) Position_mat(:,2) Position_mat(:,3)]))))+2;
dim=size(Position_mat);
r=length(num2str(dim(1)));
a=length('instance id');
if r>a
    a=r;
end
Formatted_data=[round(Position_mat(:,4)');Position_mat(:,1)';Position_mat(:,2)';Position_mat(:,3)'];
if strcmp(output_type,'soma_matrix')==1
     varargout{1}=Formatted_data;
end
if strcmp(output_type,'soma_matrix+txt')==1 || strcmp(output_type,'txt')==1
    if strcmp(output_type,'soma_matrix+txt')==1
        varargout{1}=Formatted_data;
    end
    path=fileparts(which('VERTEX_txt.txt'));
    t=sprintf('%s%s%s.txt',path,filesep,varargin{1});
    format_of_txt_heading=sprintf('%%%ds %%%ds %%%ds %%%ds\\r\\n',a,width,width,width);
    format_of_txt_content=sprintf('%%%dd %%%df %%%df %%%df\\r\\n',a,width,width,width);
    fileID=fopen(t,'w');
    for i=1:b.numGroups
        Index_vector=(b.groupBoundaryIDArr(i)+1):b.groupBoundaryIDArr(i+1);
        if isempty(Index_vector)==1
            population_heading=sprintf('population id=%d',i); % normalize population indexing
            fprintf(fileID,'%s\r\n',population_heading);
            fprintf(fileID,'%s\r\n','population is empty');
        else
            population_data=Formatted_data(:,Index_vector(1):Index_vector(end));
            dim=size(population_data);
            population_data(1,:)=0:1:dim(2)-1; %normalize the indexing so that it is compatible with neuroml
            population_heading=sprintf('population id=%d',i); % normalize population indexing
            fprintf(fileID,'%s\r\n',population_heading);
            fprintf(fileID,format_of_txt_heading,'instance id','x','y','z');
            fprintf(fileID,format_of_txt_content,population_data);
        end
        
    end
    a=fclose(fileID);
    if a==-1
        disp('File closing is not successful');
    end
    
end




            
        
        
  
        
        
        