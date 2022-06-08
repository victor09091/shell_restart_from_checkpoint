#/bin/bash

#==================================================
#purpose: flink&spark任务运行监控,每2分钟检查一次本地进程和yarn任务进程
#==================================================

#param1 $1:grep yarn 任务进程 MainFabWindowApplication

job_name="MainFabWindowApplication"
restart_shell="start_from_checkpoint.sh"

processdt=`date "+%Y-%m-%d %H:%M:%S"`

yarn_count=`yarn application -list|grep  $job_name | wc -l`
if [ ${yarn_count} == 0 ]; then

  #======重启服务
  echo "$processdt $job_name Stop running the service and start to restart!!!"
  sh $restart_shell

  #重启需要时间,暂停两分钟
  sleep 1m
  
  #检查是否重启成功
  count=`ps -ef | grep $job_name | grep -v grep|wc -l`
  if [ ${count} == 1 ]; then
     echo "$processdt $job_name 已经重启 " 
  else
     echo "$processdt $job_name 重启失败..." 
  fi
else
  echo "$processdt $job_name is running" 
fi

##==============获取最新的jobID 写入JobID.conf文件=================
JobID=`tail -n500 log/${job_name}.log  | grep JobID |  awk 'END {print $7}'`
cat>./JobID.conf <<END
${job_name}_JobID=$JobID 
END


 


