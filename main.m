clc;
clear;

%%�½�STK��Ŀ������ȡ����
Start_Time = '1 Jan 2023 00:00:00';
End_Time ='2 Jan 2023 00:00:00';
[app,root,sc] = New_Start('Learning_week_3',Start_Time,End_Time);

%%�½���������
%�½�һ���������ǣ�����ȡ���
sat_name='try';

PerigeeAltitude=7500;
ApogeeAltitude=7500;
Inclination=60;
ArgOfPerigee=0;
RAAN=5.68708e-17;
True_Anomaly=2.86921e-17;
Type_1='eSizeShapeRadius';
Type_2='eAscNodeRAAN';
Type_3='eLocationTrueAnomaly';

[sat,kep] = add_sat(sc,sat_name,PerigeeAltitude,ApogeeAltitude,Inclination,ArgOfPerigee,RAAN,True_Anomaly,Type_1,Type_2,Type_3);

%%�½�����վ,������Ҫ����һ����γ�ȱ���
fac = sc.Children.New('eFacility','Beijing');
fac.Position.AssignGeodetic(39.9289,116.388,0.0421151);%γ�ȣ����ȣ��߶�

%%�½�walker������ɾ����������
NumPlanes=12; %12���
NumSatsPerPlane=10;%10��
root.ExecuteCommand('Walker */Satellite/try Type Delta NumPlanes 12 NumSatsPerPlane 10 InterPlanePhaseIncrement 3 ColorByPlane Yes');
sat.Unload;

%%��ȡ�����������ǵĹ��
satItems = root.ExecuteCommand('ShowNames * Class Satellite');
satPaths = strsplit(strtrim(satItems.Item(0)),' ');
for i=1:NumPlanes*NumSatsPerPlane
    i;
    sat(i) = root.GetObjectFromPath(char(satPaths(i)));
end

%%�½�����
sat_con = sc.Children.New('eConstellation','faconstellation');
for i=1:NumPlanes*NumSatsPerPlane
    i;
    sat_con.Objects.AddObject(sat(i));
end

%%�½�����
access_chain = sc.Children.New('eChain','chain_access');
access_chain.Objects.AddObject(fac);
access_chain.Objects.AddObject(sat_con);

%%��ȡ����
ChainAccess = access_chain.DataProviders.Item('Base Object Data').Exec(sc.StartTime, sc.StopTime,3600);
Temp(:, 1) = cell2mat(ChainAccess.DataSets.GetDataSetByName('Time').GetValues) ;
Temp(:, 2) = cell2mat(ChainAccess.DataSets.GetDataSetByName('Number Of Accesses').GetValues) ;
Temp_Cell= ChainAccess.DataSets.GetDataSetByName('Access Objects').GetValues;

