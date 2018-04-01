function [h,ch]=plot3c(varargin)

% A 2d scatter plot to display 3d data, with the color of each point
% indicating the third dimension. Requires x,y,z data and a value "c" to
% show how many linearly spaced colour bins required. Otherwise a vector
% can be given, containing the edges of the colour bins. If a vector is
% used and is padded by a single nan's, the nan's will be replaced by the
% min and max value of z.
%
% This is the first function I've written to accept parameter and and value
% pairs to allow properties of the plot to be changed.
%
% Hard coded into this is colormap, marker, markersize and linestyle, with
% defaults being jet, '.', 4, and 'none'
%
%                            Jonathan Tinker 14/06/06
%
%           e.g.
%               x=rand(100,1)
%               y=sin(x)
%               z=cos(x)
%               c=10; 
%
%               [h,ch]=plot3c(x,y,z,c)

if nargin<3
    disp('Insufficient input variables, needs x,y,z')
    return
else
    x=varargin{1};
    y=varargin{2};
    z=varargin{3};
end

if nargin==3
    c=linspace(min(z),max(z),6)
else 
    c=varargin{4};
end
    
if logical(((nargin/2-floor(nargin/2))*2)==1)&(nargin>3) 
    disp('Parameter and values must be paired')
end




if length(c)==1
    n=c;
    minz=min(z);
    maxz=max(z);
    zedges=linspace(minz,maxz,n+1);
else
    zedges=c;
    if ~isempty(z)
        if isnan(zedges(1))
            zedges(1)=min(z);
        end
        if isnan(zedges(end))
            zedges(end)=max(z)+eps;
        end
    else
        if isnan(zedges(1))
            zedges(1)=zedges(1)-1;
        end
        if isnan(zedges(end))
            zedges(1)=zedges(end)+1+eps;
        end
    end
end

cnt=1;

zlabel='';

for i=5:2:length(varargin)
    if strcmp(varargin{i},'colormap')
        C=colormap(varargin{i+1});

    elseif strcmp(varargin{i},'markersize')
        mksz=varargin{i+1};

    elseif strcmp(varargin{i},'marker')
        mk=varargin{i+1}
    elseif strcmp(varargin{i},'linestyle')
        linsty=varargin{i+1};
    elseif strcmp(varargin{i},'zlabel')
        zlabel=varargin{i+1};
    else
        param{cnt}=varargin{i};
        value{cnt}=varargin{i+1};
    end
    cnt=cnt+1;
end

if exist('C')~=1
    C=colormap;
end
if exist('mksz')==0
    mksz=4;
end
if exist('mk')==0
    mk='.';
end
if exist('linsty')==0
    linsty='none';
end

zpnts=mean([zedges(1:end-1)' zedges(2:end)' ]');
cpnts=sort([zedges zpnts])';


c=C(round(linspace(1,64,length(cpnts))),:);
c=c(2:2:end,:);

hold on
for i=1:length(zedges)-1
    ind=(z>=zedges(i))&(z<zedges(i+1));
    tmph=plot(x(ind),y(ind),'color',c(i,:),'markersize',mksz,'marker',mk,'linestyle',linsty);
    if ~isempty(tmph)
        h(i)=tmph;
    else
        h(i)=nan;
    end
end

if exist('param')~=0
    for i=1:length(param)
        set(gca,param{1},value{i})
    end
end


caxis([zedges(1) zedges(end)])
ch=colorbar;


clabs=num2str(cpnts);
clabs(2:2:end,:)=' ';

set(ch,'ytick',cpnts,'YTickLabel',clabs)
set(get(ch,'ylabel'),'string',zlabel)
hold off
