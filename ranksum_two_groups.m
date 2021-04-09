function [results]=ranksum_two_groups(LI,sex);

%this script compares males and females using Wilcoxon rank sum

%inputs:
%LI - matrix of n subjects by n regions
%sex - vector of sex of each subject (1 is female, 2 is male)

%outputs:
%results - matrix containing the test's metrics for each region in LI
%(columns). Line 1 shows p-value, line 2 shows Bonferroni-Holm corrected 
%p-values, line 3 shows Z, line 4 shows effect size


%Created by Madalena Esteves: madalena.curva.esteves@gmail.com

%Cite as: Madalena Esteves (2021). ranksum_two_groups
%(https://github.com/madalenaesteves/mood_asymmetry/blob/main/ranksum_two_groups.m).




%separating male and female
LI_F=[];
LI_M=[];
for i=1:length(sex);
    if sex(i)==1;
        LI_F=[LI_F; LI(i,:)];
    else if sex(i)==2;
        LI_M=[LI_M; LI(i,:)];
        end
    end
end

%remove outliers
LINaN_M=LI_M;
LINaN_F=LI_F;
for i=1:size(LINaN_M,2);
    NaNs=[];
    NaNs=isnan(LINaN_M(:,i));
    yNaN=[];
    yNaN=find(NaNs==1);
    nNaN=[];
    nNaN=find(NaNs==0);
    A=[];
    A(yNaN)=NaN;
    A(nNaN)=abs(zscore(LINaN_M(nNaN,i)));
    B=[];
    B=find(A>=3);
    C=isempty(B);
    if C==0;
    LINaN_M(B,i)=NaN;
    else
    end
    
    NaNs=[];
    NaNs=isnan(LINaN_F(:,i));
    yNaN=[];
    yNaN=find(NaNs==1);
    nNaN=[];
    nNaN=find(NaNs==0);
    A=[];
    A(yNaN)=NaN;
    A(nNaN)=abs(zscore(LINaN_F(nNaN,i)));
    B=[];
    B=find(A>=3);
    C=isempty(B);
    if C==0;
    LINaN_F(B,i)=NaN;
    else
    end
end

%initialize variables
p_=[];
z_=[];
ef_size_=[];

%for each region...
for i=1:size(LINaN_M,2);
    
    %Calculates statistics (difference between groups)
    [p,h,stats]=ranksum(LINaN_M(:,i),LINaN_F(:,i));
    
    %calculate number of subjects included in the analysis
    NaNs=[];
    NaNs=isnan(LINaN_M(:,i));
    nNaN=[];
    nNaN=find(NaNs==0);
    n=[];
    n=length(nNaN);
    
    NaNs=[];
    NaNs=isnan(LINaN_F(:,i));
    nNaN=[];
    nNaN=find(NaNs==0);
    n=n+length(nNaN);
    
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