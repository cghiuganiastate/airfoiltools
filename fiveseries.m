%5 series
%clear,clc,close all
%rev. 2
%email cghiugan@iastate.edu for help

%write what airfoil you want here
afnum = 0012;
%scale by your chord length
foilpoints = trimte(naca4gen(afnum))*1;
%if you need to trim the TE you can do it here, or at the export
%just pass in your variable through trimte
%like so 
%foilpoints = trimte(naca4gen(afnum))
%foilpoints = trimte(foilpoints);



%Five series reflex example 
afnum = 24110;
foilpoints = trimte(generatefiveseries(afnum));
%biconvex example
%afnum = "bi105percent";
%foilpoints = generatebiconvex(afnum);

%clarky example
% afnum = "clarky";
% foilpoints = clarky()*304.8;


 afnum = "sd7080";
 foilpoints = trimte(sd7080());
 
 afnum = "65030";
 foilpoints = rotateaf(scaletc(trimte(generate65020()),3/2),-10);
 plot(foilpoints(:,1),foilpoints(:,2),foilpoints(:,3),foilpoints(:,4))
 axis equal
%afnum = "e63";
%foilpoints = e63();

%call your printing routine here
%printaffile(foilpoints,num2str(afnum));
%printdatfile(foilpoints,num2str(afnum));
printsolidworksfile(foilpoints,num2str(afnum),0,0,0);
%personal project, exporting boeing 737 tail airfoils for use in openVSP/XFLR5
printdatfile(bac737ht('a'),"boeing_737a_ht");
printdatfile(bac737ht('b'),"boeing_737b_ht");
printdatfile(bac737ht('c'),"boeing_737c_ht");
printdatfile(bac737vt('a'),"boeing_737a_vt");
printdatfile(bac737vt('b'),"boeing_737b_vt");
printdatfile(bac737vt('c'),"boeing_737c_vt");
printdatfile(bac737vt('d'),"boeing_737d_vt");
printdatfile(bac737vt('e'),"boeing_737e_vt");
%lets make an airplane
aircraftname = "design1mk8curves";
mkdir(aircraftname);
cd(aircraftname);
wingle = 7;
wchord = 14;
wsspanstraight = 21+6;
wsspancrank = 21;
wcrankdih = 10;
wsspandih = wsspanstraight+wsspancrank;
wdih = 5;
wingup = 1;
wingia = 1.25;
taille = 54;
tchord = 9;
tailia = -1.75;
taildih = 35;
tailspan = 12;
tailafnum = 0012;
tailup = 0;%-.25;

afname = "wingroot";
x = wingle;
y = 0;
z = wingup;
chord = wchord;
foilpoints = rotateaf(trimte(trimte(trimte(sd7080()))),wingia)*chord;
printsolidworksfile(foilpoints,afname,x,y,z);
%parts for crank dihedral
afname = "wingmid";
x = wingle;
y = wsspanstraight;
z = wingup;
chord = wchord;
foilpoints = rotateaf(trimte(trimte(trimte(sd7080()))),wingia)*chord;
printsolidworksfile(foilpoints,afname,x,y,z);
afname = "wingmidleft";
x = wingle;
y = wsspanstraight;
z = wingup;
chord = wchord;
foilpoints = rotateaf(trimte(trimte(trimte(sd7080()))),wingia)*chord;
printsolidworksfile(foilpoints,afname,x,-y,z);
afname = "wingtip";
x = wingle;
y = wsspanstraight+wsspancrank;
z = wingup+sind(wcrankdih)*wsspancrank;
chord = wchord;
foilpoints = rotateaf(trimte(trimte(trimte(sd7080()))),wingia)*chord;
printsolidworksfile(foilpoints,afname,x,y,z);
afname = "wingtipleft";
x = wingle;
y = wsspanstraight+wsspancrank;
z = wingup+sind(wcrankdih)*wsspancrank;
chord = wchord;
foilpoints = rotateaf(trimte(trimte(trimte(sd7080()))),wingia)*chord;
printsolidworksfile(foilpoints,afname,x,-y,z);

% %parts for simple dihedral
% afname = "wingdihtip";
% x = wingle;
% y = wsspandih;
% z = wingup+sind(wdih)*wsspandih;
% chord = wchord;
% foilpoints = trimte(trimte(trimte(sd7080()*chord)));
% printsolidworksfile(foilpoints,afname,x,y,z);
% afname = "wingdihtipleft";
% x = wingle;
% y = wsspandih;
% z = wingup+sind(wdih)*wsspandih;
% chord = wchord;
% foilpoints = trimte(trimte(trimte(sd7080()*chord)));
% printsolidworksfile(foilpoints,afname,x,-y,z);

