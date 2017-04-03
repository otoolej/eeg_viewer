%-------------------------------------------------------------------------------
% check_montage: Re-order and change to bipolar montage (if required)
%
% Syntax: [sig,ch_labs]=check_montage(sig,channel_labs,BIPOLAR_MONT)
%
% Inputs: 
%     sig,channel_labs,BIPOLAR_MONT - 
%
% Outputs: 
%     [sig,ch_labs] - 
%
% Example:
%     
%

% John M. O' Toole, University College Cork
% Started: 12-03-2013
%-------------------------------------------------------------------------------
function [sig,channel_labs]=check_montage(sig,channel_labs,BIPOLAR_MONT,SAMPSA_MONTAGE)
if(nargin<3 || isempty(BIPOLAR_MONT)), BIPOLAR_MONT=0; end
if(nargin<4 || isempty(SAMPSA_MONTAGE)), SAMPSA_MONTAGE=0; end


% load in the montages:
[REF_MONT,BI_MONT,BI_MONT_LABS,BI_MONT_HEMS]=set_montage(length(channel_labs),SAMPSA_MONTAGE);

if(~BIPOLAR_MONT)
    channel_order=REF_MONT;
else
    channel_order=BI_MONT;
end

M=length(channel_order);

% which montage and re-shuffle data as necessary:
if(~BIPOLAR_MONT)
    
  inw=zeros(1,M);
  for m=1:M
    inw(m)=find(~cellfun('isempty',strfind(upper(channel_labs), ...
                                           upper(channel_order{m}))));
  end
    
  inw=inw(end:-1:1);
    
  sig=sig(inw,:);
  channel_labs=channel_labs(inw);
    
  % add '-REF' to labels
  channel_labs=add_labels_monopolar(channel_order(end:-1:1));
    
elseif(BIPOLAR_MONT==1)
    [sig,channel_labs]=set_biplot_montage(sig,channel_labs,BI_MONT);
    
    [M,N]=size(sig);
    
elseif(BIPOLAR_MONT==2)
    [sig,channel_labs]=set_biplot_montage(sig,channel_labs,BI_MONT_HEMS);
    
    [M,N]=size(sig);
    
end




function [bi_sigs,bi_labels]=set_biplot_montage(sigs,channel_names,bi_mont)
%---------------------------------------------------------------------
% Define and set the bi-polar montage (here its a laterial one)
%---------------------------------------------------------------------

L=length(bi_mont);  [M,N]=size(sigs);

%isig_bi=zeros(L,2);
bi_sigs=zeros(L,N);

for n=1:L
    isig_first=find(~cellfun('isempty',strfind(upper(channel_names), ...
                                               upper(bi_mont{n}{1}))));
    isig_second=find(~cellfun('isempty',strfind(upper(channel_names),...
                                                upper(bi_mont{n}{2}))));    
    
    if(isempty(isig_first) || isempty(isig_second))
        keyboard;
    end

    
    bi_sigs(n,:)=sigs(isig_first,:)-sigs(isig_second,:);
end

if(strcmp(channel_names{end},'ECG')==1)
    bi_labels{1}='ECG';
    istart=1;
    bi_sigs(L+1,:)=sigs(L+2,:);
else
    istart=0;
end

for n=1:L
    bi_labels{n+istart}=char( [bi_mont{n}{1} '-' bi_mont{n}{2}] );
end


Le=length(bi_labels);
if(strcmp(channel_names{end},'ECG')==1)
    tmp{1}=bi_labels{1};
    for b=1:L
        tmp{b+1}=bi_labels{Le-b+1};
    end
else
    for b=1:L
        tmp{b}=bi_labels{Le-b+1};
    end
end
bi_labels=tmp;


%bi_labels=bi_labels{end:-1:1};
bi_sigs=bi_sigs(end:-1:1,:);


function  channel_labs=add_labels_monopolar(channel_labs)
M=length(channel_labs);

for n=1:M
  channel_labs{n}=[channel_labs{n} '-Ref'];
end
