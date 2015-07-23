function VERTEX_Adex_1comp_to_LEMS(VERTEX_params,component_Type_path,Saving_directory,filename,display_save_array)

%prepare parameters for conversion to LEMS
Adex_params=VERTEX_Adex_1comp_model_export(VERTEX_params);
% each row represents a distinct cell group; 
% the columns in the Adex_params represent Adex parameters in the following order: C (pF), gL (nS), EL (mV), 
% reset (mV), VT (mV), delT (mV), tauw(ms),  a (nS),   b (nA), v_cutoff(mV)
Input_params=VERTEX_input_export(VERTEX_params);
Sim_params=VERTEX_sim_export(VERTEX_params);

if isstruct(VERTEX_params)==1
    Tissue_params=VERTEX_params.TissueParams;
    
end

if iscell(VERTEX_params)==1
    Tissue_params=VERTEX_params{1};
    
end
docNode=com.mathworks.xml.XMLUtils.createDocument('Lems');
Lems=docNode.getDocumentElement;
target=docNode.createElement('Target');
target.setAttribute('component','sim1');
Lems.appendChild(target);

Include=docNode.createElement('Include');
Include.setAttribute('file','Cells.xml');
Lems.appendChild(Include);

Include=docNode.createElement('Include');
Include.setAttribute('file','Networks.xml');
Lems.appendChild(Include);

Include=docNode.createElement('Include');
Include.setAttribute('file','Simulation.xml');
Lems.appendChild(Include);

Include=docNode.createElement('Include');
Include.setAttribute('file','Inputs.xml');
Lems.appendChild(Include);

Include=docNode.createElement('Include');
Include.setAttribute('file',component_Type_path);
Lems.appendChild(Include);

for i=1:length(Input_params)
    
        if strcmp(Input_params{1,i}{1,1},'i_step')==1
            pulseGenerator=docNode.createElement('pulseGenerator');
            pulseGenerator.setAttribute('id',sprintf('pulse%d',i-1));
            pulseGenerator.setAttribute('delay',sprintf('%fms',Input_params{1,i}{1,3}));
            pulseGenerator.setAttribute('duration',sprintf('%fms',Input_params{1,i}{1,4}-Input_params{1,i}{1,3}));
            pulseGenerator.setAttribute('amplitude',sprintf('%fnA',Input_params{1,i}{1,2}));
            Lems.appendChild(pulseGenerator);
            
        end
end
 

for i=1:length(Input_params)
        VERTEX_Adex=docNode.createElement('VERTEX_Adex');
        VERTEX_Adex.setAttribute('id',sprintf('VERTEX_Adex_1comp_group_%d',i-1));
        VERTEX_Adex.setAttribute('C',sprintf('%fpF',Adex_params{i,1}));
        VERTEX_Adex.setAttribute('gL',sprintf('%fnS',Adex_params{i,2}));
        VERTEX_Adex.setAttribute('EL',sprintf('%fmV',Adex_params{i,3}));
        VERTEX_Adex.setAttribute('reset',sprintf('%fmV',Adex_params{i,4}));
        VERTEX_Adex.setAttribute('VT',sprintf('%fmV',Adex_params{i,5}));
        VERTEX_Adex.setAttribute('delT',sprintf('%fmV',Adex_params{i,6}));
        VERTEX_Adex.setAttribute('tauw',sprintf('%fms',Adex_params{i,7}));
        VERTEX_Adex.setAttribute('a',sprintf('%fnS',Adex_params{i,8}));
        VERTEX_Adex.setAttribute('b',sprintf('%fnA',Adex_params{i,9}));
        VERTEX_Adex.setAttribute('v_cutoff',sprintf('%fmV',Adex_params{i,10}));
        Lems.appendChild(VERTEX_Adex);
    
    
end