%parts for tail
afname = "tailroot";
x = taille;
y = 0;
z = tailup;
chord = tchord;
foilpoints = rotateaf(trimte(trimte(trimte(trimte(naca4gen(tailafnum))))),tailia)*chord;
printsolidworksfile(foilpoints,afname,x,y,z);
afname = "tailtip";
x = taille;
y = tailspan*cosd(taildih);
z = tailup+tailspan*sind(taildih);
chord = tchord;
foilpoints = rotateaf(trimte(trimte(trimte(trimte(naca4gen(tailafnum))))),tailia)*chord;
printsolidworksfile(foilpoints,afname,x,y,z);
afname = "tailtipleft";
x = taille;
y = tailspan*cosd(taildih);
z = tailup+tailspan*sind(taildih);
chord = tchord;
foilpoints = rotateaf(trimte(trimte(trimte(trimte(naca4gen(tailafnum))))),tailia)*chord;
printsolidworksfile(foilpoints,afname,x,-y,z);
%swtailspar(.57,6,0,54+5+1-6)
cd("..") %dont forget to change back

% afname = "fuselage";
% x = 0;
% y = 0;
% z = 0;
% chord = 24;
% foilpoints = scaletc(trimte(generate65020()),3/2)*chord;
% afname = "fuselage2";
% x = 0;
% y = 0;
% z = 0;
% chord = 36;
% foilpoints = scaletc(trimte(generate65020()),2/2)*chord;
% printswupper(foilpoints,afname,x,y,z);

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
function [outvec] = printsolidworksfile(pointsvec,airfoilname,x,y,z)
    fid = fopen(sprintf("%s.sldcrv",airfoilname),"w");
    numpts = size(pointsvec);
    numpts = numpts(1);
    %fprintf(fid,sprintf("NACA %s Airfoil\n",airfoilname));
    %upper
    for i = numpts:-1:1
        fprintf(fid,"%fin %fin  %fin\n",pointsvec(i,1)+x,y,pointsvec(i,2)+z);
    end
    %lower
    for i = 2:numpts
        fprintf(fid,"%fin %fin  %fin\n",pointsvec(i,3)+x,y,pointsvec(i,4)+z);
    end
    outvec = fclose(fid);
end
function [outvec] = printswupper(pointsvec,airfoilname,x,y,z)
    fid = fopen(sprintf("%s.txt",airfoilname),"w");
    numpts = size(pointsvec);
    numpts = numpts(1);
    %fprintf(fid,sprintf("NACA %s Airfoil\n",airfoilname));
    %upper
    for i = numpts:-1:1
        fprintf(fid,"%f,%f,%f\n",pointsvec(i,1)+x,y,pointsvec(i,2)+z);
    end
    %lower
    % for i = 2:numpts
    %     fprintf(fid,"%f,%f,%f\n",pointsvec(i,3),y,pointsvec(i,4));
    % end
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
function [outvec] = sd7080()
 top = flip([1.000000  0.000000
  0.996710  0.000370
  0.987010  0.001620
  0.971330  0.003950
  0.950180  0.007430
  0.924130  0.011950
  0.893720  0.017280
  0.859430  0.023130
  0.821690  0.029190
  0.780840  0.035190
  0.737200  0.040970
  0.691170  0.046470
  0.643260  0.051630
  0.594020  0.056350
  0.543990  0.060520
  0.493710  0.064040
  0.443700  0.066800
  0.394480  0.068710
  0.346560  0.069690
  0.300400  0.069660
  0.256440  0.068580
  0.215090  0.066410
  0.176700  0.063120
  0.141570  0.058750
  0.109960  0.053340
  0.082100  0.046990
  0.058140  0.039830
  0.038210  0.032030
  0.022370  0.023830
  0.010680  0.015580
  0.003220  0.007630
  ]);
 
 bottom = [0.000030  0.000610
  0.000000  0.00000
  0.002160 -0.004920
  0.010160 -0.009480
  0.023470 -0.013540
  0.041980 -0.016940
  0.065490 -0.019620
  0.093830 -0.021560
  0.126760 -0.022790
  0.163970 -0.023370
  0.205080 -0.023380
  0.249620 -0.022890
  0.297100 -0.021940
  0.347000 -0.020590
  0.398770 -0.018910
  0.451830 -0.016960
  0.505590 -0.014800
  0.559450 -0.012500
  0.612810 -0.010150
  0.665050 -0.007830
  0.715570 -0.005640
  0.763760 -0.003660
  0.809000 -0.002010
  0.850680 -0.000720
  0.888200  0.000170
  0.921040  0.000690
  0.948710  0.000870
  0.970790  0.000760
  0.986890  0.000470
  0.996710  0.000150
  1.00000  0.000000];
  size(top);
  size(bottom);
 outvec = [top,bottom];
