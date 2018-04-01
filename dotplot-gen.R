library(ggplot2)
library(gridExtra)
library(grid)

#################################################
## Auxiliary functions
################################################# 

## Allowed distortion functions
insertion <- function(sequence, where, what)
    ## INPUT:
    ## sequence = vector of elements
    ## where = after which position to insert; indexing starts from ONE
    ## what = what to insert
    ## OUTPUT:
    ## a list of 2 elements: {text-description(character), new-sequence}
    ## NOTES:
    ## if =where= <= 0 then the inversion is assumed to start from the first block
{
    if(where>0){
        sequence <- c(sequence[1:where],what,sequence[where:length(sequence)]);
    }else{
        sequence <- c(what,sequence);        
    }

    return(list(paste("Insertion of",length(what),"symbols at",where),sequence));

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
drawDotplot <- function(s_reference,s_query)
{

    points_to_draw = lapply(1:length(s_reference),function(s){
        Ys = which(s_reference[s]==s_query)
        Xs = rep(s,times=length(Ys))
        cbind(Xs,Ys)
    });

    ggplot(do.call(rbind.data.frame, points_to_draw),
           aes(x=Xs,y=Ys)) +
        geom_point(color="blue")+
        xlab("Sequence 1 -- reference")+
        ylab("Sequence 2 -- query")
}

################################################# 
## Client block
################################################# 

################################################# 
## basic constants
    
seqLength <- 100; # length of the sequences to be compared
maxDepth <- 5; # maximum number of the events to be applied to the sequence
numExamples <- 2; # number of files to generate
numEvents <- 5;

distLength <- round(seqLength/2);
## distortion probabilities (conditional on that some event occurs)
insertionProb = 0.5;
inverstionProb = 1-insertionProb;


seq1 = paste("block",as.character(1:seqLength),sep="_"); ## initialize the ``sequence''


for (ex in 1:numExamples)
{
    s = list();
    plots = list();
    seq = seq1;

    s[[1]] = list("Initial sequence",seq);
    plots[[1]] = drawDotplot(seq1,seq)+ggtitle(s[[1]][[1]]);
    
    for (event in 1:numEvents)
    {
        ## generate where and howLong
        rndPosition = round(runif(1,1,seqLength)); # random distortion position (uniformely distributed)
        rndDistLength = round(runif(1,1,distLength)); # random distortion length (also uniform)
        
        if(runif(1,0,1)<=insertionProb){
            s[[event+1]] = insertion(seq,rndPosition,rep(seqLength*1.1,times=rndDistLength));
        }else{
            s[[event+1]] = inversion(seq,rndPosition,rndDistLength);

        }
       
        seq = s[[event+1]][[2]];
        plots[[event+1]] = drawDotplot(seq1,seq)+
            ggtitle(s[[event+1]][[1]]);
    }

    ## save sample (final) dotplot
    drawDotplot(seq1,seq)+
        ggtitle(paste("Sample (final) dotplot No.",ex));

    ## save solution
    png(paste("./Sample",ex,sep="_"),width=19.3,height=10.9,units="in",res=300);
    grid.arrange(grobs=plots, top=textGrob(paste("Sample dotpot No.",ex,": stepwise"),gp=gpar(fontsize=20,font=3)),ncol=3);
    dev.off();
    
}

## generate events

## make answers

### add step-wise-answers

