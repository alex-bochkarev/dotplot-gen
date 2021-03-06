#################################################
## Main (client) file for dot-plot problem generation
################################################# 

source("./dotplot-aux.R"); # load auxiliary functions for insertions, deletions, and inversions + drawing

################################################# 
## basic constants
    
seqLength <- 100; # length of the sequences to be compared
numExamples <- 10; # number of files to generate
numEvents <- 5; # number of events (ins, del or inv) to occur in each example

maxIns <- 0.5; # maximum length of the distorion, relative to the current sequence length
maxInv <- 0.5; # maximum length of the distorion, relative to the current sequence length
maxDel <- 0.5; # maximum length of the distorion, relative to the current sequence length

## distortions probabilities (conditional on that some event occurs)
insertionProb = 0.15;
inversionProb = 0.7;
deletionProb = 1 - insertionProb - inversionProb;


seq1 = paste("block",as.character(1:seqLength),sep="_"); ## initialize the ``sequence''

insBlock = "block_INS"; ## the block that will be inserted during insertions
## (this is just a placeholder in fact, better to be absent in the source sequence)

pb <- txtProgressBar(min=1,max=numExamples*numEvents,style=3); ## auxiliary variable -- progress bar

for (ex in 1:numExamples) # generate =numExamples= examples
{
    s = list(); ## the list contains step description (text) and a sequence after each of numEvents steps
    plots = list(); ## list of the plots (the dotplot after each step)
    seq = seq1;

    s[[1]] = list("Initial sequence",seq);
    plots[[1]] = drawDotplot(seq1,seq)+ggtitle(s[[1]][[1]]);

    ## here we keep track of colors (changing color of the inverted sub-sequence)
    color_change = rep(FALSE, length(seq1)); ## the color is used to visually track inversions
    
    for (event in 1:numEvents)
    {
        ## generate the position of next distortion (regardless of type -- ins,del, or inv)
        rndPosition = round(runif(1,1,length(seq))); # random distortion position (uniformely distributed)
        eventProb = runif(1,0,1); ## generate random event to determine distortion type

        if(eventProb<=insertionProb){
            ## INSERTION happened
            rndDistLength = round(runif(1,1,round(length(seq)*maxIns))); # uniform, half of the sequence max
            s[[event+1]] = insertion(seq,rndPosition,rep(insBlock,times=rndDistLength),TRUE); ## update the sequence
            color_change = insertion(color_change, rndPosition,rep(FALSE,times=rndDistLength)); ## update colors vector
        }else if(eventProb<=insertionProb+inversionProb){
            ## INVERSION happened
            rndDistLength = round(runif(1,1,round(length(seq)*maxInv))); # uniform, half of sequnece max
            s[[event+1]] = inversion(seq,rndPosition,rndDistLength,TRUE); ## update the sequence

            color_change = inversion(color_change,rndPosition,rndDistLength,invertColor=TRUE); ## update colors

        }else if(eventProb>insertionProb+inversionProb){
            ## DELETION happened
            rndDistLength = round(runif(1,1,round(length(seq)*maxDel))); # uniform, half of sequence max
            s[[event+1]] = deletion(seq,rndPosition,rndDistLength,TRUE); ## update the sequence
            color_change = deletion(color_change,rndPosition,rndDistLength); ## update colors
        }
       
        seq = s[[event+1]][[2]];
        plots[[event+1]] = drawDotplot(s_reference=seq1,s_query=seq,s_query_changed_color=color_change)+
            ggtitle(s[[event+1]][[1]]);
        setTxtProgressBar(pb,(ex-1)*numEvents+event);
    }


    ## 
    ## save sample (final) dotplot
    
    png(paste("./samples/Sample_",ex,".png",sep=""),width=19.3,height=10.9,units="in",res=300);    
    print(drawDotplot(s_reference = seq1,s_query=seq,s_query_changed_color=color_change)+
        ggtitle(paste("Sample (final) dotplot No.",ex)));
    dev.off();

    ##
    ## save stepwise transformation (``the answer'')
    
    png(paste("./stepwise/Sample_",ex,"_stepwise.png",sep=""),width=19.3,height=10.9,units="in",res=300);
    grid.arrange(grobs=plots, top=textGrob(paste("Sample dotpot No.",ex,": stepwise"),gp=gpar(fontsize=20,font=3)),ncol=3);
    dev.off();
    
    close(pb);
}
