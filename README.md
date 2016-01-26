## 芒果TV 2016 年会抽奖
----------------

  声明: 该代码使用coffee, sqlite3 运行于linux, mac.  该代码没有经过window测试． 不对任何windows平台bug进行修复．

  该代码实际跑12米 * 5 米在屏幕上，分辨率为1080P(1920 * 1080)

### 该程序尚未完工．完工日期大概为2016.2.1

### 运行Demo

```
git clone https://github.com/huyinghuan/lottery-2016.git
cd lottery-2016
npm install
npm test
```

### GO! GO! Go!

#### Prepare

1. 安装coffee

```
npm install -g coffee-script
```

2. 准备员工照片. 尺寸为300 * 300, 文件名格式为 "工号-姓名-性别.png" 如 "001-张三-男.png"(jpg或png都可以).这个用来初始话员工数据库．放在同一个文件夹下．


#### Download & Run
clone 本仓库或者下载源码解压
```
cd path/to/lottery-2016
npm install
npm start
```

打开浏览器
```
http://localhost:3000
```


### Thanks
```
 设计: luolei@mgtv.com
 页面: 
 开发: ec.huyinghuan@gmail.com
```

### DONATE
支付宝 646344359@qq.com

### LICENSE
MIT