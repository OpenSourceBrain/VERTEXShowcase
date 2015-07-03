function cellconnectivity(VERTEX_connections,VERTEX_params,directory,filename)
% cellconnectivity() receives matlab structure matrix specifying VERTEX
% connecions, VERTEX parameters' structure named params, which has 5
% fields, including TissueParams; cellconnectivity() then produces a txt file 
% containing connectivity information in terms of elements' ids. Cellconnectivity() also
% receives string specifying file directory and string specifying a name of
% txt file.
Size=size(VERTEX_connections);
dim1=0;
for i=1:Size(1)
    dim1=dim1+length(VERTEX_connections{i,1});    
end
ID_Matrix=zeros(4,dim1);
group_boundaries=zeros(1,Size(1));
sum=0;
for i=1:Size(1)
    group_length=length(VERTEX_connections{i,1});
    sum=sum+group_length;
    group_boundaries(i)=sum;
end
start=0;
for i=1:Size(1)
    group_boundary=length(VERTEX_connections{i,1});
    for j=1:group_boundary
        ID_Matrix(1,start+j)=i;
        ID_Matrix(3,start+j)=VERTEX_connections{i,1}(j);
        ID_Matrix(4,start+j)=VERTEX_connections{i,2}(j);
    end
    start=group_boundaries(i);
    
end
start=1;
for i=1:VERTEX_params.TissueParams.numGroups
    Index_vector=(VERTEX_params.TissueParams.groupBoundaryIDArr(i)+1):VERTEX_params.TissueParams.groupBoundaryIDArr(i+1);
    if isempty(Index_vector)~=1
      
         ID_Matrix(2,start:group_boundaries(Index_vector(end)))=i;
         start=group_boundaries(Index_vector(end))+1;
    end
  
end
ID_Matrix=ID_Matrix-1;     %normalize ID_Matrix so that indexing is compatible with neuroml.
length1=length('Presynaptic cell ID');
length2=length('Presynaptic cell population ID');
length3=length('Postsynaptic cell ID');
length4=length('Target compartment ID');
r=length(num2str(max(max(ID_Matrix))));
if r>length1
    length1=r;
end
if r>length2
    length2=r;
end
if r>length3
    length3=r;
end
if r>length4
    length4=r;
end
t=sprintf('%s%s.txt',directory,filename);
format_of_txt_heading=sprintf('%%%ds %%%ds %%%ds %%%ds\\r\\n',length1,length2,length3,length4);
format_of_txt_content=sprintf('%%%dd %%%dd %%%dd %%%dd\\r\\n',length1,length2,length3,length4);
fileID=fopen(t,'w');
fprintf(fileID,format_of_txt_heading,'Presynaptic cell ID','Presynaptic cell population ID','Postsynaptic cell ID','Target compartment ID');
fprintf(fileID,format_of_txt_content,ID_Matrix);
a=fclose(fileID);
if a==-1
    disp('File closing is not successful');
end






