# A dotplot-sample generation utilities

This is a small script to generate:
- sample (randomly generated) [dot-plot](https://en.wikipedia.org/wiki/Dot_plot_(bioinformatics)) graphs in `png` format;
- corresponding history of events (inversions, insertions and deletions) -- also as a `png`-picture.
 
As a by-product the script offers several [functions](#useful-functions) that might be useful in the teaching process;

The script relies on `ggplot2`, `grid` and `gridExtra` packages for visualization.

# Getting started
No specific installation required:
- download two `.R`-files
- create `samples` and `stepwise` folders in the same directory

or just [clone this repo](https://help.github.com/articles/cloning-a-repository/).

## Prerequesites

These are [R](https://www.r-project.org/) scripts. If necessary packages are not installed, you might need to do that (from within `R` console):
```R
install.packages(c("ggplot2","grid","gridExtra"));
```

# Usage and fine-tuning
## Main purpose -- dotplots generation
- review and refine samples generation [parameters](#key-tuning-parameters) if necessary;
- run the `dotplot-gen.R` script (it will load `dotplot-aux.R` with function definitions automatically), e.g.
  ```R
  source("./dotplot-gen.R")
  ```
  when in the directory with two R-scripts. (go to the corresponding directory if necessary e.g. with `setwd("<directory>")` from the `R` console).
  
- sample dotplots will appear in `samples` directory
- stepwise events are shown in combined plots with corresponding numbers in `stepwise` directory.

## Key tuning parameters
The key parameters to be tuned are set in one place in `dotplot-gen.R`:

| Parameter   | Default value | Description                                                       |
|:------------|---------------|:------------------------------------------------------------------|
| seqLength   | 100           | length of the sequences to be generated                           |
| numExamples | 10            | number of samples (files) to generate                             |
| numEvents   | 5             | number of events (ins, del or inv) to occur in each example       |
| maxIns      | 0.5           | maximum length of insertions (relative to the current seq length) |
| maxInv      | 0.5           | --//--//-- inversion --//--//--                                   |
| maxDel      | 0.5           | --//--//-- deletion --//--//--                                    |


Event frequencies are defined as follows:

| Parameter     | Default value | Description                     |
|:--------------|---------------|:--------------------------------|
| insertionProb | 15%           | probability to get an insertion |
| inversionProb | 70%           | -//--//- an inversion           |
| deletionProb  | 15%           | -//--//- a deletion             |


> **Note.** Two technical parameters are also set up in `dotplot-aux.R` -- these are graphical parameters no\_of\_Xticks and no\_of\_Yticks corresponding to the number of ticks along the axes

- **Position** where ins, inv or del occurs, is drawn randomly, from the uniform distribution over the (current) length of the sequnece.
- **Length** of the distortion (ins, del or inv) is calculated randomly, from uniform distribution over a share of the current sequence length (see the `rndDistLength` variable in the inner loop, calculated using corresponding parameters above).

## Useful functions
Notice that also it might be interesting to use functions from `dotplot-aux.R` separately, e.g. in the R console:

```R
seq1 = paste("block",as.character(1:100),sep="_"); ## initialize the ``sequence''
seq1 # show the sequence as text
drawDotplot(seq1,seq1) ## obtain a standard ``y=x''-type graph

seqD = inversion(seq1, 20,20) ## add an inversion
seqD # show what's happened
drawDotplot(seqD,seq1) ## draw a corresponding dotplot
```

Available functions are (optional parameters are omitted -- see the source for comments):
 - `inversion(sequence, where, howLong)` -- inverts `howLong` blocks of `sequence` starting from `where`;
 - `deletion(sequence, where, howLong)` -- deletes `howLong` blocks of `sequence` starting from `where`;
 - `insertion(sequence, where, what)`-- inserts `what` (atomic) vector into `sequence` after `where` position;

All the three functions return either a new sequence, or a list of two elements (depending on the optional argument; new-sequence only being the default):
 - text description of the corresponding event (e.g. to be used in the plot title) -- can be accessed via `[[1]]`;
 - the new sequence -- can be accessed via `[[2]]`;

The function `drawDotplot(s_reference, s_query)` takes two atomic vectors ("sequences") as input and return a `ggplot`-object (corresponding graph);

In order to visually track inversions with another color a separate logical vector `color_change` is used (see `dotplot-gen.R`). 

Please refer to comments in the code for further details.