network=docNode.createElement('network');
network.setAttribute('id','net1');
Lems.appendChild(network);
for j=1:length(Input_params)
    population=docNode.createElement('population');
    population.setAttribute('id',sprintf('pop%d',j-1));
    population.setAttribute('component',sprintf('VERTEX_Adex_1comp_group_%d',j-1));
    population.setAttribute('size',sprintf('%d',Tissue_params.groupSizeArr(j,1)));
    % later include cell positions and morphology inside population element
    network.appendChild(population);
    for i=1:Tissue_params.groupSizeArr(j,1)
        explicitInput=docNode.createElement('explicitInput');
        explicitInput.setAttribute('target',sprintf('pop%d[%d]',j-1,i-1));
        explicitInput.setAttribute('input',sprintf('pulse%d',j-1));
        explicitInput.setAttribute('destination','synapses');
        network.appendChild(explicitInput);
        
    end
    % later include synaptic connections
end

Simulation=docNode.createElement('Simulation');
Simulation.setAttribute('id','sim1');
Simulation.setAttribute('length',sprintf('%fms',Sim_params(1)));
Simulation.setAttribute('step',sprintf('%fms',Sim_params(2)));
Simulation.setAttribute('target','net1');
Lems.appendChild(Simulation);
Display=docNode.createElement('Display');

Display.setAttribute('id','d1');
Display.setAttribute('title','Voltage traces and inputs of VERTEX_Adex one comp cell(s)');
Display.setAttribute('timeScale','1ms');
Display.setAttribute('xmin','0');
Display.setAttribute('xmax',sprintf('%f',Sim_params(1)));
Display.setAttribute('ymin','-160');
Display.setAttribute('ymax','50');
Simulation.appendChild(Display);

total_no_elements=0;

for k=1:length(display_save_array)
    total_no_elements=total_no_elements+length(display_save_array{1,k});
    
end
if total_no_elements>10 %currently set to display no more than 10 cells  per one display
    errMsg = 'Cannot display more than 10 cells';
      error('VERTEXShowcase:VERTEX_Adex_1comp_to_LEMS:total_no_elements', errMsg);
    
end
Color_list={'#FF0000','#00FF00','#0000FF','#FFFF00','#CCEEFF','#CD00BF','#00CDA7','#00CD0E','#CD6D00','#333333'};
counter=1;
for k=1:length(display_save_array)
    OutputFile=docNode.createElement('OutputFile');
    OutputFile.setAttribute('id',sprintf('of%d',k-1));
    OutputFile.setAttribute('fileName',sprintf('results/%s_pop%d.dat',filename,k-1));
    Simulation.appendChild(OutputFile);
    for j=1:length(display_save_array{1,k})
        Line=docNode.createElement('Line');
        Line.setAttribute('id',sprintf('iSyn_pop%d_%d',k-1,display_save_array{1,k}(j)));
        Line.setAttribute('quantity',sprintf('pop%d[%d]/iSyn',k-1,display_save_array{1,k}(j)));
        Line.setAttribute('scale','0.005nA');
        Line.setAttribute('timeScale','1ms');
        Line.setAttribute('color',Color_list{1,counter});
        Display.appendChild(Line);
        Line=docNode.createElement('Line');
        Line.setAttribute('id',sprintf('v_pop%d_%d',k-1,display_save_array{1,k}(j)));
        Line.setAttribute('quantity',sprintf('pop%d[%d]/v',k-1,display_save_array{1,k}(j)));
        Line.setAttribute('scale','1mV');
        Line.setAttribute('timeScale','1ms');
        Line.setAttribute('color',Color_list{1,counter});
        Display.appendChild(Line);
        counter=counter+1;
        OutputColumn=docNode.createElement('OutputColumn');
        OutputColumn.setAttribute('id',sprintf('pop%d%d',k-1,display_save_array{1,k}(j)));
        OutputColumn.setAttribute('quantity',sprintf('pop%d[%d]/v',k-1,display_save_array{1,k}(j)));
        OutputFile.appendChild(OutputColumn);
       
    end
    
    
end


t=sprintf('%s%s.xml',Saving_directory,filename);
xmlwrite(t,docNode);
edit(t);

end
