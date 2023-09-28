%5 series
%clear,clc,close all
%rev. 1
%email cghiugan@iastate.edu for help
%afnum = 24110;
%foilpoints = generatefiveseries(afnum);
afnum = 2412;
foilpoints = naca4gen(afnum)*12;
%afnum = "bi105percent";
afnum = "clarky";
foilpoints = clarky()*304.8;
%foilpoints = generatebiconvex(afnum);
%printaffile(foilpoints,num2str(afnum));
%printdatfile(foilpoints,num2str(afnum));
printsolidworksfile(foilpoints,num2str(afnum));


% for afnum = 24104:24120
%     foilpoints = generatefiveseries(afnum);
%     printdatfile(foilpoints,num2str(afnum));
% end
function [outvec] = generatebiconvex(afnum)
npoints = 40;
a = char(afnum);
tc = str2num(a(3:4))/100; %thickness to chord ratio
beta = linspace(0,1,npoints);
%chord points
x = (1-cospi(beta))/2;
yu = 2*tc.*x.*(1-x)+tc*5/100;
yl = -yu;
outvec = [x',yu',x',yl'];
end
function [outvec] = naca4gen(afnum,npoints)
%afnum = 2412;
npoints = 41;
str = num2str(afnum);
a = length(str);
switch a
    case 4
  M = str2num(str(1));
  P = str2num(str(2));
  T = str2num(str(3:4));
    case 3
  M = 0;
  P = str2num(str(1));
  T = str2num(str(2:3));
    case 2
  M = 0;
  P = 0;
  T = str2num(str(1:2));
    case 1
  M = 0;
  P = 0;
  T = str2num(str(1));
end
M = M/100;
P = P/10;
T = T/100;
beta = linspace(0,1,npoints);
%chord points
x = (1-cospi(beta))/2;
ci = find(x>=P); %chord index
ci = ci(1);
cimax = length(x);
%a = [.2969 -.126 -.3516 .2843 -.1015] %open
a = [.2969 -.126 -.3516 .2843 -.1036]; %closed
%thickness calculation
y_t = T/.2*(a(1)*x.^.5+a(2)*x+a(3)*x.^2+a(4)*x.^3+a(5)*x.^4);
%front half of camber
yc(1:ci) = M/P.^2*(2*P*x(1:ci)-x(1:ci).^2);
dyc(1:ci) = 2*M/P.^2*(P-x(1:ci));
%back half of camber
yc(ci:cimax) = M/(1-P).^2*(1-2*P+2*P*x(ci:cimax)-x(ci:cimax).^2);
dyc(ci:cimax) = 2*M/(1-P).^2*(P-x(ci:cimax));
theta = atan(dyc);
xu = x - y_t.*sin(theta);
xl = x + y_t.*sin(theta);
yu = yc + y_t.*cos(theta);
yl = yc - y_t.*cos(theta);
%xu = xu(1:npoints-1);
%yu = yu(1:npoints-1);
X(1,:) = [xl,flip(xu)];
Y(2,:) = [yl,flip(yu)];
Z(3,:) = 0; %this populates 3rd row with zeros

outvec = [xu', yu', xl', yl'];
%{
clf
plot(x,yc,'b',x,zeros(cimax,2),'r',xu,yu,'-o',xl,yl,'-o')
axis([0,1,-.5,.5])%equal
legend("Chord Line","Camber Line","Upper","Lower")
%}
end
function [outvec] = generatefiveseries(afnum)
%start camber r k1 k2/k1
%values at idealcl of .3
%scale up and down linearly as needed
c = [10 .05 .0580 361.4 
     20 .10 .1260 51.64
     30 .15 .2025 15.957
     40 .20 .2900  6.643
     50 .25 .3910  3.230];
      %start camber r k1 k2/k1
 cr = [21 .10 .1300 51.990 .000764
       31 .15 .2170 15.793 .00677
       41 .20 .3180  6.520 .0303
       51 .25 .4410  3.191 .1355]; %constants

