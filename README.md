## A dotplot-sample generation utilities

This is a small script to generate:
- sample (randomly generated) [dot-plot](https://en.wikipedia.org/wiki/Dot_plot_(bioinformatics)) graphs in `png` format;
- corresponding history of events (inversions, insertions and deletions) -- also as a `png`-picture.
 
As a by-product the script offers several [functions](#useful-functions) that might be useful in teaching process;

The script relies on `ggplot2`, `grid` and `gridExtra` packages for visualization.

## Usage for dotplots generation
- review and refine generation [parameters](#key-tuning-parameters) if necessary;
- run the `dotplot-gen.R` script (it will load `dotplot-aux.R` with function definitions automatically), e.g.
  ```R
  source("./dotplot-gen.R")
  ```
  (when in the directory with two R-scripts)
- sample dotplots will appear in `samples` directory
- stepwise events are shown in combined plots with corresponding numbers in `stepwise` directory.

## Key tuning parameters
The key parameters to be tuned are set in one place in `dotplot-gen.R`:
| Parameter     | Default value| Description                                                 |
|:--------------|---------|:------------------------------------------------------------|
| seqLength     | 100     | length of the sequences to be generated                     |
| maxDepth      | 5       | maximum number of the events to be applied to the sequence  |
| numExamples   | 5       | number of samples (files) to generate                       |
| numEvents     | 5       | number of events (ins, del or inv) to occur in each example |


Probabilistic properties are defined as follows:

| Parameter     | Default value | Description                     |
|:--------------|---------------|:--------------------------------|
| insertionProb | 30%           | probability to get an insertion |
| inversionProb | 40%           | -//--//- an inversion           |
| deletionProb  | 30%           | -//--//- a deletion             |


- **Position** where ins, inv or del occurs, is drawn randomly, from uniform distribution over the current length of the sequnece.
- **Length** of the distortion (ins, del or inv) is calculated randomly, from uniform distribution over **half** of the current sequence length (see the `rndDistLength` parameter in the inner loop).

## Useful functions
Notice that also it might be interesting to use functions from `dotplot-aux.R` separately, e.g. in the R console:

```R
seq1 = paste("block",as.character(1:100),sep="_"); ## initialize the ``sequence''
seq1 # show the sequence as text
drawDotplot(seq1,seq1) ## obtain a standard ``y=x''-type graph

seqD = inversion(seq1, 20,20)[[2]] ## add an inversion
seqD # show what's happened
drawDotplot(seqD,seq1) ## draw a corresponding dotplot
```

Notice the use of `[[2]]` for `inversion` function (as it returns textual description as well, but here we need only the new sequence);

Available functions are:
 - `inversion(sequence, where, howLong)` -- inverts `howLong` blocks of `sequence` starting from `where`;
 - `deletion(sequence, where, howLong)` -- deletes `howLong` blocks of `sequence` starting from `where`;
 - `insertion(sequence, where, what)`-- inserts `what` (atomic) vector into `sequence` after `where` position;

All the three functions return a list of two elements:
 - text description of the corresponding event (e.g. to be used in the title) -- can be accessed via `[[1]]`;
 - the new sequence -- can be accessed via `[[2]]`;

The function `drawDotplot(s_reference, s_query)` takes two atomic vectors ("sequences") as input and return a `ggplot`-object (corresponding graph);

Please refer to the commens in the code for further details.