end

function [outvec] = e63()
%use for apc prop root
 top = flip([1.000000  0.000000
  0.997190  0.001210
  0.989380  0.004730
  0.977510  0.009860
  0.961730  0.015530
  0.941640  0.021260
  0.917170  0.027090
  0.888610  0.033010
  0.856240  0.038850
  0.820390  0.044510
  0.781410  0.049850
  0.739680  0.054800
  0.695620  0.059210
  0.649670  0.063040
  0.602290  0.066170
  0.553940  0.068570
  0.505090  0.070160
  0.456240  0.070940
  0.407860  0.070840
  0.360430  0.069900
  0.314410  0.068090
  0.270260  0.065450
  0.228400  0.061980
  0.189200  0.057750
  0.153040  0.052800
  0.120230  0.047230
  0.091030  0.041110
  0.065680  0.034570
  0.044350  0.027750
  0.027140  0.020830
  0.014160  0.014040]);
 
 bottom = [0.005360  0.007660
  0.000760  0.002180
  0.000000 0.000000
  0.000550 -0.001410
  0.005570 -0.003060
  0.016510 -0.003300
  0.033160 -0.002270
  0.055500 -0.000040
  0.083420  0.003150
  0.116710  0.007080
  0.155040  0.011510
  0.198000  0.016200
  0.245090  0.020930
  0.295740  0.025460
  0.349310  0.029620
  0.405130  0.033190
  0.462470  0.036050
  0.520560  0.038030
  0.578590  0.039070
  0.635760  0.039070
  0.691250  0.038060
  0.744300  0.036040
  0.794140  0.033100
  0.840040  0.029300
  0.881320  0.024820
  0.917350  0.019790
  0.947560  0.014390
  0.971150  0.008870
  0.987540  0.004100
  0.996950  0.001020
  1.000000  0.000000];
  size(top);
  size(bottom);
 outvec = [top,bottom];
end
function [outvec] = generate65020()
  top = flip([1.000000  0.000000
  0.950000  0.007170
  0.900000  0.019240
  0.850000  0.033240
  0.800000  0.047960
  0.750000  0.062510
  0.700000  0.076100
  0.650000  0.087930
  0.600000  0.096920
  0.550000  0.101860
  0.500000  0.104340
  0.450000  0.105000
  0.400000  0.104070
  0.350000  0.101540
  0.300000  0.097380
  0.250000  0.091530
  0.200000  0.083760
  0.150000  0.073690
  0.100000  0.060520
  0.075000  0.052330
  0.050000  0.042690
  0.025000  0.030450
  0.012500  0.022400
  0.007500  0.018040
  0.005000  0.015250
  0.000000  0.003000]);

  bottom = [0.000000  0.003000
  0.005000 -0.015250
  0.007500 -0.018040
  0.012500 -0.022400
  0.025000 -0.030450
  0.050000 -0.042690
  0.075000 -0.052330
  0.100000 -0.060520
  0.150000 -0.073690
  0.200000 -0.083760
  0.250000 -0.091530
  0.300000 -0.097380
  0.350000 -0.101540
  0.400000 -0.104070
  0.450000 -0.105000
  0.500000 -0.104340
  0.550000 -0.101860
  0.600000 -0.096920
  0.650000 -0.087930
  0.700000 -0.076100
  0.750000 -0.062510
  0.800000 -0.047960
  0.850000 -0.033240
  0.900000 -0.019240
  0.950000 -0.007170
  1.000000  0.000000];
  % size(top)
  % size(bottom)
  outvec = [top,bottom];
end
%btw spans for boeing 737a/b/c/d are as follows:
%6.06340  ft for inside fuselage
%3.11370 sect1
%4.91630 sect2
%3.76917 sect3
%rest is sect4
function [outpoints] = bac737ht(inputstr)
xc = [0 .005 .0075 .0125 .025 .05 .075 .1 .15 .2 .25 .3 .35 .4 .5 .6 .7 .9 1]';
%at body center location
zua = [0 .093 .0118 .0156 .0209 .0251 .0270 .0286 .0321 .0355 .0391 .0424 .0448 .0464 .0447 .0363 .0268 .0089 .0005]';
zla = -1*[.014 .023 .026 .0306 .0387 .0489 .0564 .0619 .0697 .0753 .0796 .0827 .0846 .0854 .0822 .0694 .0537 .0177 .0005]';
%at 21% semispan
zub = [0 .0085 .0111 .0143 .0182 .0208 .0222 .0238 .0267 .0296 .0324 .0353 .0375 .0389 .0379 .0334 .0246 .0082 .0006]';
zlb = -1*[.0114 .0197 .0223 .0267 .0347 .0448 .0516 .0567 .0639 .0687 .0726 .0756 .0774 .0779 .0751 .0668 .0539 .0178 .0006]';
%at 46% semispan to end
zuc = [0 .0080 .01 .0128 .0164 .0186 .02 .0213 .0237 .0264 .0288 .0313 .0333 .0344 .0349 .0323 .0235 .0078 .001]';
zlc = -1*[.0104 .0184 .0213 .0254 .0324 .0422 .0485 .0534 .0603 .0650 .0685 .0711 .0727 .0732 .0716 .0652 .0538 .0176 .001]';
switch inputstr
    case 'a'
        zu = zua;
        zl = zla;
    case 'b'
        zu = zub;
        zl = zlb;
    case 'c'
        zu = zuc;
        zl = zlc;
