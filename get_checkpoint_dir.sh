# ========  获取最近成功的checkpoint =========================
#!/bin/sh  
while read line;do
    eval "$line"
done < JobID.conf
#echo $MainFabWindowApplication_JobID
source_dir="/flink-checkpoints/$MainFabWindowApplication_JobID"
#echo  $source_dir

checkpoint_dir_list=`hadoop fs -ls "$source_dir" | grep chk |  awk ' {print $8}'`
#echo $checkpoint_dir_list
for i in $checkpoint_dir_list
do
  echo $i
  tmp_dir=`hadoop fs -ls  $i | grep _metadata`
  if [ -z "$tmp_dir" ]  
  then
     echo "is empty" 
  else
     checkpoint_dirs="hdfs://nameservice1:8020$i"
     echo "$checkpoint_dirs"
  fi
done

