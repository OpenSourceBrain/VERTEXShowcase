This folder contains a number of examples and MATLAB methods that export VERTEX models to neuroML2 and LEMS.

Before running the examples above, create folders on your computer containing txt files with filenames
"VERTEX_txt" and "VERTEX_nml". These folders have to be added (be visible) to the MATLAB path. 

Matlab methods will then be able to locate the folders containing these txt files
in order to put VERTEX export files with either txt or nml extension. 

LEMS files with xml extension are exported to the "test_LEMS" folder which is created 
when you run the first model, and then is used later to place all other xml files.

Scripts in this folder are either VERTEX models or methods to export VERTEX model structure and dynamics.*

*(To see membrane potential traces look at the images subfolder of VERTEXShowcase.
 To see network and morphology export in neuroml look at the NeuroML2 subfolder of VERTEXShowcase and OSB 3D explorer.
 To see LEMS xml files look at the test_LEMS suboflder of VERTEXShowcase.)

a) simple models for testing conversion of model time dynamics to LEMS:

Adex2pop_1comp_test1.m - two cells, no synaptic connectivity, for testing whether current step inputs are successfully converted to LEMS;
delayed step current is introduced to the cell population 1 only and the amplitude is insufficient to elict action potentials (APs).

Adex2pop_1comp_test2.m - similar to ..test1.m; two cells, no synaptic connectivity, however, amplitude to the first cell is increased so to elicit a small number of APs.
Again, no input is provided to the second cell.

Adex2pop_1comp_test3.m- two cells, one synaptic connection is defined from cell 1 to cell 2, synaptic activity is observed.

Adex_point_neuron_stepI_test1.m - a simple model of one cell responding to a step current without delay ( TimeOn is 0 ms)

Adex_point_neuron_stepI_test1.m - a simple model of one cell responding to a step current introduced after 50 

Adex3pop_1comp_test1/test2/test3.m - testing conversion of time dynamics between three different Adex one compartmental
populations; test1 does not include synaptic connectivity to test conversion of cell dynamics to LEMS under specific step current inputs.
Test2 and Test3 introduce synaptic connectivity

pointIzhikevichCell_stepI_test1.m - testing time dynamics of newly defined cell class, PointNeuronModel_izhikevichcell, which is equivalent to the model in LEMS. 
To use this class with VERTEX application, the class script has to be on the MATLAB path.

pointIzhikevichCell_stepI_test2.m -testing time dynamics of newly defined cell class...

b) variable size models for testing conversion of network structure and cell morphology to neuroml:

Adex2populations_1compartment_model.m

Adex2populations_2compartment_model.m

medium_net_1000.m

medium_net_g_exp.m

c) New cell classes for VERTEX application:

PointNeuronModel_izhikevichcell.m - this is equivalent to izhikevichcell in LEMS.

d) Export methods/functions:

cell_morphology.m - exports cell morphology to neuroml (cell.nml files)

cellconnectivity.m  and cellconnectivity_tags.m - produce txt files containing information about cell connectivity; if specified,
also return arrays that are later used by other methods such as cellpositions_cellconnectivity.m which produces net.nml files.

cellpositions.m and cellpositions_tags.m are methods that export cell positions of the VERTEX model to txt files.

cellpositions_cellconnectivity.m - export VERTEX network (containing cell positions and connectivity) to neuroml
currently supports models containing conductance-based one exp synapses (g_exp) only.

compartments_parameters_export.m - a supplementary method used by cell_morphology.m 

get_cells_to_display.m - a supplementary method that converts the VERTEX parameter vector RecordingSettings.v_m to
the vector that is compatible with LEMS. RecordingSettings.v_m specifies for which specific cells voltage potentials 
have to be recorded; thus the output of get_cells_to_display() can be used as the input which specifies which cells have
to be displayed and/or saved in LEMS

synapse_parameters_export.m - exports synapse parameters of the VERTEX model. Output of synapse_parameters_export()
is used by synapse_to_nml.m

synapse_to_nml.m - creates synapse.nml files using synapse parameters. Currently supports conversion to
conductance-based, one exponential synapse only. Another synapse available on VERTEX is current-based ( not yet on neuroml/LEMS)

VERTEX_Adex_1comp_model_export.m - exports VERTEX model parameters of Adex cells. Output is used by 
VERTEX_Adex_1comp_to_LEMS.m

VERTEX_Adex_1comp_to_LEMS.m -export VERTEX model containing Adex one compartment cells to LEMS by generating a xml file
containing single Adex one compartment cells or network of Adex one compartment cells.

VERTEX_input_export.m - a supplementary function that exports VERTEX model inputs. Currently it can only export
one type of input per cell population in the VERTEX model and only the input type, i_step. The output of VERTEX_input_export()
is used by other methods that produce LEMS and nml files.

VERTEX_IzhikevichCell_model_export.m - similar to VERTEX_Adex_1comp_model_export.m, but now for the VERTEX models
containing the IzhikevichCells.

VERTEX_IzhikevichCell_to_LEMS.m - similar to VERTEX_Adex_1comp_to_LEMS.m, but now for the conversion of VERTEX models
containing IzhikevichCells.

VERTEX_sim_export.m -supplementary method which outputs simulation parameters of a given simulation

VERTEXcell_vs_LEMScell.m - allows to compare VERTEX cell with LEMS cell one by one by plotting voltage traces.
















