Here you can find examples of VERTEX models that use export methods found in [Utils](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/VERTEX/Utils/Export)

To see the overlap between representative results in LEMS and VERTEX simulators click [Image](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/images) after description of each script.

a) simple models for testing conversion of model time dynamics to LEMS:

[Adex2pop_1comp_test1.m](Adex2pop_1comp_test1.m) - two cells, no synaptic connectivity, for testing whether current step inputs are successfully converted to LEMS;
delayed step current is introduced to the cell population 1 only and the amplitude is insufficient to elict action potentials (APs).
[Image](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex2pop_1comp_test1_pop0.jpg)

[Adex2pop_1comp_test2.m](Adex2pop_1comp_test2.m) - similar to Adex2pop_1comp_test1.m; two cells, no synaptic connectivity, however, amplitude to the first cell is increased so to elicit a small number of APs.
Again, no input is provided to the second cell. [Image](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex2pop_1comp_test2_pop0.jpg)

[Adex2pop_1comp_test3.m](Adex2pop_1comp_test3.m)- two cells, one synaptic connection is defined from cell 1 to cell 2, synaptic activity is observed.
[Image1](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex2pop_1comp_test3_pop0.jpg) [Image2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex2pop_1comp_test3_pop1.jpg)

[Adex_point_neuron_stepI_test1.m](Adex_point_neuron_stepI_test1.m) - a simple model of one cell responding to a step current without delay ( TimeOn is 0 ms).
[Image](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex_point_neuron_stepI_test1_pop0.jpg)

[Adex_point_neuron_stepI_test2.m](Adex_point_neuron_stepI_test2.m) - a simple model of one cell responding to a step current introduced after 50
[Image](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex_point_neuron_stepI_test2_pop0.jpg)

[Adex3pop_1comp_test1.m](Adex3pop_1comp_test1.m), [Adex3pop_1comp_test2.m](Adex3pop_1comp_test2.m),[Adex3pop_1comp_test3.m](Adex3pop_1comp_test3.m) - testing conversion of time dynamics between three different Adex one compartmental
populations.
[Image1](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test1_pop0.jpg) ,[Image2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test1_pop1.jpg), [Image3](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test1_pop2.jpg) for test1
[To see change in cell responses of the population 2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test2_pop2.jpg) for test2
[Image1](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test3_pop0_5.jpg), [Image2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test3_pop1_4.jpg), [Image3](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/Adex3pop_1comp_test3_pop2_3.jpg) for test3

[pointIzhikevichCell_stepI_test1.m](pointIzhikevichCell_stepI_test1.m) - testing time dynamics of newly defined cell class, PointNeuronModel_izhikevichcell, which is equivalent to the model in LEMS. 
To use this class with VERTEX application, [the class script](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/VERTEX/New_VERTEX_cell_classes) has to be on the MATLAB path.
[Image](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/images/pointIzhikevichCell_stepI_test1_pop0.jpg)

[pointIzhikevichCell_stepI_test2.m](pointIzhikevichCell_stepI_test2.m) -testing time dynamics of newly defined cell class...

b) variable size models for testing conversion of network structure and cell morphology to neuroml:

[Adex2populations_1compartment_model.m](Adex2populations_1compartment_model.m). View export in  [NeuroML2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/NeuroML2/Adex2pop_1comp_10cells.net.nml)

[Adex2populations_2compartment_model.m](Adex2populations_2compartment_model.m). View export in [NeuroML2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/NeuroML2/Adex2pop_2comp_10cells.net.nml)

[medium_net_1000.m](medium_net_1000.m). View export in [NeuroML2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/NeuroML2/medium_net_1000.net.nml)

[medium_net_g_exp.m](medium_net_g_exp.m). View export in [NeuroML2](https://github.com/OpenSourceBrain/VERTEXShowcase/blob/master/NeuroML2/medium_net_g_exp.net.nml)
