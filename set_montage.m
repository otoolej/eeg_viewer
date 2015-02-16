function [REF_MONT,BI_MONT,BI_MONT_LABS,BI_MONT_HEMS]=set_montage(n_channels,SAMPSA_MONTAGE)
if(nargin<1 || isempty(n_channels)), n_channels=9; end
% set for the 'brain maturation project', where fullterm data has different electrodes
% to preterm data (i.e. fullterm has periatial instead of occipital):
if(nargin<2 || isempty(SAMPSA_MONTAGE)), SAMPSA_MONTAGE=0; end


if(n_channels==7)
    % 7-channel EEG:    
    REF_MONT={'F4','F3','P4','P3','T4','T3','Cz'};

    if(SAMPSA_MONTAGE)
        
        BI_MONT={{'F4','P4'},{'F3','P3'},{'F4','T4'},{'F3','T3'}};
        BI_MONT_LABS={'F4-P4','F3-P3','F4-T4','F3-T3'};
        
        BI_MONT_HEMS={{'F4','P4'},{'F4','T4'},{'F3','P3'},{'F3','T3'}};
    else
        
        BI_MONT={{'F4','P4'},{'F3','P3'},{'T4','Cz'},{'Cz','T3'}};
        BI_MONT_LABS={'F4-P4','F3-P3','T4-Cz','Cz-T3'};
        
        BI_MONT_HEMS={{'F4','P4'},{'T4','Cz'},{'F3','P3'},{'Cz','T3'}};
    end
    
    
else
    
    % 9-channel EEG:
    REF_MONT={'F4','T4','C4','O2','F3','C3','T3','O1','Cz'};

    if(SAMPSA_MONTAGE)
        
        BI_MONT={{'F4','C4'},{'F3','C3'},{'F4','T4'},{'F3','T3'}};
        BI_MONT_LABS={'F4-C4','F3-C3','F4-T4','F3-T3'};
        
        BI_MONT_HEMS={{'F4','C4'},{'F4','T4'},{'F3','C3'},{'F3','T3'}};
    else
        
        BI_MONT={{'F4','C4'},{'F3','C3'},{'C4','T4'},{'C3','T3'},{'C4','Cz'},...
                 {'Cz','C3'},{'C4','O2'},{'C3','O1'}};
        BI_MONT_LABS={'F4-C4','F3-C3','C4-T4','C3-T3','C4-Cz','Cz-C3','C4-O2','C3-O1'};

        BI_MONT_HEMS={{'F3','C3'},{'C3','T3'},{'C3','O1'},{'Cz','C3'}, ...
                      {'F4','C4'},{'C4','T4'},{'C4','O2'},{'Cz','C4'} };
    end
end
