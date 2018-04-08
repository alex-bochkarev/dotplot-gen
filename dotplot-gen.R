#################################################
## Main (client) file for dot-plot problem generation
################################################# 

source("./dotplot-aux.R"); # load auxiliary functions for insertions, deletions, and inversions + drawing

################################################# 
## basic constants
    
seqLength <- 100; # length of the sequences to be compared
numExamples <- 5; # number of files to generate
numEvents <- 5; # number of events (ins, del or inv) to occur in each example


## distortions probabilities (conditional on that some event occurs)
insertionProb = 0.3;
inversionProb = 0.4;
deletionProb = 1 - insertionProb - inversionProb;


seq1 = paste("block",as.character(1:seqLength),sep="_"); ## initialize the ``sequence''

insBlock = "block_INS"; ## the block that will be inserted during insertions
## (this is just a placeholder in fact, better to be absent in the source sequence)

for (ex in 1:numExamples) # generate =numExamples= examples
{
    s = list(); ## the list contains step description (text) and a sequence after each of numEvents steps
    plots = list(); ## list of the plots (the dotplot after each step)
    seq = seq1;

    s[[1]] = list("Initial sequence",seq);
    plots[[1]] = drawDotplot(seq1,seq)+ggtitle(s[[1]][[1]]);
    
    for (event in 1:numEvents)
    {
        ## generate the position of next distortion (regardless of type -- ins,del, or inv)
        rndPosition = round(runif(1,1,length(seq))); # random distortion position (uniformely distributed)
        eventProb = runif(1,0,1); ## generate random event to determine distortion type

        if(eventProb<=insertionProb){
            ## INSERTION happened
            rndDistLength = round(runif(1,1,round(length(seq)/2))); # uniform, half of the sequence max
            s[[event+1]] = insertion(seq,rndPosition,rep(insBlock,times=rndDistLength),TRUE);
        }else if(eventProb<=insertionProb+inversionProb){
            ## INVERSION happened
            rndDistLength = round(runif(1,1,round(length(seq)/2))); # uniform, half of sequnece max
            s[[event+1]] = inversion(seq,rndPosition,rndDistLength,TRUE);

        }else if(eventProb>insertionProb+inversionProb){
            ## DELETION happened
            rndDistLength = round(runif(1,1,round(length(seq)/2))); # uniform, half of sequence max
            s[[event+1]] = deletion(seq,rndPosition,rndDistLength,TRUE);
            
        }
       
        seq = s[[event+1]][[2]];
        plots[[event+1]] = drawDotplot(s_reference=seq1,s_query=seq)+
            ggtitle(s[[event+1]][[1]]);
    }


    ## 
    ## save sample (final) dotplot
    
    png(paste("./samples/Sample_",ex,".png",sep=""),width=19.3,height=10.9,units="in",res=300);    
    print(drawDotplot(s_reference = seq1,s_query=seq)+
        ggtitle(paste("Sample (final) dotplot No.",ex)));
    dev.off();

    ##
    ## save stepwise transformation (``the answer'')
    
    png(paste("./stepwise/Sample_",ex,"_stepwise.png",sep=""),width=19.3,height=10.9,units="in",res=300);
    grid.arrange(grobs=plots, top=textGrob(paste("Sample dotpot No.",ex,": stepwise"),gp=gpar(fontsize=20,font=3)),ncol=3);
    dev.off();    
}
