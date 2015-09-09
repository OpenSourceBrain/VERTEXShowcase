Here you can find methods for the export of VERTEX network structure and VERTEX cell models.

[cell_morphology.m](cell_morphology.m) - exports cell morphology to neuroml [cell.nml files](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/NeuroML2)

[cellconnectivity.m](cellconnectivity.m)  and [cellconnectivity_tags.m](cellconnectivity_tags.m) - produce txt files containing information about cell connectivity; if specified,
also return arrays that are later used by other methods such as cellpositions_cellconnectivity.m which produces net.nml files.

[cellpositions.m](cellpositions.m) and [cellpositions_tags.m](cellpositions_tags.m) are methods that export cell positions of the VERTEX model to txt files.

[cellpositions_cellconnectivity.m](cellpositions_cellconnectivity.m) - export VERTEX network (containing cell positions and connectivity) to neuroml ([net.nml](https://github.com/OpenSourceBrain/VERTEXShowcase/tree/master/NeuroML2))
currently supports models containing conductance-based one exp synapses (g_exp) only.

[compartments_parameters_export.m](compartments_parameters_export.m) - a supplementary method used by cell_morphology.m 

[get_cells_to_display.m](get_cells_to_display.m) - a supplementary method that converts the VERTEX parameter vector RecordingSettings.v_m to
the vector that is compatible with LEMS. RecordingSettings.v_m specifies for which specific cells voltage potentials 
have to be recorded; thus the output of get_cells_to_display() can be used as the input which specifies which cells have
to be displayed and/or saved in LEMS

[synapse_parameters_export.m](synapse_parameters_export.m) - exports synapse parameters of the VERTEX model. Output of synapse_parameters_export()
is used by synapse_to_nml.m

[synapse_to_nml.m](synapse_to_nml.m) - creates synapse.nml files using synapse parameters. Currently supports conversion to
conductance-based, one exponential synapse only. Another synapse available on VERTEX is current-based ( not yet on neuroml/LEMS)

[VERTEX_Adex_1comp_model_export.m](VERTEX_Adex_1comp_model_export.m) - exports VERTEX model parameters of Adex cells. Output is used by 
VERTEX_Adex_1comp_to_LEMS.m

[VERTEX_Adex_1comp_to_LEMS.m](VERTEX_Adex_1comp_to_LEMS.m) -export VERTEX model containing Adex one compartment cells to LEMS by generating a xml file
containing single Adex one compartment cells or network of Adex one compartment cells.

[VERTEX_input_export.m](VERTEX_input_export.m) - a supplementary function that exports VERTEX model inputs. Currently it can only export
one type of input per cell population in the VERTEX model and only the input type, i_step. The output of VERTEX_input_export()
is used by other methods that produce LEMS and nml files.

[VERTEX_IzhikevichCell_model_export.m](VERTEX_IzhikevichCell_model_export.m) - similar to VERTEX_Adex_1comp_model_export.m, but now for the VERTEX models
containing the IzhikevichCells.

[VERTEX_IzhikevichCell_to_LEMS.m](VERTEX_IzhikevichCell_to_LEMS.m) - similar to VERTEX_Adex_1comp_to_LEMS.m, but now for the conversion of VERTEX models
containing IzhikevichCells.

[VERTEX_sim_export.m](VERTEX_sim_export.m) -supplementary method which outputs simulation parameters of a given simulation
