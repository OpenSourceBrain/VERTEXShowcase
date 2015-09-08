Here you can find examples of VERTEX models that use methods found in [Utils](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/VERTEX/Utils/Export)

a) simple models for testing conversion of model time dynamics to LEMS:

[Adex2pop_1comp_test1.m](Adex2pop_1comp_test1.m) - two cells, no synaptic connectivity, for testing whether current step inputs are successfully converted to LEMS;
delayed step current is introduced to the cell population 1 only and the amplitude is insufficient to elict action potentials (APs).

[Adex2pop_1comp_test2.m](Adex2pop_1comp_test2.m) - similar to Adex2pop_1comp_test1.m; two cells, no synaptic connectivity, however, amplitude to the first cell is increased so to elicit a small number of APs.
Again, no input is provided to the second cell.

[Adex2pop_1comp_test3.m](Adex2pop_1comp_test3.m)- two cells, one synaptic connection is defined from cell 1 to cell 2, synaptic activity is observed.

[Adex_point_neuron_stepI_test1.m](Adex_point_neuron_stepI_test1.m) - a simple model of one cell responding to a step current without delay ( TimeOn is 0 ms)

[Adex_point_neuron_stepI_test1.m](Adex_point_neuron_stepI_test1.m) - a simple model of one cell responding to a step current introduced after 50 

[Adex3pop_1comp_test1.m](Adex3pop_1comp_test1.m), [Adex3pop_1comp_test2.m](Adex3pop_1comp_test2.m),[Adex3pop_1comp_test3.m](Adex3pop_1comp_test3.m) - testing conversion of time dynamics between three different Adex one compartmental
populations; test1 does not include synaptic connectivity in order to test conversion of cell dynamics to LEMS under specific step current inputs.
Test2 and Test3 introduce synaptic connectivity.

[pointIzhikevichCell_stepI_test1.m](pointIzhikevichCell_stepI_test1.m) - testing time dynamics of newly defined cell class, PointNeuronModel_izhikevichcell, which is equivalent to the model in LEMS. 
To use this class with VERTEX application, the class script has to be on the MATLAB path.

[pointIzhikevichCell_stepI_test2.m](pointIzhikevichCell_stepI_test2.m) -testing time dynamics of newly defined cell class...

b) variable size models for testing conversion of network structure and cell morphology to neuroml:

[Adex2populations_1compartment_model.m](Adex2populations_1compartment_model.m)

[Adex2populations_2compartment_model.m](Adex2populations_2compartment_model.m)

[medium_net_1000.m](medium_net_1000.m)

[medium_net_g_exp.m](medium_net_g_exp.m)
