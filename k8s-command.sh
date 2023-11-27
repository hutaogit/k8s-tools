#!/bin/bash

#if [ -n "$1" ]
#then
#    echo "The namespace is $1"
#else
#    echo "\请输入k8s的【namespace】"
#    echo "example: sh $0 zyzl"
#    echo "通过 [kubectl get namespaces] 获取"
#    exit
#fi
namespacelist=`kubectl get namespace|grep -vE 'NAME|calico-apiserver|calico-system|default|kube-node-lease|kube-public|kube-system|moss-system|openebs|tigera-operator'|awk '{print $1}'`

z=1
echo " 当前k8s集群应用服务命名空间列表："
for space in ${namespacelist}
do
   echo   [${z}] : ${space}
   z=$(($z+1))
done

read -p " 请输入服务namespace对应的序号: "
#echo $REPLY
inputnamespace=$REPLY

m=1
for name in ${namespacelist}
do
   if [ $inputnamespace -eq $m ] ; then
      namespace=${name}
   fi
   m=$(($m+1))
done

echo "请选择功能菜单:"
echo " [1] 查看滚动日志"
echo " [2] 进入pod容器"

read -p "请输入功能菜单序号： "
type=$REPLY


#count=`kubectl get pod -n ${namespace}|wc -l`
podname=`kubectl get pod -n ${namespace}|awk '{print $1}'`

i=1
for name in ${podname}
do 
   echo   [${i}] : ${name}
   i=$(($i+1))
done

read -p " 服务列表list，请输入服务pod对应的序号: "
#echo $REPLY
input=$REPLY

j=1
if [ $i -gt $j ] ; then
for name in ${podname}
do
   if [ $input -eq $j ] ; then
      newpodname=${name}
   fi
   j=$(($j+1))
done
fi

if [ $type -eq 1 ] ; then
  kubectl logs --tail=200 -f ${newpodname} -n ${namespace}
elif [ $type -eq 2 ] ; then
  kubectl exec -it ${newpodname} -n ${namespace} bash 
fi
#kubectl logs --tail=200 -f ${newpodname} -n ${namespace}
