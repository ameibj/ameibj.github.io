---
title: echart图表自适应
date: 2017-11-09 17:45:22
tags: echart自适应
toc: true
---

### echarts html布局
图表元素的包裹元素绝对定位，利用百分比的padding-bottom是根据父元素的宽度定义，实现。

``` bash      
<style>
     .charts-wrapper .col-md-6 {
        position:relative;
        padding-bottom:25%;
     }
    .charts-wrapper .col-md-6 .charts-box {
        position:absolute;
        top:0;
        left:0;
        width: 100%;
        height:100%;
    }
</style>

<div class="charts-wrapper">
    <div class="row">
        <div class="col-md-12 charts-box">
            <div id="main-1" class="charts-box"></div>
        </div>
        <div class="col-md-6">
            <div id="main-2" class="charts-box"></div>
        </div>
        <div class="col-md-6">
            <div id="main-3" class="charts-box"></div>
        </div>
     </div>
</div>

```
### js 代码

``` bash 
引入<!--echarts 统计图-->
<script src="Content/libs/echarts/echarts-3.0/echarts.js"></script>
<script>
    var main_1 = document.getElementById('main-1');
    var main_2 = document.getElementById('main-2');
    var main_3 = document.getElementById('main-3');
    
    var myChart_1 = echarts.init(main_1);
    var myChart_2 = echarts.init(main_2);
    var myChart_3 = echarts.init(main_3);
    
    // 图标数据
    var option = {。。。。 略}
    
    // 使用刚指定的配置项和数据显示图表。
    myChart_1.setOption(option_1);
    myChart_2.setOption(option_2);
    myChart_3.setOption(option_3);
    
    //浏览器大小改变时重置大小
     window.addEventListener("resize", function () {
        myChart_1.resize();
        myChart_2.resize();
        myChart_3.resize();
     })
    
</script>
### 总结 

这里没用采用动态获取宽、高并赋值的操作实现， 图表的宽高都是设置的100%，继承自父元素的值。