end
% size(xc)
% size(zua)
top = [xc,zu];
bottom = [xc,zl];
outpoints= [top,bottom];
end
function [outpoints] = bac737vt(inputstr)
basexc = [0 .0017 .0034 .005 .0084 .0167 .0334 .0501 .0668 .1002 .1336 .1670 .2004 .2338 .2672 .2859 .6114  .6326 .6660 .6994 .7328 .7662 .7996 .8330 1]';
%foil @ 96.37% fuselage height (tail begins here)
basez = [0 .0051 .0069 .0083 .0104 .0139 .0190 .0223 .0270 .0325 .0366 .0397 .0419 .0433 .0440 .0441 .0441 .0437 .0415 .0383 .0346 .0306 .0263 .0220 .0003]';
xc = [0 .0025 .005 .0075 .01 .0125 .025 .05 .075 .1 .15 .2 .25 .3 .35 .4 .425 .45 .5 .55 .6 .65 .7 .75 1]';
%foil @ 9.76% tail height
zc1 = [0 .0067 .0092 .0109 .0124 .0136 .0184 .0253 .0311 .0358 .0428 .0480 .0515 .0539 .0551 .0554 .0554 .0554 .0552 .0532 .0496 .0449 .0393 .0329 .0004]';
%foil @ 18.55% tail height
zc2 = [0 .0066 .009 .0108 .0122 .0132 .0181 .0248 .0304 .0351 .0423 .0475 .0513 .0540 .0556 .0563 .0563 .0563 .0555 .0534 .0499 .0452 .0394 .0328 .0005]';
%foil @ 40.59% tail height
zc3 = [0 .0060 .0083 .0099 .0112 .0126 .0173 .0237 .0285 .0328 .0396 .0448 .0486 .0514 .0530 .0539 .0539 .0539 .0531 .0516 .0490 .0450 .0394 .0328 .0005]';
%foil @ 100% tail height
zc4 = [0 .0060 .0083 .0099 .0112 .0126 .0173 .0237 .0285 .0328 .0396 .0448 .0486 .0514 .0530 .0539 .0539 .0539 .0531 .0516 .0490 .0450 .0394 .0328 .0013]';
switch inputstr
    case 'a'
       xc = basexc;
       z = basez;
    case 'b'
        z = zc1;
    case 'c'
        z = zc2;
    case 'd'
        z = zc3;
    case 'e'
        z = zc4;
end
% size(xc)
% size(z)
top = [xc,z];
bottom = [xc,-z];
outpoints = [top,bottom];
end
function [outpoints] = trimte(foilpoints)
%removes last point pair of TE
%run multiple times to get a thicker TE
outpoints = foilpoints(1:end-1,:);
end

function [outpoints] = scaletc(foilpoints,scalefactor)
outpoints = [foilpoints(:,1),foilpoints(:,2)*scalefactor,foilpoints(:,3),foilpoints(:,4)*scalefactor];
end
function [outpoints] = rotateaf(foilpoints,t)
t = -t; %sign convention
r = [cosd(t) -sind(t); sind(t) cosd(t)];
xt = foilpoints(:,1)';
yt = foilpoints(:,2)';
xb = foilpoints(:,3)';
yb = foilpoints(:,4)';
t = r*[xt;yt];
b = r*[xb;yb];
outpoints = [t',b'];
end
function plotairfoil3d(foilpoints)
plot3(foilpoints)
end

function [outvec] = swtailspar(diam,x,z,length)
n = 48;
r = diam/2;
t = 0:2*pi/n:2*pi;
y = cos(t)*r;
z = sin(t)*r+z;
fid = fopen(sprintf("tubestart.txt"),"w");
    numpts = n;
    for i = 1:numpts
        fprintf(fid,"%f,%f,%f\n",x,y,z);
    end
    outvec(1,:) = fclose(fid);
    fid = fopen(sprintf("tubeend.txt"),"w");
    for i = 1:numpts
        fprintf(fid,"%f,%f,%f\n",x+length,y,z);
    end
    outvec(2,:) = fclose(fid);
end
