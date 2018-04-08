#################################################
## Auxiliary functions
## To be used for dot-plot problems generation
## A.A. Bochkarev, aabochkaryov@gmail.com
################################################# 


#################################################
## Required libraries

library(ggplot2)
library(gridExtra)
library(grid)

no_of_Xticks <- 30; ## number of ticks along the X axis
no_of_Yticks <- no_of_Xticks; ## --//--//-- Y axis

################################################# 
## Allowed distortion functions

insertion <- function(sequence, where, what, returnText=FALSE)
    ## INPUT:
    ## sequence = vector of elements (blocks)
    ## where = after which position (block) to insert; indexing starts from ONE
    ## what = what to insert
    ## returnText = logical, whether return sequence only (if FALSE) or sequence+text
    ## OUTPUT:
    ## a list of 2 elements: {text-description(character), new-sequence}
    ## or new-sequence (if returnText==FALSE)
    ## NOTES:
    ## if =where= <= 0 then the inversion is assumed to start from the first block
{
    if(where>0){
        sequence <- c(sequence[1:where],what,sequence[where:length(sequence)]);
    }else{
        sequence <- c(what,sequence);        
    }

    if(returnText){
        return(list(paste("Insertion after pos.",where, ",",length(what), "blocks"),sequence));
    }else{
        return(sequence);
    }

}

deletion <- function(sequence, where, howLong, returnText=FALSE)
    ## INPUT:
    ## sequence = vector of elements (blocks)
    ## where = starting from which position to delete; indexing starts from ONE
    ## howLong = number of positions (blocks) to delete
    ## returnText = logical, whether return sequence only (if FALSE) or sequence+text
    ## OUTPUT:
    ## a list of 2 elements: {text-description(character), new-sequence}
    ## or new-sequence (if returnText==FALSE)
    ## NOTES:
    ## 1) if =where= <= 0 then the deletion is assumed to start from the first block
    ## 2) if =howLong= <= 0 then ONE symbol is deleted
{

    if (howLong<=0) howLong <- 1;
    if (where<=1) where <- 1;
    
    indices <- setdiff(1:length(sequence),(where):(where+howLong-1));

    if(returnText){
        return(list(paste("Deletion starting from",where,",",howLong,"blocks"),sequence[indices]));
    }else{
        return(sequence[indices]);
    }
}

inversion <- function(sequence, where, howLong, returnText=FALSE, invertColor=FALSE)
    ## INPUT:
    ## sequence = vector of elements (blocks)
    ## where = invert starting from which position (block); indexing starts from ONE
    ## howLogn = inversion length (in blocks)
    ## returnText = logical, whether return sequence only (if FALSE) or sequence+text
    ## invertColor = logical; used when the inverted sequence has to be logically inverted (apply NOT to the inverted part of the sequence -- used to track color)
    ## OUTPUT:
    ## a list of 2 elements: {text-description(character), new-sequence}   
    ## or new-sequence (if returnText==FALSE)
{

    ## ensure we won't go further than the right side
    where = min(where,length(sequence)); 
    howLong = min(howLong, length(sequence) - where+1);

    sequence[where:(where+howLong-1)] <- rev(sequence[where:(where+howLong-1)]);

    if(invertColor) sequence[where:(where+howLong-1)] <- !sequence[where:(where+howLong-1)]; ## used if =sequence= is actually a description of the color of each point in the sequence (FALSE/TRUE corresponding to "initial"/"new")   
    
    if(returnText){
        return(list(paste("Inversion starting from", where,",",howLong,"blocks"),sequence));
    }else{
        return(sequence);
    }
}


## Dotplot drawing function
drawDotplot <- function(s_reference,s_query,s_query_changed_color=NULL)
    ## INPUT:
    ## s_reference -- an atomic vector of reference sequence (will be along Ox axis)
    ## s_query -- an atomic vector of query sequence (will be along Oy axis)
    ## s_query_changed_color -- a logical vector; if used, the function draws
    ## all =s_query= points marked as FALSE with =blue= color and =red= otherwise
    ## OUTPUT:
    ## ggplot object of the corresponding dotplot
{

    points_to_draw = lapply(1:length(s_reference),function(s){
        Ys = which(s_reference[s]==s_query)
        Xs = rep(s,times=length(Ys))
        if(is.null(s_query_changed_color)) {
            change_color = rep(FALSE, times=length(Ys));
        }else{
            change_color = s_query_changed_color[which(s_reference[s]==s_query)];
        }
        cbind(Xs,Ys,change_color);
    });

    points_to_draw <- do.call(rbind.data.frame, points_to_draw);
    points_to_draw$change_color <- as.logical(points_to_draw$change_color);
    
    ggplot(points_to_draw, aes(x=Xs, y=Ys, color=change_color)) +
        geom_point()+
        xlab("Sequence 1 -- reference")+
        ylab("Sequence 2 -- query")+
        scale_x_continuous(breaks = with(points_to_draw, seq(min(Xs),max(Xs),by=round((max(Xs)-min(Xs))/no_of_Xticks))))+
        scale_y_continuous(breaks = with(points_to_draw, seq(min(Ys),max(Ys),by=round((max(Ys)-min(Ys))/no_of_Yticks))))+
        scale_color_manual(breaks = c(FALSE,TRUE), values=c("blue","red"))+
        guides(color=FALSE)
        
}
