%ll2utm.m must be present in the same directory as HLS_extralctor.m, or in
%the search path of Matlab

clear all;
%addpath(genpath('E:\Data\HLSv1.4\playground'));

%Filename with LAT/LON coordinates of points from which HLS reflectances are extracted - set the coordinates of the points to extract
points=readtable('SERC_pixels_lat_lon.csv');

%Path to HLS directory - to data to extract from
%HLSdir=('E:\Data\HLSv1.4\');
%Year of acquisition
%year=('2018');
%tile to process
%tile=('33UVR');


[xp, yp]=size(points);

%convert Lat Lon to UTM
for i = 1:xp
 [utm1, utm2]=ll2utm(points.LATITUDE(i), points.LONGITUDE(i));
 points.utm1(i)=utm1;
 points.utm2(i)=utm2;
end

%switch to directory with HLS S30 product   D:\LCLUC_HLS\HLS_DATA\Greenbelt\HLS.GSFC.18SUJ.S30\S30\2017
%dirname={[HLSdir,'S30','\',year,'\',tile]};
cd D:\LCLUC_HLS\HLS_DATA\Greenbelt\HLS.GSFC.18SUJ.S30\S30\2019

files=dir('*.hdf');
[x_s30, y_s30]=size(files);

%matrix pre-allocation for speed purposes
doy_s30=zeros(1,x_s30);
b01_s30=zeros(xp,x_s30);
b02_s30=zeros(xp,x_s30);
b03_s30=zeros(xp,x_s30);
b04_s30=zeros(xp,x_s30);
b05_s30=zeros(xp,x_s30);
b06_s30=zeros(xp,x_s30);
b07_s30=zeros(xp,x_s30);
b08_s30=zeros(xp,x_s30);
b8a_s30=zeros(xp,x_s30);
b09_s30=zeros(xp,x_s30);
b10_s30=zeros(xp,x_s30);
b11_s30=zeros(xp,x_s30);
b12_s30=zeros(xp,x_s30);
qa_s30=zeros(xp,x_s30);

%loop for all HLS files
for i = 1:x_s30   %remove ':10' to run for all
%parse DOY from HLS filename
doy_s30(1,i)=str2double(files(i).name(20:22));

%define MapCellsReference from HLS HDF metadata
reference=maprefcells;
info=hdfinfo(files(i).name);
reference.CellExtentInWorldX=30;
reference.CellExtentInWorldY=30;
reference.XWorldLimits=[(info.Attributes(14).Value) 30*(str2double(info.Attributes(11).Value))+(info.Attributes(14).Value)];
reference.YWorldLimits=[(info.Attributes(15).Value)-30*(str2double(info.Attributes(12).Value)) (info.Attributes(15).Value)];
reference.RasterSize=[str2double(info.Attributes(11).Value) str2double(info.Attributes(12).Value)];
reference.ColumnsStartFrom='north';
reference.RowsStartFrom='west';

%read individual bands into separate matrices
B01=hdfread(files(i).name,'/Grid/Data Fields/B01');
B02=hdfread(files(i).name,'/Grid/Data Fields/B02');
B03=hdfread(files(i).name,'/Grid/Data Fields/B03');
B04=hdfread(files(i).name,'/Grid/Data Fields/B04');
B05=hdfread(files(i).name,'/Grid/Data Fields/B05');
B06=hdfread(files(i).name,'/Grid/Data Fields/B06');
B07=hdfread(files(i).name,'/Grid/Data Fields/B07');
B08=hdfread(files(i).name,'/Grid/Data Fields/B08');
B8A=hdfread(files(i).name,'/Grid/Data Fields/B8A');
B09=hdfread(files(i).name,'/Grid/Data Fields/B09');
B10=hdfread(files(i).name,'/Grid/Data Fields/B10');
B11=hdfread(files(i).name,'/Grid/Data Fields/B11');
B12=hdfread(files(i).name,'/Grid/Data Fields/B12');
QA=hdfread(files(i).name,'/Grid/Data Fields/QA');

%loop through points
for j = 1:xp
    %query matrix location of UTM coordinates
    [c1, c2]=worldToDiscrete(reference,points.utm1(j),points.utm2(j));
    if isnan(c1)==1 %outside image - skip
        b01_s30(j,i)=0;
        b02_s30(j,i)=0;
        b03_s30(j,i)=0;
        b04_s30(j,i)=0;
        b05_s30(j,i)=0;
        b06_s30(j,i)=0;
        b07_s30(j,i)=0;
        b08_s30(j,i)=0;
        b8a_s30(j,i)=0;
        b09_s30(j,i)=0;
        b10_s30(j,i)=0;
        b11_s30(j,i)=0;
        b12_s30(j,i)=0;
        qa_s30(j,i)=255;
    else %in image - extract info for given point (x axis) and DOY (y axis)
        b01_s30(j,i)=B01(c1,c2);
        b02_s30(j,i)=B02(c1,c2);
        b03_s30(j,i)=B03(c1,c2);
        b04_s30(j,i)=B04(c1,c2);
        b05_s30(j,i)=B05(c1,c2);
        b06_s30(j,i)=B06(c1,c2);
        b07_s30(j,i)=B07(c1,c2);
        b08_s30(j,i)=B08(c1,c2);
        b8a_s30(j,i)=B8A(c1,c2);
        b09_s30(j,i)=B09(c1,c2);
        b10_s30(j,i)=B10(c1,c2);
        b11_s30(j,i)=B11(c1,c2);
        b12_s30(j,i)=B12(c1,c2);
        qa_s30(j,i)=QA(c1,c2);
    end
end
end

%query L30 data               D:\LCLUC_HLS\HLS_DATA\Greenbelt\HLS.GSFC.18SUJ.L30\L30\2017
%dirname={[HLSdir,'L30','\',year,'\',tile]};
%cd(char(dirname));
cd D:\LCLUC_HLS\HLS_DATA\Greenbelt\HLS.GSFC.18SUJ.L30\L30\2019

files=dir('*.hdf');
[x_l30, y_l30]=size(files);

%matrix pre-allocation for speed purposes
doy_l30=zeros(1,x_l30);
b01_l30=zeros(xp,x_l30);
b02_l30=zeros(xp,x_l30);
b03_l30=zeros(xp,x_l30);
b04_l30=zeros(xp,x_l30);
b05_l30=zeros(xp,x_l30);
b06_l30=zeros(xp,x_l30);
b07_l30=zeros(xp,x_l30);
b09_l30=zeros(xp,x_l30);
b10_l30=zeros(xp,x_l30);
b11_l30=zeros(xp,x_l30);
qa_l30=zeros(xp,x_l30);

%loop for all HLS files
for i = 1:x_l30   %remove ':10' to run for all
%parse DOY from HLS filename
doy_l30(1,i)=str2double(files(i).name(20:22));

%loc=find(doy_s30(1,:)==doy_l30(1,i));
%[locx, locy]=size(loc);
%if locy==1
reference=maprefcells;
info=hdfinfo(files(i).name);
reference.CellExtentInWorldX=30;
reference.CellExtentInWorldY=30;
reference.XWorldLimits=[(double(info.Attributes(11).Value)) 30*(double(info.Attributes(9).Value))+(double(info.Attributes(11).Value))];
reference.YWorldLimits=[(double(info.Attributes(12).Value))-30*(double(info.Attributes(10).Value)) (double(info.Attributes(12).Value))];
reference.RasterSize=[double(info.Attributes(9).Value) double(info.Attributes(10).Value)];
reference.ColumnsStartFrom='north';
reference.RowsStartFrom='west';

%read individual bands into separate matrices
B01=hdfread(files(i).name,'/Grid/Data Fields/band01');
B02=hdfread(files(i).name,'/Grid/Data Fields/band02');
B03=hdfread(files(i).name,'/Grid/Data Fields/band03');
B04=hdfread(files(i).name,'/Grid/Data Fields/band04');
B05=hdfread(files(i).name,'/Grid/Data Fields/band05');
B06=hdfread(files(i).name,'/Grid/Data Fields/band06');
B07=hdfread(files(i).name,'/Grid/Data Fields/band07');
B09=hdfread(files(i).name,'/Grid/Data Fields/band09');
B10=hdfread(files(i).name,'/Grid/Data Fields/band10');
B11=hdfread(files(i).name,'/Grid/Data Fields/band11');
QA=hdfread(files(i).name,'/Grid/Data Fields/QA');

%loop through points
for j = 1:xp
    %query matrix location of UTM coordinates
    [c1, c2]=worldToDiscrete(reference,points.utm1(j),points.utm2(j));
    if isnan(c1)==1 %outside image - skip
            b01_l30(j,i)=0;
            b02_l30(j,i)=0;
            b03_l30(j,i)=0;
            b04_l30(j,i)=0;
            b05_l30(j,i)=0;
            b06_l30(j,i)=0;
            b07_l30(j,i)=0;
            b09_l30(j,i)=0;
            b10_l30(j,i)=0;
            b11_l30(j,i)=0;
            qa_l30(j,i)=255;
            
    else %in image - extract info for given point (x axis) and DOY (y axis)
            b01_l30(j,i)=B01(c1,c2);
            b02_l30(j,i)=B02(c1,c2);
            b03_l30(j,i)=B03(c1,c2);
            b04_l30(j,i)=B04(c1,c2);
            b05_l30(j,i)=B05(c1,c2);
            b06_l30(j,i)=B06(c1,c2);
            b07_l30(j,i)=B07(c1,c2);
            b09_l30(j,i)=B09(c1,c2);
            b10_l30(j,i)=B10(c1,c2);
            b11_l30(j,i)=B11(c1,c2);
            qa_l30(j,i)=QA(c1,c2);
    end
end
end

for i = 1:xp
    for j = 1:x_l30
        if qa_l30(i,j)<0
            cirrus_l30(i,j)=0;
            cloud_l30(i,j)=0;    % USED
            adjcloud_l30(i,j)=0;
            cloudshadow_l30(i,j)=0;
            snow_l30(i,j)=0;
            water_l30(i,j)=0;
            aq_l30(i,j)=0;
        else
            code=dec2bin(qa_l30(i,j),8);
            cirrus_l30(i,j)=1-str2num(code(8));
            cloud_l30(i,j)=1-str2num(code(7));
            adjcloud_l30(i,j)=1-str2num(code(6));
            cloudshadow_l30(i,j)=1-str2num(code(5));
            snow_l30(i,j)=1-str2num(code(4));
            water_l30(i,j)=1-str2num(code(3));
            aq_l30(i,j)=bin2dec(code(1:2));
        end
    end
end


for i = 1:xp
    for j = 1:x_s30
        if qa_s30(i,j)<0
            cirrus_s30(i,j)=0;
            cloud_s30(i,j)=0;           %used in final_back
            adjcloud_s30(i,j)=0;
            cloudshadow_s30(i,j)=0;     %TBD
            snow_s30(i,j)=0;            %TBD
            water_s30(i,j)=0;           %TBD
            aq_s30(i,j)=0;
        else
            code=dec2bin(qa_s30(i,j),8);
            cirrus_s30(i,j)=1-str2double(code(8));
            cloud_s30(i,j)=1-str2double(code(7));
            adjcloud_s30(i,j)=1-str2double(code(6));
            cloudshadow_s30(i,j)=1-str2double(code(5));
            snow_s30(i,j)=1-str2double(code(4));
            water_s30(i,j)=1-str2double(code(3));
            aq_s30(i,j)=bin2dec(code(1:2));
        end
    end
end

%select output directory
cd D:\LCLUC_HLS\HLS_DATA\SERC\2019\

%cloud_s30=ones(xp,x_s30); %Turn off the cloud mask for S30
%cloud_l30=ones(xp,x_l30); %Turn off the cloud mask for L30

%Remove all DOY with zero cloud-free pixels; number of pixels good to ceep
%DOY
cloud_s30_sum=sum(cloud_s30);
cloud_s30_mask=find(cloud_s30_sum>0);  % if you have 3 good pixels set to > 2
cloud_l30_sum=sum(cloud_l30);
cloud_l30_mask=find(cloud_l30_sum>0);    % if you have 3 good pixels set to > 2

%Apply cloud mask on S30 reflectances - cloudy pixel is zero; 
% S30 reflectances ./ by 10000
b01_s30_masked=(b01_s30./10000).*cloud_s30;  % IF YOU MULTIPLY BY SHADOW IT WILL AD IT TO THE MASK
b02_s30_masked=(b02_s30./10000).*cloud_s30;
b03_s30_masked=(b03_s30./10000).*cloud_s30;
b04_s30_masked=(b04_s30./10000).*cloud_s30;
b05_s30_masked=(b05_s30./10000).*cloud_s30;
b06_s30_masked=(b06_s30./10000).*cloud_s30;
b07_s30_masked=(b07_s30./10000).*cloud_s30;
b08_s30_masked=(b08_s30./10000).*cloud_s30;
b8a_s30_masked=(b8a_s30./10000).*cloud_s30;
b09_s30_masked=(b09_s30./10000).*cloud_s30;
b10_s30_masked=(b10_s30./10000).*cloud_s30;
b11_s30_masked=(b11_s30./10000).*cloud_s30;
b12_s30_masked=(b12_s30./10000).*cloud_s30;

%Apply cloud mask on L30 reflectances - cloudy pixel is zero
b01_l30_masked=(b01_l30./10000).*cloud_l30;
b02_l30_masked=(b02_l30./10000).*cloud_l30;
b03_l30_masked=(b03_l30./10000).*cloud_l30;
b04_l30_masked=(b04_l30./10000).*cloud_l30;
b05_l30_masked=(b05_l30./10000).*cloud_l30;
b06_l30_masked=(b06_l30./10000).*cloud_l30;
b07_l30_masked=(b07_l30./10000).*cloud_l30;
b09_l30_masked=(b09_l30./10000).*cloud_l30;
b10_l30_masked=(b10_l30./10000).*cloud_l30;
b11_l30_masked=(b11_l30./10000).*cloud_l30;


%Write masked and scaled 0-1 reflectances to Excel file, each band in separate sheet S30
%product
xlswrite('S30_s.xls',doy_s30(:,cloud_s30_mask),'doy');
xlswrite('S30_s.xls',b01_s30_masked(:,cloud_s30_mask),'b01');
xlswrite('S30_s.xls',b02_s30_masked(:,cloud_s30_mask),'b02');
xlswrite('S30_s.xls',b03_s30_masked(:,cloud_s30_mask),'b03');
xlswrite('S30_s.xls',b04_s30_masked(:,cloud_s30_mask),'b04');
xlswrite('S30_s.xls',b05_s30_masked(:,cloud_s30_mask),'b05');
xlswrite('S30_s.xls',b06_s30_masked(:,cloud_s30_mask),'b06');
xlswrite('S30_s.xls',b07_s30_masked(:,cloud_s30_mask),'b07');
xlswrite('S30_s.xls',b08_s30_masked(:,cloud_s30_mask),'b08');
xlswrite('S30_s.xls',b8a_s30_masked(:,cloud_s30_mask),'b8a');
xlswrite('S30_s.xls',b09_s30_masked(:,cloud_s30_mask),'b09');
xlswrite('S30_s.xls',b10_s30_masked(:,cloud_s30_mask),'b10');
xlswrite('S30_s.xls',b11_s30_masked(:,cloud_s30_mask),'b11');
xlswrite('S30_s.xls',b12_s30_masked(:,cloud_s30_mask),'b12');
xlswrite('S30_s.xls',qa_s30(:,cloud_s30_mask),'QA');

%Write masked and scaled 0-1 reflectances to Excel file, each band in separate sheet L30
%product
xlswrite('L30_s.xls',doy_l30(:,cloud_l30_mask),'doy');
xlswrite('L30_s.xls',b01_l30_masked(:,cloud_l30_mask),'b01');
xlswrite('L30_s.xls',b02_l30_masked(:,cloud_l30_mask),'b02');
xlswrite('L30_s.xls',b03_l30_masked(:,cloud_l30_mask),'b03');
xlswrite('L30_s.xls',b04_l30_masked(:,cloud_l30_mask),'b04');
xlswrite('L30_s.xls',b05_l30_masked(:,cloud_l30_mask),'b05');
xlswrite('L30_s.xls',b06_l30_masked(:,cloud_l30_mask),'b06');
xlswrite('L30_s.xls',b07_l30_masked(:,cloud_l30_mask),'b07');
xlswrite('L30_s.xls',b09_l30_masked(:,cloud_l30_mask),'b09');
xlswrite('L30_s.xls',b10_l30_masked(:,cloud_l30_mask),'b10');
xlswrite('L30_s.xls',b11_l30_masked(:,cloud_l30_mask),'b11');
xlswrite('L30_s.xls',qa_l30(:,cloud_l30_mask),'QA');

% Scale S30 reflectances ./ by 10000

b01_s30_s=(b01_s30./10000);  
b02_s30_s=(b02_s30./10000);
b03_s30_s=(b03_s30./10000);
b04_s30_s=(b04_s30./10000);
b05_s30_s=(b05_s30./10000);
b06_s30_s=(b06_s30./10000);
b07_s30_s=(b07_s30./10000);
b08_s30_s=(b08_s30./10000);
b8a_s30_s=(b8a_s30./10000);
b09_s30_s=(b09_s30./10000);
b10_s30_s=(b10_s30./10000);
b11_s30_s=(b11_s30./10000);
b12_s30_s=(b12_s30./10000);

%Calculate S30 product VIs
%Common S30 and L30 VIs
SR_S30=b8a_s30_s./b04_s30_s;
NDVI_S30=(b8a_s30_s-b04_s30_s)./(b8a_s30_s+b04_s30_s);
SAVI_S30=(1+0.5).*(b8a_s30_s-b04_s30_s)./((b8a_s30_s+b04_s30_s+0.5)); 
MSAVI_S30=0.5.*(2*b8a_s30_s+1-sqrt((2*b8a_s30_s+1).^2-8.*(b8a_s30_s-b04_s30_s)));
OSAVI_S30=(1+0.16).*(b8a_s30_s-b04_s30_s)./(b8a_s30_s+b04_s30_s+0.16);
EVI_S30=2.5.*(b8a_s30_s-b04_s30_s)./(b8a_s30_s+6*b04_s30_s-7.5*b02_s30_s+1);
TVI_S30=0.5.*(120.*(b8a_s30_s-b03_s30_s)-200.*(b04_s30_s-b03_s30_s));
MTVI1_S30=1.2*(1.2*(b8a_s30_s-b03_s30_s)-2.5*(b04_s30_s-b03_s30_s));
MTVI2_S30=1.5*((1.2*(b8a_s30_s-b03_s30_s)-2.5.*(b04_s30_s-b03_s30_s))./sqrt((2*b8a_s30_s+1).^2-(6.*b8a_s30_s-5*sqrt(b04_s30_s))-0.5));
CVI_S30=((b8a_s30_s).*(b04_s30_s))./((b03_s30_s).^2);
GNDVI_S30=(b8a_s30_s-b03_s30_s)./(b8a_s30_s+b03_s30_s);
CIG_S30=(b8a_s30_s./b04_s30_s)-1;
NGRDI_S30=(b03_s30_s-b04_s30_s)./(b03_s30_s+b04_s30_s);
GLI_S30=(2*b03_s30_s-b04_s30_s-b02_s30_s)./(2*b03_s30_s+b04_s30_s+b02_s30_s);
VARI_S30=(b03_s30_s-b04_s30_s)./(b03_s30_s+b04_s30_s-b02_s30_s);
FCVI_S30=(b8a_s30_s-(b02_s30_s+b03_s30_s+b04_s30_s)./3);
FCVI_VIS_S30=(b8a_s30_s-(b02_s30_s+b03_s30_s+b04_s30_s)./3)./((b02_s30_s+b03_s30_s+b04_s30_s)./3);

%S30 VIs ONLY (use of RedEdge bands; RE1 705, RE2 740, RE 783)
NDREI_S30=(b8a_s30_s-b06_s30_s)./(b8a_s30_s+b06_s30_s);
CIRE_S30=(b8a_s30_s./b06_s30_s)-1;
MTCI_S30=(b06_s30_s-b05_s30_s)./(b05_s30_s-b04_s30_s);
MCARI_S30=((b05_s30_s-b04_s30_s)-0.2.*(b05_s30_s-b03_s30_s))./((b06_s30_s)./(b04_s30_s));
TCARI_S30=3*(((b05_s30_s-b04_s30_s)-0.2*(b05_s30_s-b03_s30_s))./(b05_s30_s./b04_s30_s));
TCI_S30=1.2*(b05_s30_s-b03_s30_s)-1.5.*(b04_s30_s-b03_s30_s).*sqrt(b05_s30_s./b04_s30_s);
TCARI_OSAVI_S30=TCARI_S30./OSAVI_S30;
MCARI_MTVI2_S30=MCARI_S30./MTVI2_S30;
TGI_S30=((b04_s30_s-(b02_s30_s).*(b04_s30_s-b03_s30_s))-(b04_s30_s-(b03_s30_s).*(b04_s30_s-b02_s30_s))).*(-0.5);
NDVI705_S30=(b8a_s30_s-b05_s30_s)./(b8a_s30_s+b05_s30_s);
NDVI740_S30=(b8a_s30_s-b06_s30_s)./(b8a_s30_s+b06_s30_s);
CI705_S30=(b8a_s30_s./b05_s30_s)-1;
CI740_S30=(b8a_s30_s./b06_s30_s)-1;
%EXTRA VIS
CCCI_S30=((b8a_s30_s-b06_s30_s)./(b8a_s30_s+b06_s30_s))./((b8a_s30_s-b04_s30_s)./(b8a_s30_s+b04_s30_s));
RE1RE2_S30=(b06_s30_s./b05_s30_s)-1;
REIP3_S30=705+35.*(((((b04_s30_s+b8a_s30_s)./2)-b05_s30_s))./(b06_s30_s-b05_s30_s));

%Apply cloud mask to S30 VIs - cloudy pixel is zero
SR_S30_masked=SR_S30.*cloud_s30;
NDVI_S30_masked=NDVI_S30.*cloud_s30;
SAVI_S30_masked=SAVI_S30.*cloud_s30;
MSAVI_S30_masked=MSAVI_S30.*cloud_s30;
OSAVI_S30_masked=OSAVI_S30.*cloud_s30;
EVI_S30_masked=EVI_S30.*cloud_s30;
TVI_S30_masked=TVI_S30.*cloud_s30;
MTVI1_S30_masked=MTVI1_S30.*cloud_s30;
MTVI2_S30_masked=MTVI2_S30.*cloud_s30;
CVI_S30_masked=CVI_S30.*cloud_s30;
GNDVI_S30_masked=GNDVI_S30.*cloud_s30;
CIG_S30_masked=CIG_S30.*cloud_s30;
NGRDI_S30_masked=NGRDI_S30.*cloud_s30;
GLI_S30_masked=GLI_S30.*cloud_s30;
VARI_S30_masked=VARI_S30.*cloud_s30;
NDREI_S30_masked=NDREI_S30.*cloud_s30;
CIRE_S30_masked=CIRE_S30.*cloud_s30;
MTCI_S30_masked=MTCI_S30.*cloud_s30;
MCARI_S30_masked=MCARI_S30.*cloud_s30;
TCARI_S30_masked=TCARI_S30.*cloud_s30;
TCI_S30_masked=TCI_S30.*cloud_s30;
TCARI_OSAVI_S30_masked=TCARI_OSAVI_S30.*cloud_s30;
MCARI_MTVI2_S30_masked=MCARI_MTVI2_S30.*cloud_s30;
TGI_S30_masked=TGI_S30.*cloud_s30;
NDVI705_S30_masked=NDVI705_S30.*cloud_s30;
NDVI740_S30_masked=NDVI740_S30.*cloud_s30;
CI705_S30_masked=CI705_S30.*cloud_s30;
CI740_S30_masked=CI740_S30.*cloud_s30;
CCCI_S30_masked=CCCI_S30.*cloud_s30;
RE1RE2_S30_masked=RE1RE2_S30.*cloud_s30;
REIP3_S30_masked=REIP3_S30.*cloud_s30;
FCVI_S30_masked=FCVI_S30.*cloud_s30;
FCVI_VIS_S30_masked=FCVI_VIS_S30.*cloud_s30;

% Scale L30 reflectances ./ by 10000
b01_l30_s=(b01_l30./10000);
b02_l30_s=(b02_l30./10000);
b03_l30_s=(b03_l30./10000);
b04_l30_s=(b04_l30./10000);
b05_l30_s=(b05_l30./10000);
b06_l30_s=(b06_l30./10000);
b07_l30_s=(b07_l30./10000);
b09_l30_s=(b09_l30./10000);
b10_l30_s=(b10_l30./10000);
b11_l30_s=(b11_l30./10000);

%Calculate L30 product VIs
%Common S30 and L30 VIs
SR_L30=b05_l30_s./b04_l30_s;
NDVI_L30=(b05_l30_s-b04_l30_s)./(b05_l30_s+b04_l30_s);
SAVI_L30=(1+0.5).*(b05_l30_s-b04_l30_s)./((b05_l30_s+b04_l30_s+0.5)); 
MSAVI_L30=0.5.*(2.*b05_l30_s+1-sqrt((2.*b05_l30_s+1).^2-8.*(b05_l30_s-b04_l30_s)));
OSAVI_L30=(1+0.16).*(b05_l30_s-b04_l30_s)./(b05_l30_s+b04_l30_s+0.16);
EVI_L30=2.5.*(b05_l30_s-b04_l30_s)./(b05_l30_s+6.*(b04_l30_s)-7.5.*(b02_l30_s)+1);
TVI_L30=0.5.*(120.*(b05_l30_s-b03_l30_s)-200.*(b04_l30_s-b03_l30_s));
MTVI1_L30=1.2*(1.2*(b05_l30_s-b03_l30_s)-2.5*(b04_l30_s-b03_l30_s));
MTVI2_L30=1.5*((1.2*(b05_l30_s-b03_l30_s)-2.5.*(b04_l30_s-b03_l30_s))./sqrt((2*b05_l30_s+1).^2-(6.*b05_l30_s-5*sqrt(b04_l30_s))-0.5));
CVI_L30=(b05_l30_s).*((b04_l30_s)./((b03_l30_s).^2));
GNDVI_L30=(b05_l30_s-b03_l30_s)./(b05_l30_s+b03_l30_s);
CIG_L30=((b05_l30_s)./(b04_l30_s))-1;
NGRDI_L30=(b03_l30_s-b04_l30_s)./(b03_l30_s+b04_l30_s);
GLI_L30=(2.*(b03_l30_s)-(b04_l30_s+b02_l30_s))./(2.*(b03_l30_s)+b04_l30_s+b02_l30_s);
VARI_L30=(b03_l30_s-b04_l30_s)./(b03_l30_s+b04_l30_s-b02_l30_s);
FCVI_L30=(b05_l30_s-(b02_l30_s+b03_l30_s+b04_l30_s)./3);
FCVI_VIS_L30=(b05_l30_s-(b02_l30_s+b03_l30_s+b04_l30_s)./3)./((b02_l30_s+b03_l30_s+b04_l30_s)./3);

%Apply cloud mask on L30 VIs - cloudy pixel is zero
SR_L30_masked=SR_L30.*cloud_l30;
NDVI_L30_masked=NDVI_L30.*cloud_l30;
SAVI_L30_masked=SAVI_L30.*cloud_l30;
MSAVI_L30_masked=MSAVI_L30.*cloud_l30;
OSAVI_L30_masked=OSAVI_L30.*cloud_l30;
EVI_L30_masked=EVI_L30.*cloud_l30;
TVI_L30_masked=TVI_L30.*cloud_l30;
MTVI1_L30_masked=MTVI1_L30.*cloud_l30;
MTVI2_L30_masked=MTVI2_L30.*cloud_l30;
CVI_L30_masked=CVI_L30.*cloud_l30;
GNDVI_L30_masked=GNDVI_L30.*cloud_l30;
CIG_L30_masked=CIG_L30.*cloud_l30;
NGRDI_L30_masked=NGRDI_L30.*cloud_l30;
GLI_L30_masked=GLI_L30.*cloud_l30;
VARI_L30_masked=VARI_L30.*cloud_l30;
FCVI_L30_masked=FCVI_L30.*cloud_l30;
FCVI_VIS_L30_masked=FCVI_VIS_L30.*cloud_l30;

%Write masked VIs to Excel file, each VI in separate sheet S30
%product
xlswrite('S30_VI.xls',doy_s30(:,cloud_s30_mask),'DOY');
xlswrite('S30_VI.xls',SR_S30_masked(:,cloud_s30_mask),'SR');
xlswrite('S30_VI.xls',NDVI_S30_masked(:,cloud_s30_mask),'NDVI');
xlswrite('S30_VI.xls',SAVI_S30_masked(:,cloud_s30_mask),'SAVI');
xlswrite('S30_VI.xls',MSAVI_S30_masked(:,cloud_s30_mask),'MSAVI');
xlswrite('S30_VI.xls',OSAVI_S30_masked(:,cloud_s30_mask),'OSAVI');
xlswrite('S30_VI.xls',EVI_S30_masked(:,cloud_s30_mask),'EVI');
xlswrite('S30_VI.xls',TVI_S30_masked(:,cloud_s30_mask),'TVI');
xlswrite('S30_VI.xls',MTVI1_S30_masked(:,cloud_s30_mask),'MTVI1');
xlswrite('S30_VI.xls',MTVI2_S30_masked(:,cloud_s30_mask),'MTVI2');
xlswrite('S30_VI.xls',CVI_S30_masked(:,cloud_s30_mask),'CVI');
xlswrite('S30_VI.xls',GNDVI_S30_masked(:,cloud_s30_mask),'GNDVI');
xlswrite('S30_VI.xls',CIG_S30_masked(:,cloud_s30_mask),'CIG');
xlswrite('S30_VI.xls',NGRDI_S30_masked(:,cloud_s30_mask),'NGRDI');
xlswrite('S30_VI.xls',GLI_S30_masked(:,cloud_s30_mask),'GLI');
xlswrite('S30_VI.xls',VARI_S30_masked(:,cloud_s30_mask),'VARI');
xlswrite('S30_VI.xls',NDREI_S30_masked(:,cloud_s30_mask),'NDREI');
xlswrite('S30_VI.xls',CIRE_S30_masked(:,cloud_s30_mask),'CIRE');
xlswrite('S30_VI.xls',MTCI_S30_masked(:,cloud_s30_mask),'CIRE');
xlswrite('S30_VI.xls',MCARI_S30_masked(:,cloud_s30_mask),'MCARI');
xlswrite('S30_VI.xls',TCARI_S30_masked(:,cloud_s30_mask),'TCARI');
xlswrite('S30_VI.xls',TCI_S30_masked(:,cloud_s30_mask),'TCI');
xlswrite('S30_VI.xls',TCARI_OSAVI_S30_masked(:,cloud_s30_mask),'TCARI_OSAVI');
xlswrite('S30_VI.xls',MCARI_MTVI2_S30_masked(:,cloud_s30_mask),'MCARI_MTVI2');
xlswrite('S30_VI.xls',TGI_S30_masked(:,cloud_s30_mask),'TGI');
xlswrite('S30_VI.xls',NDVI705_S30_masked(:,cloud_s30_mask),'NDVI705');
xlswrite('S30_VI.xls',NDVI740_S30_masked(:,cloud_s30_mask),'NDVI740');
xlswrite('S30_VI.xls',CI705_S30_masked(:,cloud_s30_mask),'CI705');
xlswrite('S30_VI.xls',CI740_S30_masked(:,cloud_s30_mask),'CI740');
xlswrite('S30_VI.xls',CCCI_S30_masked(:,cloud_s30_mask),'CCCI');
xlswrite('S30_VI.xls',RE1RE2_S30_masked(:,cloud_s30_mask),'RE1RE2');
xlswrite('S30_VI.xls',REIP3_S30_masked(:,cloud_s30_mask),'REIP3');
xlswrite('S30_VI.xls',FCVI_S30_masked(:,cloud_s30_mask),'FCVI');
xlswrite('S30_VI.xls',FCVI_VIS_S30_masked(:,cloud_s30_mask),'FCVI_VIS');


%Write masked VIs to Excel file, each VI in separate sheet L30
%product
xlswrite('L30_VI.xls',doy_l30(:,cloud_l30_mask),'DOY');
xlswrite('L30_VI.xls',SR_L30_masked(:,cloud_l30_mask),'SR');
xlswrite('L30_VI.xls',NDVI_L30_masked(:,cloud_l30_mask),'NDVI');
xlswrite('L30_VI.xls',SAVI_L30_masked(:,cloud_l30_mask),'SAVI');
xlswrite('L30_VI.xls',MSAVI_L30_masked(:,cloud_l30_mask),'MSAVI');
xlswrite('L30_VI.xls',OSAVI_L30_masked(:,cloud_l30_mask),'OSAVI');
xlswrite('L30_VI.xls',EVI_L30_masked(:,cloud_l30_mask),'EVI');
xlswrite('L30_VI.xls',TVI_L30_masked(:,cloud_l30_mask),'TVI');
xlswrite('L30_VI.xls',MTVI1_L30_masked(:,cloud_l30_mask),'MTVI1');
xlswrite('L30_VI.xls',MTVI2_L30_masked(:,cloud_l30_mask),'MTVI2');
xlswrite('L30_VI.xls',CVI_L30_masked(:,cloud_l30_mask),'CVI');
xlswrite('L30_VI.xls',GNDVI_L30_masked(:,cloud_l30_mask),'GNDVI');
xlswrite('L30_VI.xls',CIG_L30_masked(:,cloud_l30_mask),'CIG');
xlswrite('L30_VI.xls',NGRDI_L30_masked(:,cloud_l30_mask),'NGRDI');
xlswrite('L30_VI.xls',GLI_L30_masked(:,cloud_l30_mask),'GLI');
xlswrite('L30_VI.xls',VARI_L30_masked(:,cloud_l30_mask),'VARI');
xlswrite('L30_VI.xls',FCVI_L30_masked(:,cloud_l30_mask),'FCVI');
xlswrite('L30_VI.xls',FCVI_VIS_L30_masked(:,cloud_l30_mask),'FCVI_VIS');