npoints = 80; %total points will be +1
afnumstr = num2str(afnum);
camberperc = str2num(afnumstr(2))*5/100; %camberperc %camber percent of chord
cm = str2num(afnumstr(2)); %CambernuMber
t = str2num(afnumstr([4 5]))/100; %thickness percent
reflex = str2num(afnumstr(3)); %1 yes 0 no
idealcl = str2num(afnumstr(1))*3/20; %controls camber strength
scalefactor = idealcl/.3;
beta = 0:pi/npoints:pi;
%xc
x = (1-cos(beta))/2; %cosine spacing
%yt
thickness = t/.2*(.2969*x.^.5-.126*x-.3516*x.^2+.28443*x.^3-.1036*x.^4); %-.1036 closed -.1015 open
splitindex = find(x>camberperc,1);
numberindex = str2num(afnumstr([2 3]));
ni = find(cr==numberindex);
r = cr(ni,3);
fx = x(x<r); %backx
bx = x(x>=r);
camber = [scalefactor*(cr(ni,4)/6*(... %front
    (fx-r).^3 -cr(ni,5)*(1-r)^3*fx-r^3*fx+r^3 ...
    )),... %back
    scalefactor*(cr(ni,4)/6*(...
    cr(ni,5)*(bx-r).^3 -cr(ni,5)*(1-r)^3*bx-r^3*bx+r^3 ...
    ))]; %yc
gradient = [scalefactor*(cr(ni,4)/6*(... %front
    3*(fx-r).^2 -cr(ni,5)*(1-r)^3-r^3 ...
    )),... %back
    scalefactor*(cr(ni,4)/6*(...
    3*cr(ni,5)*(bx-r).^2 -cr(ni,5)*(1-r)^3-r^3 ...
    ))]; %dyc/dx
theta = atan(gradient);
upper = [[x-thickness.*sin(theta)]',[camber+thickness.*cos(theta)]'];
lower = [[x+thickness.*sin(theta)]',[camber-thickness.*cos(theta)]'];
%plot(x,thickness,"-o",x,-thickness,"-o")
%plot(upper(:,1),upper(:,2),lower(:,1),lower(:,2))
%plot(x,camber,x,gradient)
%axis equal
outvec = [upper,lower];
end

function [outvec] = printaffile(pointsvec,airfoilname)
    fid = fopen(sprintf("%s.af",airfoilname),"w");
    numpts = size(pointsvec);
    numpts = numpts(1);
    fprintf(fid,sprintf("DEMO GEOM AIRFOIL FILE\nNACA %s\n0\tSym Flag (0 - No, 1 - Yes)\n",airfoilname));
    fprintf(fid,sprintf("%d\tNum Pnts Upper\n%d\tNum Pnts Lower\n",numpts,numpts));
    %upper
    for i = 1:numpts
        fprintf(fid,"%f %f\n",pointsvec(i,1),pointsvec(i,2));
    end
    fprintf(fid,"\n");
    %lower
    for i = 1:numpts
        fprintf(fid,"%f %f\n",pointsvec(i,3),pointsvec(i,4));
    end
    outvec = fclose(fid);
end
function [outvec] = printdatfile(pointsvec,airfoilname)
    fid = fopen(sprintf("%s.dat",airfoilname),"w");
    numpts = size(pointsvec);
    numpts = numpts(1);
    fprintf(fid,sprintf("NACA %s Airfoil\n",airfoilname));
    %upper
    for i = numpts:-1:1
        fprintf(fid,"%f %f\n",pointsvec(i,1),pointsvec(i,2));
    end
    %lower
    for i = 2:numpts
        fprintf(fid,"%f %f\n",pointsvec(i,3),pointsvec(i,4));
    end
    outvec = fclose(fid);
end
function [outvec] = printsolidworksfile(pointsvec,airfoilname)
    fid = fopen(sprintf("%s.txt",airfoilname),"w");
    numpts = size(pointsvec);
    numpts = numpts(1);
    %fprintf(fid,sprintf("NACA %s Airfoil\n",airfoilname));
    %upper
    for i = numpts:-1:1
        fprintf(fid,"%f,%f,0\n",pointsvec(i,1),pointsvec(i,2));
    end
    %lower
    for i = 2:numpts
        fprintf(fid,"%f,%f,0\n",pointsvec(i,3),pointsvec(i,4));
    end
    outvec = fclose(fid);
