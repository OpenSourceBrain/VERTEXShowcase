function synapse_to_nml(VERTEX_params,network_ID)
% nework ID has to be the same string input provided to
% cellpositions_cellconnectivity() method
[synapse_types,weights,tau,E_reversal]=synapse_parameters_export(VERTEX_params);

docNode=com.mathworks.xml.XMLUtils.createDocument('neuroml');
neuroml=docNode.getDocumentElement;
neuroml.setAttribute('xmlns','http://www.neuroml.org/schema/neuroml2');
neuroml.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
neuroml.setAttribute('xsi:schemaLocation','http://www.neuroml.org/schema/neuroml2  https://raw.githubusercontent.com/NeuroML/NeuroML2/development/Schemas/NeuroML2/NeuroML_v2beta4.xsd');
neuroml.setAttribute('id',sprintf('%s_g_exp',network_ID));

%currently supports export to g_exp only
dim=size(synapse_types);
for i=1:dim(1)
    for j=1:dim(2)
        expOneSynapse=docNode.createElement('expOneSynapse');
        expOneSynapse.setAttribute('id',sprintf('g_exp_%d%d',i-1,j-1));
        expOneSynapse.setAttribute('gbase',sprintf('%fnS',weights{i,j}));
        expOneSynapse.setAttribute('erev',sprintf('%fmV',E_reversal{i,j}));
        expOneSynapse.setAttribute('tauDecay',sprintf('%fms',tau{i,j}));
        neuroml.appendChild(expOneSynapse);
    end
    
end
path=fileparts(which('VERTEX_nml.txt'));
t=sprintf('%s%s%s.synapse.nml',path,filesep,network_ID);
xmlwrite(t,docNode);
    

