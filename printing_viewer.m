%-------------------------------------------------------------------------------
% printing_viewer: for printing from eeg_plotgui_withannos.m, must have viewer as
%                  current figure
%
% Syntax: [hfig]=printing_viewer(fignum)
%
% Inputs: 
%     fignum - 
%
% Outputs: 
%     [hfig] - 
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 10-06-2015
%
% last update: Time-stamp: <2018-03-15 18:07:27 (otoolej)>
%-------------------------------------------------------------------------------
function [hfig]=printing_viewer(fignum,fname,YLABELS_SHIFT,REMOVE_ANNO_AXIS)
if(nargin<1 || isempty(fignum)), fignum=1; end
if(nargin<2 || isempty(fname)), fname=[]; end
if(nargin<3 || isempty(YLABELS_SHIFT)), YLABELS_SHIFT=0; end
if(nargin<4 || isempty(REMOVE_ANNO_AXIS)), REMOVE_ANNO_AXIS=0; end




set(0,'showhiddenhandles','on'); % Make the GUI figure handle visible
h=findobj(gcf,'type','axes'); % Find the axes object in the GUI

f1=figure(fignum); % Open a new figure with handle f1
clf(f1);
s=copyobj(h,f1); % Copy axes object h into figure f1


if(YLABELS_SHIFT)
    ax=findall(f1,'type','axes');
    ax=ax(~ismember(get(ax,'Tag'),{'legend','Colobar'}));

    Y_SHIFT=100;
    for p=1:length(ax)
        ch_labels=get(ax(p),'yticklabel');    
        N_channels=length(ch_labels);
        y_pos=get(ax(p),'ytick');
        set(ax(p),'ytick',[]);
        xl=xlim;
        % if EEG channels then include a shift:
        if(N_channels>1)
            ys=Y_SHIFT;
        else
            ys=1;
        end
        for n=1:N_channels
            if(N_channels>3)
                text(xl(1)+1,y_pos(n),ch_labels{n},'fontname','helvetica','fontsize',14, ...
                     'backgroundcolor','w','horizontalalignment','left',...
                     'Parent',ax(p));
            else
                text(xl(1)+1,y_pos(n),ch_labels{n},'fontname','helvetica','fontsize',14, ...
                     'backgroundcolor','w','horizontalalignment','left',...
                     'Parent',ax(p));
            end
        end
        
        set(ax(p),'xtick',[]);
        set(ax(p),'fontName','helvetica');
        set(ax(p),'fontSize',14);
    end
end


set(gca,'xtick',[]);
set(gca,'fontName','helvetica');
set(gca,'fontSize',14);


% remove annotation axis:
if(REMOVE_ANNO_AXIS)
    ax_obj=findobj(gcf, 'type','axes');
    ianno=find(ismember({ax_obj.Tag},'anno_axis'));
    if(~isempty(ianno))
        delete(ax_obj(ianno));
    end
end


if(~isempty(fname))
    print2eps(fname);
end