end


function [outvec] = clarky()
 top = [0.0000000 0.0000000
 0.0005000 0.0023390
 0.0010000 0.0037271
 0.0020000 0.0058025
 0.0040000 0.0089238
 0.0080000 0.0137350
 0.0120000 0.0178581
 0.0200000 0.0253735
 0.0300000 0.0330215
 0.0400000 0.0391283
 0.0500000 0.0442753
 0.0600000 0.0487571
 0.0800000 0.0564308
 0.1000000 0.0629981
 0.1200000 0.0686204
 0.1400000 0.0734360
 0.1600000 0.0775707
 0.1800000 0.0810687
 0.2000000 0.0839202
 0.2200000 0.0861433
 0.2400000 0.0878308
 0.2600000 0.0890840
 0.2800000 0.0900016
 0.3000000 0.0906804
 0.3200000 0.0911857
 0.3400000 0.0915079
 0.3600000 0.0916266
 0.3800000 0.0915212
 0.4000000 0.0911712
 0.4200000 0.0905657
 0.4400000 0.0897175
 0.4600000 0.0886427
 0.4800000 0.0873572
 0.5000000 0.0858772
 0.5200000 0.0842145
 0.5400000 0.0823712
 0.5600000 0.0803480
 0.5800000 0.0781451
 0.6000000 0.0757633
 0.6200000 0.0732055
 0.6400000 0.0704822
 0.6600000 0.0676046
 0.6800000 0.0645843
 0.7000000 0.0614329
 0.7200000 0.0581599
 0.7400000 0.0547675
 0.7600000 0.0512565
 0.7800000 0.0476281
 0.8000000 0.0438836
 0.8200000 0.0400245
 0.8400000 0.0360536
 0.8600000 0.0319740
 0.8800000 0.0277891
 0.9000000 0.0235025
 0.9200000 0.0191156
 0.9400000 0.0146239
 0.9600000 0.0100232
 0.9700000 0.0076868
 0.9800000 0.0053335
 0.9900000 0.0029690
 1.0000000 0.0005993];
 
 bottom = [0.0000000 0.0000000
 0.0005000 -.0046700
 0.0010000 -.0059418
 0.0020000 -.0078113
 0.0040000 -.0105126
 0.0080000 -.0142862
 0.0120000 -.0169733
 0.0200000 -.0202723
 0.0300000 -.0226056
 0.0400000 -.0245211
 0.0500000 -.0260452
 0.0600000 -.0271277
 0.0800000 -.0284595
 0.1000000 -.0293786
 0.1200000 -.0299633
 0.1400000 -.0302404
 0.1600000 -.0302546
 0.1800000 -.0300490
 0.2000000 -.0296656
 0.2200000 -.0291445
 0.2400000 -.0285181
 0.2600000 -.0278164
 0.2800000 -.0270696
 0.3000000 -.0263079
 0.3200000 -.0255565
 0.3400000 -.0248176
 0.3600000 -.0240870
 0.3800000 -.0233606
 0.4000000 -.0226341
 0.4200000 -.0219042
 0.4400000 -.0211708
 0.4600000 -.0204353
 0.4800000 -.0196986
 0.5000000 -.0189619
 0.5200000 -.0182262
 0.5400000 -.0174914
 0.5600000 -.0167572
 0.5800000 -.0160232
 0.6000000 -.0152893
 0.6200000 -.0145551
 0.6400000 -.0138207
 0.6600000 -.0130862
 0.6800000 -.0123515
 0.7000000 -.0116169
 0.7200000 -.0108823
 0.7400000 -.0101478
 0.7600000 -.0094133
 0.7800000 -.0086788
 0.8000000 -.0079443
 0.8200000 -.0072098
 0.8400000 -.0064753
 0.8600000 -.0057408
 0.8800000 -.0050063
 0.9000000 -.0042718
 0.9200000 -.0035373
 0.9400000 -.0028028
 0.9600000 -.0020683
 0.9700000 -.0017011
 0.9800000 -.0013339
 0.9900000 -.0009666
 1.0000000 -.0005993];
 outvec = [top,bottom];
end