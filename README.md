# shell_restart_from_checkpoint
shell脚本 flink 挂掉后从checkpoint 自动重启


MainFabWindowApplication.tar 是样例， 可以直接使用


定时任务: 

####=====FlinkJob 定时任务
#*/1 * * * * cd /home/hadoop/mainFabFlinkJob/MainFabWindowApplication; sh monitor.sh >> ./log/monitor.log & > /dev/null 2>&1
