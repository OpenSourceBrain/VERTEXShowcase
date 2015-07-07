function cellpositions_tags(VERTEX_params,directory,filename)
% Function cellpositions_tags extracts cell positions form VERTEX structure
% of the model parameters (named params) and puts cell positions into txt
% file with neuroml-like tags. cellpositions receives three input arguments:
% VERTEX parameters' structure (params), name of the directory in a string, and name of the txt
% file in a string. A newly created txt file can be saved in the same
% directory as simulation results (RecordingSettings.saveDir) or
% in a different directory. To save a file as filename.txt, there has to be \  at the end
% of directory path.
if isstruct(VERTEX_params)==1
    b=VERTEX_params.TissueParams;
end

if iscell(VERTEX_params)==1
    b=VERTEX_params{1};
end

Position_mat=b.somaPositionMat;
Formatted_data=[round(Position_mat(:,4)');Position_mat(:,1)';Position_mat(:,2)';Position_mat(:,3)'];
t=sprintf('%s%s.txt',directory,filename);
fileID=fopen(t,'w');
for i=1:b.numGroups
    Index_vector=(b.groupBoundaryIDArr(i)+1):b.groupBoundaryIDArr(i+1);
    if isempty(Index_vector)==1
        population_heading=sprintf('<population id="%d">',i);
        fprintf(fileID,'%s\r\n',population_heading);
        fprintf(fileID,'%s\r\n','population is empty');
        fprintf(fileID,'%s\r\n\r\n','</population>');
    else
        population_data=Formatted_data(:,Index_vector(1):Index_vector(end));
        dim=size(population_data);
        population_data(1,:)=0:1:dim(2)-1; %normalize the indexing so that it is compatible with neuroml
        population_heading=sprintf('<population id="%d">',i);
        fprintf(fileID,'%s\r\n',population_heading);
        for j=1:dim(2)
            instance_tag=sprintf('  <instance id="%d">',population_data(1,j));
            fprintf(fileID,'%s\r\n',instance_tag);
            location_tag=sprintf('    <location x="%f" y="%f" z="%f"/>',population_data(2,j),population_data(3,j),population_data(4,j));
            fprintf(fileID,'%s\r\n',location_tag);
            fprintf(fileID,'%s\r\n','  </instance>');
        end
        fprintf(fileID,'%s\r\n\r\n','</population>');
    end

end
a=fclose(fileID);
if a==-1
    disp('File closing is not successful');
end





            
        

