def checkm_filter(checkm, bins_all, bins_filt):
    """
    copy medium and high quality mags into a new folder for downstream use
    high quality - >90% completeness, <5% contamination, 23S, 16S, 5S rRNA genes, >18 tRNAs
    medium quality - >= 50% completeness, <10% contamination 

    inputs: 
        checkm - where checkm output txt file is
        bins_all - where the bins are located prior to filtering

    outputs:
        directory with medium and high quality bins copied
    """

    from shutil import copy
    import pandas as pd
    import os
    
    os.makedirs(bins_filt) # make empty directory where filtered bins will go

    bins = [] # initialize empty lists to store bins of interest
    bin_filepath = []

    df = pd.read_table(checkm, sep = "\t") # read in checkm table

    bins = df.query("Completeness >=50 & Contamination <10")["Bin Id"] # bins with quality parameters matching

    bin_filepath = [os.path.join(bins_all, x + ".fa") for x in bins] # make a proper file path to access each bin
    
    for each_bin in bin_filepath: # copying the bins to the new folder
        copy(each_bin, bins_filt)
    
checkm_filter(snakemake.input[0], snakemake.input[1], snakemake.output[0])