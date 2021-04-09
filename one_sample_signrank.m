function [LINaN,results]=one_sample_signrank(LI);

%this script performs one-sample test using Wilcoxon signed rank

%inputs:
%LI - matrix of n subjects by n regions

%outputs:
%results - matrix containing the test's metrics for each region in LI
%(columns). Line 1 shows p-value, line 2 shows Bonferroni-Holm corrected 
%p-values, line 3 shows Z, line 4 shows effect size
%LINaN - LI without outliers

%Created by Madalena Esteves: madalena.curva.esteves@gmail.com

%Cite as: Madalena Esteves (2021). one_sample_signrank
%(https://github.com/madalenaesteves/mood_asymmetry/blob/main/one_sample_signrank.m).



%removes outliers
LINaN=LI;
for i=1:size(LINaN,2);
    NaNs=[];
    NaNs=isnan(LINaN(:,i));
    yNaN=[];
    yNaN=find(NaNs==1);
    nNaN=[];
    nNaN=find(NaNs==0);
    A=[];
    A(yNaN)=NaN;
    A(nNaN)=abs(zscore(LINaN(nNaN,i)));
    B=[];
    B=find(A>=3);
    C=isempty(B);
    if C==0;
    LINaN(B,i)=NaN;
    else
    end
end

%initiates variables
p_=[];
z_=[];
ef_size_=[];

%for each region...
for i=1:size(LINaN,2);
    
    %Calculates statistics (difference from 0)
    [p,h,stats]=signrank(LINaN(:,i));
    
    %calculate number of subjects included in the analysis
    NaNs=[];
    NaNs=isnan(LINaN(:,i));
    nNaN=[];
    nNaN=find(NaNs==0);
    n=[];
    n=length(nNaN);
    
    %stores statistical data
    p_=[p_ p];
    z_=[z_ stats.zval];
    ef_size_=[ef_size_ stats.zval/sqrt(n)];
end

%calculates Bonferroni-Holm-corrected p-value
[corrected_p, h]=bonf_holm(p_);

%retrieves results
results=[p_; corrected_p; z_; ef_size_];
end