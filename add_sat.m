function [sat,kep] = add_sat(sc,sat_name,Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Type_1,Type_2,Type_3)
%新建一颗卫星，并设置其轨道六根数

%新建一颗卫星，并获取轨道句柄
sat=sc.Children.New('eSatellite',sat_name);
sat_pro=sat.Propagator;

%将卫星轨道参数转换为开普勒六根数形式
kep=sat_pro.InitialState.Representation.ConvertTo('eOrbitStateClassical');

%设置轨道类型，并赋予六根数
if strcmp(Type_1, 'eSizeShapeSemi')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.Semimajor = Prm1;%半长轴
    kep.SizeShape.Eccentricity = Prm2;%离心率
elseif strcmp(Type_1, 'eSizeShapeAltitude')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.PerigeeAltitude = Prm1;%近地点高度
    kep.SizeShape.ApogeeAltitude = Prm2;%远地点高度
elseif strcmp(Type_1, 'eSizeShapeRadius')
    kep.SizeShapeType = Type_1;
    kep.SizeShape.PerigeeRadius = Prm1;%近地点半径
    kep.SizeShape.ApogeeRadius = Prm2;%远地点半径
%以下注释来自科普文章，作者：Y-Space https://www.bilibili.com/read/cv808205 出处：bilibili
%近/远地点，又称近/远拱点或PE（perigee）/AP（apogee）点，是在椭圆轨道中离地心最近/远的点。从数学角度说，椭圆中两个焦点所在直线交椭圆于两个点，离主焦点最近的是近地点，离主焦点最远的是远地点。 
%近/远地点半径即地心与近/远地点的距离，包含地球半径在内。 
%近/远地点高度通俗来说是近/远地点到对应地面的距离，不包含地球半径。如果用R'表示近/远地点半径，用R来表示地球半径（把地球任意一个过地心的剖面理想化为圆形，地球半径约为6371km，而实际上由于地球形状的不规则性，地球半径在6357km到6378km之间，了解即可），用h来表示近/远地点高度，则R'＝R＋h
%我们一般用近/远地点高度来描述轨道，常简称为“近地点XXXkm，远地点XXXkm”
elseif strcmp(Type_1, 'eSizeShapePeriod')
    kep.SizeShapeType =Type_1;
    kep.SizeShape.Period = Prm1;%卫星公转周期
    kep.SizeShape.Eccentricity = Prm2;
elseif strcmp(Type_1, 'eSizeShapeMeanMotion')
    kep.SizeShapeType =Type_1;
    kep.SizeShape.MeanMotion=Prm1;%Matlb中取deg/sec,STK输入中一般默认一天中绕地球旋转的圈数，注意单位转换
    kep.SizeShape.Eccentricity = Prm2;
end

kep.Orientation.Inclination = Prm3;%轨道倾角
kep.Orientation.ArgOfPerigee = Prm4;%近心点辐角

%RAAN 与 Lon.Ascn.Node 都是指卫星由南半球向北半球运行时穿过赤道的交点的位置，
%二者是同一个位置，只是在不同坐标系下的不同表达方式。
%RAAN是升交点赤经，是在地心惯性坐标系下，其X轴向东度量到升交点的地心张角；
%Lon.Ascn.Node是升交点经度，是在地固坐标系下，升交点对应的经度（东经为正，西经为负）。多用于GEO
if strcmp(Type_2, 'eAscNodeRAAN')
    kep.Orientation.AscNodeType = Type_2;
    kep.Orientation.AscNode.Value = Prm5;
elseif strcmp(Type_2, 'eAscNodeLAN')
    kep.Orientation.AscNodeType = Type_2;
    kep.Orientation.AscNode.Value = Prm5;
end

%https://www.bilibili.com/read/cv808205，三种角的区别；https://sat.huijiwiki.com/wiki/%E5%81%8F%E8%BF%91%E7%82%B9%E8%A7%92，对真、平区别的描述更清晰
if strcmp(Type_3, 'eLocationTrueAnomaly')%真近点角
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
elseif strcmp(Type_3, 'eLocationMeanAnomaly')%平近点角
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
elseif strcmp(Type_3, 'eLocationEccentricAnomaly')%偏近点角
    kep.LocationType = Type_3;
    kep.Location.Value = Prm6;
end

%赋值之后重置
sat_pro.InitialState.Representation.Assign(kep);
sat_pro.Propagate;
end

