function cells_to_display_in_LEMS=get_cells_to_display(VERTEX_params)

if isstruct(VERTEX_params)==1
    Recording_params=VERTEX_params.RecordingSettings;
    Tissue_params=VERTEX_params.TissueParams;
    
end

if iscell(VERTEX_params)==1
    Recording_params=VERTEX_params.RecordingSettings;
    Tissue_params=VERTEX_params{1};
end
num_of_Groups=Tissue_params.numGroups;
cells_to_display_in_LEMS=cell(1,num_of_Groups);
VERTEX_cell_IDs_to_record=Recording_params.v_m;
intermediate_array=cell(1,length(VERTEX_cell_IDs_to_record));
% intermediate array stores the LEMS-compatible cel indices and their
% respective population IDs. 
group_boundary_Arr=Tissue_params.groupBoundaryIDArr;
for i=1:length(VERTEX_cell_IDs_to_record)
    intermediate_array{1,i}=zeros(1,2);
    for j=1:(length(group_boundary_Arr)-1)
        if VERTEX_cell_IDs_to_record(i) >=group_boundary_Arr(j) && VERTEX_cell_IDs_to_record(i)<=group_boundary_Arr(j+1) 
           if j==1
               intermediate_array{1,i}(1)=j; % population ID
               intermediate_array{1,i}(2)=VERTEX_cell_IDs_to_record(i)-1; % cell ID inside the population ID=1
           else
           
               intermediate_array{1,i}(1)=j; % population ID
               intermediate_array{1,i}(2)=VERTEX_cell_IDs_to_record(i)-group_boundary_Arr(j)-1;
           end
           break
        end
    end
end

for j=1:num_of_Groups
        cells_to_display_in_LEMS{1,j}=[];
        counter=1;
        for i=1:length(intermediate_array)
           if intermediate_array{1,i}(1)==j
                cells_to_display_in_LEMS{1,j}(counter)=intermediate_array{1,i}(2);
       
                counter=counter+1;
           end
        
       end
    
end






