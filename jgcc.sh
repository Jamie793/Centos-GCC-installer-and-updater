##!/bin/bash
# author:Jamiexu_doxm@foxmail.com
# url:blog.jamiexu.cn




generateVersion(){
for i in `seq 5 10`;do
for j in $(seq 1 5);do
if [ $i -eq 8 -o $i -eq 9 -o $i -eq 10 ];then

case $i in
8) 
if [ $j -lt 5 ];then
echo $i"."$j
varray[${#varray[@]}]="$i.$j"
fi 
;;

9)
if [ $j -lt 4 ];then
echo $i"."$j
varray[${#varray[@]}]="$i.$j"
fi
;;

10)
if [ $j -eq 1 ];then
echo $i"."$j
varray[${#varray[@]}]="$i.$j"
fi
;;


esac
else
echo $i"."$j
varray[${#varray[@]}]="$i.$j"
fi
done
done
}


downloadTar(){
`curl -o gcc-shjamiexu.tar.gz http://ftp.gnu.org/gnu/gcc/gcc-$1.0/gcc-$1.0.tar.gz`
}


exists(){
for i in ${varray[@]};do
if [ $i == $1 ];then
return 1
fi
done
}


#generate and select version and install path
echo "Welcome to use Jamiexu GCC and G++ installer"
echo "Input 0 use default install path:/usr/local/gcc-$version"
echo "All gcc version,please select version"
generateVersion
echo "Input version:"
read version

if [ -z "$version" ];then
echo "Please input version number"
exit
fi

exists $version
res=$?
if [ $res -eq 0 ];then
echo "Not have version"
exit
fi




#install path
echo "Iput install path:"
read path

if [ -z "$path" ];then
echo "Please input intall path,input 0 use default install path:/usr/local/gcc-$version"
exit
fi


dpath="$path"
if [ "$path" == "0" ];then
path="/usr/local/gcc-$version"
else
path="$path/gcc-$version"
fi

if [ ! -d "$dpath" -a "$dpath" != "0" ];then
echo "Directory $dpath not found"
exit
fi



#start install
downloadTar $version
tar -xzvf gcc-shjamiexu.tar.gz
rm -rf gcc-shjamiexu.tar.gz
info=`yum -y info installed | grep "Name        : bzip2$"`
if [ -z "$info" ];then
echo "Install bzip2..."
`yum -y install bzip2`
echo "bzip2 already installed"
fi





#install 
yum -y install gcc
yum -y install glibc-headers
yum -y install gcc-c++
cd gcc-$version.0
./contrib/download_prerequisites
if [ -d "gcc-build" ];then
rm -rf gcc-build
fi
mkdir gcc-build && cd gcc-build 
../configure --prefix=$path --enable-languages=c,c++ --disable-multilib
make && make install
mv /usr/bin/gcc /usr/bin/gcc_bak_jamiexu 
mv /usr/bin/g++ /usr/bin/g++_bak_jamiexu 
ln -s $path/bin/gcc /usr/bin/gcc
ln -s $path/bin/g++ /usr/bin/g++
echo "Welcome use Jamiexu JGCC.sh.install successful"
