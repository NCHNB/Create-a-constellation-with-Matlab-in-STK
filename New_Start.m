function [app,root,sc] = New_Start(Name,StartTime,EndTime)
%%�½�һ����Ŀ�ͳ���
%   ��STK���½���Ŀ������
app=actxserver('STK11.application');
app.Visible = 1;
root=app.Personality2;
root.NewScenario(Name);
root.CurrentScenario.SetTimePeriod(StartTime, EndTime);
root.CurrentScenario.Epoch = StartTime;
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('EpMin');%ʱ���ʽת���Ӹ�ʽ
sc = root.CurrentScenario;
end
