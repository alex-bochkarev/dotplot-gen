library(ggplot2)
library(reshape2)
library(gridExtra)

#################################################
## Auxiliary functions

## Allowed distortion functions
insertion <- function(sequence, where, what)
    ## sequence = vector of elements
    ## where = after which position to insert; indexing starts from ONE
    ## what = what to insert
    ## NOTE: there is no control for negative =where='s
{
    if(where!=0){
        insertion <- c(sequence[1:where],what,sequence[where:length(sequence)]);        
    }else{
        insertion <- c(what,sequence);        
        
    }
}

inversion <- function(sequence, where, howLong)
    ## sequence = vector of elements
    ## where = invert starting from which position; indexing starts from ONE
    ## howLogn = inversion length
{

    ## ensure we won't go further than the right side
    where = min(where,length(sequence)); 
    howLong = min(howLong, length(sequence) - where+1);
    
    sequence[where:(where+howLong-1)] <- rev(sequence[where:(where+howLong-1)]);
    return(list(paste("Inversion of", howLong,"pos, starting from",where),sequence));
}

## Plotting function
drawDotplot <- function(s1,s2)
{
    df = data.frame(seq1=s1,seq2=s2);
    ggplot(df,aes(x=seq1,y=seq2))+
        geom_point(color="blue")+
        xlab("Sequence 1")+
        ylab("Sequence 2")
}

################################################# 
## Client block

## basic constants
    
seqLength <- 100; # length of the sequences to be compared
maxDepth <- 5; # maximum number of the events to be applied to the sequence
numExamples <- 2; # number of files to generate
numEvents <- 5;

## distortion probabilities (conditional on that some event occurs)
insertionProb = 0.5;
inverstionProb = 0.5;


seq1 = 1:seqLength;

for (ex in 1:numExamples)
{
    s = list();
    plots = list();
    seq = seq1;
    s[[1]] = list("Initial sequence",seq);

    plots[1] = drawDotplot(seq1,seq);
    
    for (event in 1:numEvents)
    {
        ## generate where and howLong
        where=2;
        howLong = 10;
        s[[event+1]] = inversion(seq,where,howLong);
        seq = s[[event+1]][[2]];
        plots[[event+1]] = drawDotplot(seq1,seq)+
            ggtitle(s[[event+1]][[2]]);
    }

    ## save sample (final) dotplot
    drawDotplot(seq1,seq)+
        ggtitle(paste("Sample dotplot, variant ",ex));

    ## save solution
    png(paste("./Sample",ex,sep="_"),width=19.3,height=10.9,units="in",res=300);
    do.call("grid.arrange", plots,ncol=3);
    dev.off();
    
}

## generate events

## make answers

### add step-wise-answers

