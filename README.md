## 芒果TV 2016 年会抽奖
----------------

  声明: 该代码使用nodejs, coffee, sqlite3 运行于linux, mac.  该代码没有经过window测试． 不对任何windows平台bug进行修复．

  该代码实际跑12米 * 5 米在屏幕上，分辨率为1080P(1920 * 1080)

### 该程序已完工．完工日期大概为2016.2.1 [补充实际完成于2.2]


### GO! GO! Go!

#### Prepare

1. 安装coffee和node-dev

```
npm install -g coffee-script
```

2. 准备员工照片. 尺寸为300 * 300, 文件名格式为 "工号_姓名.png" 如 "001_张三.jpg"(jpg或png都可以).这个用来初始话员工数据库．放在同一个文件夹下．


#### Download & Run
1. clone 本仓库或者下载源码解压得到文件夹 ```lottery-2016```


2. 找到文件 ```config.coffee```

修改配置

```
config =
  ...
  ...
  img_source: '/home/ec/document/2016'
  ...
```
将 ```img_source``` 使用绝对路径指向员工照片的文件．

3. 找到文件```init-data.coffee```
  
取消最后三行注释后运行:(注意：以下命令均在项目文件夹下进行)

```
coffee init-data.coffee
```

进行数据初始化．初始化完成后将会在项目目录下出现```db.sqlite```这个就是数据库了．需要重复测试抽奖可以备份该文件，进行覆盖即可．

4. 运行

```
npm start
```

打开浏览器
```
http://localhost:3000
```

然后进行抽奖设置，和奖品设置即可．

如果抽奖需要混合奖品（非单一）可以根据数据库将奖品命名为：
```
 mix_(奖品数据库id-名称-数量)_(奖品数据库id-名称-数量)_．．．
```

例如：

```
mix_(28-温情家庭礼包-10)_(29-富士拍立得-10)_(30-芒果小觅-10)
```

另外记得修改html，增加与抽奖数量有关的抽奖结果模版。`static/lottery-start.html`
具体查看issue https://github.com/huyinghuan/lottery-2016/issues/1
```
<!--4*4+3*3+3*3=34-->
  <script type="text/x-handlebars-template" id="lotteryListTemplate_34">
    <div class="allbox b433">
      {{#each list}}
      <div class="prize ul{{count}}">
        <span class="z1"><i class="w-thing" style="background: url('award/{{award_id}}.png') bottom center no-repeat;"></i>{{award_name}}</span>
        <ul>
          {{#each luckyList}}
          <li><img src="avatar/{{num}}.jpg"> <span>{{name}}</span><i>{{num}}</i></li>
          {{/each}}
        </ul>
      </div>
      {{/each}}
    </div>
  </script>
```
### Thanks
```
 设计: luolei@mgtv.com
 页面: zixuan@mgtv.com
 开发: ec.huyinghuan@gmail.com
```

### LICENSE
MIT
