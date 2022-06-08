flink_dir="/usr/local/bigdata/flink-1.12.5/bin/flink"
application_class="com.hzw.fdc.application.online.MainFabWindowApplication"
application_name="MainFabWindowApplication"
#监控指定metricsname
metricsjobname="metrics.reporter.promgateway.jobName="
#监控指定latency设定10s
latency="metrics.latency.interval=10000"


project_path=$(
  cd $(dirname $0)
  pwd
)

jar_num=$(
  cd $(dirname $0)
  ls ../MainFabFlinkJob*.jar | wc -w
)
jar_list=$(
  cd $(dirname $0)
  ls ../MainFabFlinkJob*.jar
)

# ========  获取最近成功的checkpoint =========================
source $project_path/get_checkpoint_dir.sh

checkpoint_dirs=$checkpoint_dirs


if [ $jar_num -eq "1" ]; then

  echo "load $jar_list ..."
  echo "Start $application_name ..."
  jar="$project_path/$jar_list"
  log="$project_path/log/$application_name.log"
  config_path="$project_path/../MainFabFlinkJob.properties"

  if [ -z "$checkpoint_dirs" ] 
  then
      echo "monitor checkpoint_dirs is empty" >> $log
      nohup $flink_dir run -yD $metricsjobname$application_name -yD $latency -c $application_class -m yarn-cluster -p 4 -yjm 2048m  -ytm 4096m -ynm $application_name -ys 2  -yqu q4rt $jar -config_path $config_path  >> $log  2>&1 &
  else
      echo "monitor checkpoint_dirs is NOT empty" >> $log
      nohup $flink_dir run -yD $metricsjobname$application_name -yD $latency -c $application_class -s $checkpoint_dirs -m yarn-cluster -p 4 -yjm 4096m -ytm 4096m -ynm $application_name -ys 2  -yqu q4rt $jar -config_path $config_path  >> $log  2>&1 &
  fi

elif

  [ $jar_num -eq "0" ]
then
  echo "没找到MainFabFlinkJob jar 包"
elif [ $jar_num -gt "1" ]; then
  echo "有多个MainFabFlinkJob jar 包,请保留一个 :"
  echo "$jar_list"
fi

