function [sat,kep] = add_sat(sc,sat_name,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Type_1,Type_2,Type_3)
%�½�һ�����ǣ�����������������

%�½�һ�����ǣ�����ȡ������
sat=sc.Children.New('eSatellite',sat_name);
sat_pro=sat.Propagator;

%�����ǹ������ת��Ϊ��������������ʽ
kep=sat_pro.InitialState.Representation.ConvertTo('eOrbitStateClassical');

%���ù�����ͣ�������������
if strcmp(Type_1, 'eSizeShapeSemi')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.Semimajor = Prm1;%�볤��
    kep.SizeShape.Eccentricity = Prm2;%������
elseif strcmp(Type_1, 'eSizeShapeAltitude')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.PerigeeAltitude = Prm1;%���ص�߶�
    kep.SizeShape.ApogeeAltitude = Prm2;%Զ�ص�߶�
elseif strcmp(Type_1, 'eSizeShapeRadius')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.PerigeeRadius = Prm1;%���ص�뾶
    kep.SizeShape.ApogeeRadius = Prm2;%Զ�ص�뾶
%����ע�����Կ������£����ߣ�Y-Space https://www.bilibili.com/read/cv808205 ������bilibili
%��/Զ�ص㣬�ֳƽ�/Զ�����PE��perigee��/AP��apogee���㣬������Բ�������������/Զ�ĵ㡣����ѧ�Ƕ�˵����Բ��������������ֱ�߽���Բ�������㣬��������������ǽ��ص㣬����������Զ����Զ�ص㡣 
%��/Զ�ص�뾶���������/Զ�ص�ľ��룬��������뾶���ڡ� 
%��/Զ�ص�߶�ͨ����˵�ǽ�/Զ�ص㵽��Ӧ����ľ��룬����������뾶�������R'��ʾ��/Զ�ص�뾶����R����ʾ����뾶���ѵ�������һ�������ĵ��������뻯ΪԲ�Σ�����뾶ԼΪ6371km����ʵ�������ڵ�����״�Ĳ������ԣ�����뾶��6357km��6378km֮�䣬�˽⼴�ɣ�����h����ʾ��/Զ�ص�߶ȣ���R'��R��h
%����һ���ý�/Զ�ص�߶�����������������Ϊ�����ص�XXXkm��Զ�ص�XXXkm��
elseif strcmp(Type_1, 'eSizeShapePeriod')
    kep.SizeShapeType =Type_1;
    kep.SizeShape.Period = Prm1;%���ǹ�ת����
    kep.SizeShape.Eccentricity = Prm2;
elseif strcmp(Type1, 'eSizeShapeMean')
    kep.SizeShapeType =Type_1;
    kep.SizeShape.Mean=Prm1;%һ�����Ƶ�����ת��Ȧ��
    kep.SizeShape.Eccentricity = Prm2;
end

kep.Orientation.Inclination = Prm3;%������
kep.Orientation.ArgOfPerigee = Prm4;%���ĵ����

%RAAN �� Lon.Ascn.Node ����ָ�������ϰ����򱱰�������ʱ��������Ľ����λ�ã�
%������ͬһ��λ�ã�ֻ���ڲ�ͬ����ϵ�µĲ�ͬ���﷽ʽ��
%RAAN��������ྭ�����ڵ��Ĺ�������ϵ�£���X���򶫶�����������ĵ����Žǣ�
%Lon.Ascn.Node�������㾭�ȣ����ڵع�����ϵ�£��������Ӧ�ľ��ȣ�����Ϊ��������Ϊ������
if strcmp(Type_2, 'eAscNodeRAAN')
    kep.Orientation.AscNodeType = Type_2;
    kep.Orientation.AscNode.Value = Prm5;
elseif strcmp(Type_2, 'eAscNodeLAN')
    kep.Orientation.AscNodeType = Type_2;
    kep.Orientation.AscNode.Value = Prm5;
end

if strcmp(Type_3, 'eLocationTrueAnomaly')%������
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
elseif strcmp(Type_3, 'eLocationMeanAnomaly')%ƽ�����
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
elseif strcmp(Type_3, 'eLocationEccentricAnomaly')%ƫ�����
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
end

%��ֵ֮������
sat_pro.InitialState.Representation.Assign(kep);
sat_pro.Propagate;
end
