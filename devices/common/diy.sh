#!/bin/bash
#=================================================
# Description: Build OpenWrt using GitHub Actions 
# Lisence: MIT
# 参考以下资料：
# Frome: https://github.com/garypang13/Actions-OpenWrt
# Frome: https://github.com/P3TERX/Actions-OpenWrt
# Frome: https://github.com/Lienol/openwrt-actions
# Frome: https://github.com/svenstaro/upload-release-action
# By YAOF 2020 https://www.yaof.org
# https://github.com/yaof2
#=================================================

# 修改登陆地址
#sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 关闭禁止解析IPv6 DNS 记录
#sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf

# 修改内核版本
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' target/linux/x86/Makefile

#修改网络连接数
#sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf


#清楚kidd库里的eqos和ikoolproxy和clash，用我自己的
git clone https://github.com/yaof2/luci-app-eqos.git package/diy/luci-app-eqos
git clone https://github.com/yaof2/luci-app-ikoolproxy.git package/diy/luci-app-ikoolproxy


#重启计划
svn co https://github.com/sirpdboy/diy/trunk/luci-app-rebootschedule package/diy/luci-app-rebootschedule


#管控
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/diy/luci-app-control-webrestriction
#svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/diy/luci-app-control-timewol无法运行
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/diy/luci-app-control-weburl
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-timecontrol package/diy/luci-app-timecontrol




#克隆ssr
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
./scripts/feeds install -a


# 内核显示增加自己个性名称(21.3.2 %y : 年份的最后两位数字)
date=`date +%y.%m.%d`
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='OneWRT R%C From Openwrt %V'/g" package/base-files/files/etc/openwrt_release
sed -i "s/# REVISION:=x/REVISION:= $date/g" include/version.mk
