function [app,root,sc] = New_Start(Name,StartTime,EndTime)
%%新建一个项目和场景
%   打开STK，新建项目及场景
app=actxserver('STK11.application');
app.Visible = 1;
root=app.Personality2;
root.NewScenario(Name);
root.CurrentScenario.SetTimePeriod(StartTime, EndTime);
root.CurrentScenario.Epoch = StartTime;
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('EpMin');%时间格式转分钟格式
root.ExecuteCommand('Animate * Reset');% 设定动画时间回到起始点，这里用的是Connect命令
sc = root.CurrentScenario;
end

