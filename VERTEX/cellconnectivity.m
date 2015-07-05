function varargout=cellconnectivity(VERTEX_connections,VERTEX_params,output_type,varargin)
% cellconnectivity() receives matlab structure matrix specifying VERTEX
% connecions, VERTEX parameters' structure named params, which has 5
% fields, including TissueParams; cellconnectivity() then produces a connectivity
% matrix. cellconnectivity() receives a string named output_type which
% specifies the output:
% 1) if output_type=='all', cellconnectivity() returns connection ID_Matrix,
%    group_boundaries vector and
%    produces a txt file. In this case directory and filename have to be
%    specified. Cellconnectivity() thus  receives string specifying file directory 
%    and string specifying a name of txt file.
% 2) if output_type=='ID_Matrix' cellconnectivity() returns the
%    ID_Matrix only.
% 3) if output_type=='txt' cellconnectivity() returns the txt file only.
%    Again, directory and filename have to be specified. 
% 4) if output_type=='group_boundaries' cellconnectivity() returns group_boundaries vector
%    only.
% 5) if output_type=='ID_Matrix+group_boundaries' cellconnectivity returns
%    both ID_Matrix and group_boundaries vector, but does not produce txt
%    file.
Size=size(VERTEX_connections);
dim1=0;
for i=1:Size(1)
    dim1=dim1+length(VERTEX_connections{i,1});    
end
ID_Matrix=zeros(5,dim1);
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
        ID_Matrix(5,start+j)=VERTEX_connections{i,2}(j);
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
start=1;
for i=1:VERTEX_params.TissueParams.numGroups
    Index_vector=(VERTEX_params.TissueParams.groupBoundaryIDArr(i)+1):VERTEX_params.TissueParams.groupBoundaryIDArr(i+1);
    if isempty(Index_vector)~=1
      
         for j=start:group_boundaries(Index_vector(end))
             k=find(ID_Matrix(1,:)==ID_Matrix(3,j),1);
             target_population_ID=ID_Matrix(2,k);
             ID_Matrix(4,j)=target_population_ID;
         end
         start=group_boundaries(Index_vector(end))+1;
    end
  
end
        
ID_Matrix=ID_Matrix-1;     %normalize ID_Matrix so that indexing is compatible with neuroml.
if strcmp(output_type,'ID_Matrix')==1
    varargout{1}=ID_Matrix;
elseif strcmp(output_type,'group_boundaries')==1
    varargout{1}=group_boundaries;
elseif strcmp(output_type,'ID_Matrix+group_boundaries')==1
    varargout{1}=ID_Matrix;
    varargout{2}=group_boundaries;
elseif strcmp(output_type,'all')==1 || strcmp(output_type,'txt')==1
    
       length1=length('Presynaptic cell ID');
       length2=length('Presynaptic cell pop ID');
       length3=length('Postsynaptic cell ID');
       length4=length('Postsynaptic cell pop ID');
       length5=length('Target compartment ID');
       
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
       if r>length5
            length5=r;
       end
       t=sprintf('%s%s.txt',varargin{1},varargin{2});
       format_of_txt_heading=sprintf('%%%ds %%%ds %%%ds %%%ds %%%ds\\r\\n',length1,length2,length3,length4,length5);
       format_of_txt_content=sprintf('%%%dd %%%dd %%%dd %%%dd %%%dd\\r\\n',length1,length2,length3,length4,length5);
       fileID=fopen(t,'w');
       fprintf(fileID,format_of_txt_heading,'Presynaptic cell ID','Presynaptic cell pop ID','Postsynaptic cell ID','Postsynaptic cell pop ID','Target compartment ID');
       fprintf(fileID,format_of_txt_content,ID_Matrix);
       a=fclose(fileID);
       if a==-1
           disp('File closing is not successful');
       end
       if strcmp(output_type,'all')==1 
           varargout{1}=ID_Matrix;
           varargout{2}=group_boundaries;
       
       end
       
       
end





