%-------------------------------------------------------------------------------
% eplot_annos: Plot annotations on a separate axis
%
% Syntax: []=eplot_annos(annos,figaxis)
%
% Inputs: 
%     annos - 
%
% Outputs: 
%     [] - 
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 29-05-2013
%-------------------------------------------------------------------------------
function []=eplot_annos(annos,figaxis,Fs,annos_labels,keep_xticks)
if(nargin<2 || isempty(figaxis)), figaxis=gca; end
if(nargin<3 || isempty(Fs)), Fs=1; end
if(nargin<4 || isempty(annos_labels)), annos_labels=[]; end
if(nargin<5 || isempty(keep_xticks)), keep_xticks=0; end


LINE_PLOT=1;
LINE_WIDTH=20;
L=1;

ANNO_COLOURS={[128 0 128]./256,[173 216 230]./256,[255 165 0]./256};


axes(figaxis);
    

if(LINE_PLOT)
    
    if(iscell(annos))
        
        if(max(annos{1})==1)
            ANNO_COLOURS=ANNO_COLOURS(1:2);
        end

        L=length(annos); 
        line_scale=(1/L)+0.2;
        for p=1:L
            plot_line_annos(annos{p},min(size(annos{p})),Fs,...
                            ANNO_COLOURS,LINE_WIDTH*line_scale,p);        
        end
        ylim([0.8 L+0.2]); 
    else
        plot_line_annos(annos,size(annos,1),Fs,ANNO_COLOURS,LINE_WIDTH,1);
        ylim([0.8 1.2]); 
    end
    if(isempty(annos_labels))
        set(figaxis,'Ytick',[]);
    end
else
    [L,N]=size(annos);          
    
    n=(0:N-1)./Fs;

    hold all;
    for p=1:L
        pc=mod(p-1,L)+1;
        
        plot(figaxis,n,annos(p,:)+((p-1)*1.2),'color',ANNO_COLOURS{pc});
    end
    hold off;

    ylim([-0.1 (L)*1.2]);
end
if(~keep_xticks)
    set(figaxis,'Xtick',[]);
end




if(~isempty(annos_labels))
    set(figaxis,'ytick',[1:1:L]);
    set(figaxis,'yticklabel',annos_labels);
end
    




function plot_line_annos(annos,L,Fs,ANNO_COLOURS,LINE_WIDTH,ypoint)
%---------------------------------------------------------------------
% plot the lines to mark the annotations
%---------------------------------------------------------------------
[N,M]=size(annos);
if(N>M), annos=annos.'; end

hold all;
for p=1:L
    pc=mod(p-1,L)+1;
    
    [istart,iend]=break_into_segments(annos(p,:));
    istart=(istart)./Fs; iend=(iend)./Fs;

    for q=1:length(istart)
        line([istart(q) iend(q)], [ypoint, ypoint], 'color', ...
             ANNO_COLOURS{pc},'linewidth',LINE_WIDTH);
    end
end
hold off;



function [istart,iend]=break_into_segments(d)
t=diff([0 d>0 0]);
istart=find(t==1);
iend=find(t==-1);
