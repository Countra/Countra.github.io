#/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo -e "\033[41;33m 安装依赖 \033[0m"
apt install sudo -y
echo -e "\033[41;33m 依赖安装完成 \033[0m"
sudo rm -rf ./install.sh
cd /

#Aria2密码
p=1234

#是否安装Apache2
a=y

#默认网页路径
dir="/var/www/html"
d=$dir

if [ $d != $dir ] ; then
    dir=$d
    echo !
fi


while getopts ":p:a:d:h:" opt
do
    case $opt in
        p)
        p=$OPTARG
        ;;
        a)
        a=$OPTARG
        ;;
        d)
        d=$OPTARG
        ;;
        h)
        h=$OPTARG
        ;;
        ?)
        echo "WTF???"
        exit 
        ;;
    esac
done



#判断系统是debian，Ubuntu，Fedora，cent还是手机的turmux

if [[  $(command -v sudo apt)  ]] ; then
        cmd="sudo apt"
else
        cmd="sudo yum"

fi


#安装必要的包
$cmd update 
#根据需要，安装Apache2
if [ $a = "y" ] ; then
    cmd1="$cmd install apache2 -y"
    $cmd1
    sudo mv $dir/index.html $dir/index.html0
else  
    echo "I will not install apache2."
fi

#安装必要的
cmd2="$cmd install screen vim aria2 unzip git curl -y"
$cmd2

# 下载AriaNg
echo -e "\033[41;33m 下载AriaNg \033[0m"
tmp="/tmp/Onekey-deploy_aria2"
sudo rm -rf $tmp
sudo git clone https://github.com/Countra/backup_aria2.git $tmp
sudo rm -rf $dir/lixian
sudo rm -rf $dir/downloads
sudo mkdir -p $dir/lixian 
sudo mkdir -p $dir/downloads
sudo unzip $tmp/*.zip -d $dir/lixian
sudo chmod 777 -R $dir/lixian
link="<a href="http://$ip:8080" target="blank">"
cat $dir/lixian/head.html > $dir/lixian/index.html
echo $link >> $dir/lixian/index.html
cat $dir/lixian/foot.html >> $dir/lixian/index.html
#sudo rm -rf $dir/index.html

#沃日，为啥一直bug。。。
ip=$(curl -s https://ipinfo.io/ip)
echo "你的公网ip是$ip"
dir="/var/www/html"
link="<a href="http://$ip:8080" target="blank">"
sudo cat $dir/lixian/head.html > $dir/lixian/index.html
sudo echo $link >> $dir/lixian/index.html
sudo cat $dir/lixian/foot.html >> $dir/lixian/index.html
#安装FileBrowser
echo -e "\033[41;33m 开始安装fileBrowser \033[0m"
curl -fsSL https://raw.githubusercontent.com/Countra/Countra.github.io/master/drive/get.sh | bash
echo -e "\033[41;33m 完成安装fileBrowser \033[0m"



echo -e "开始配置aria2"
sudo rm -rf /root/.aria2
sudo mkdir -p /root/.aria2
sudo rm -rf /root/.aria2/*
sudo touch /root/.aria2/aria2.session
sudo mv /tmp/Onekey-deploy_aria2/aria2.conf /root/.aria2/
sudo mv /tmp/Onekey-deploy_aria2/updatetracker.sh /root/.aria2/
sudo rm -rf ./install.sh
secret="rpc-secret=$p"
upload="on-download-complete=/root/rcloneupload.sh"
sudo echo $upload >> /root/.aria2/aria2.conf

echo -e "\033[41;33m 设置systemctl \033[0m"
sudo cp $tmp/aria2c /etc/init.d/
sudo cp $tmp/filebrowser /etc/init.d/
echo -e "\033[41;33m 拷贝完成 \033[0m"
sudo chmod 777  /etc/init.d/aria2c
sudo chmod 777  /etc/init.d/filebrowser
echo -e "\033[41;33m 授权完成 \033[0m"
sudo systemctl daemon-reload
echo -e "\033[41;33m 重启服务 \033[0m"
service aria2c restart
service filebrowser restart
echo -e "\033[41;33m Finish! \033[0m"
echo "filebower地址: "http://$ip:8080" AriaNg: "http://$ip/lixian""