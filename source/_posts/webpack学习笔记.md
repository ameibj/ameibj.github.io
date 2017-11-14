---
title: webpack学习笔记
date: 2017-10-18 15:27:18
tags: [webpack3.8, webpack2]
reward: true
toc: true
comment: true
---


### 1、webpack 3.8

> mock 配置server mock数据 

<!-- more -->

在dev-server.js 下 var app = express() 下，
``` bash
/*my-mock-server*/
var appData = require('../db.json');
// newList API
var newsList =  appData.getNewsList;
// console.log(newsList)
var login =appData.login;
var createOrder =appData.createOrder;
var getOrderList =appData.getOrderList;
var getPrice =appData.getPrice;
var checkOrder =appData.checkOrder;

var apiRoutes = express.Router();

apiRoutes.all('/newsList',function(req,res){
  res.json({
    errno:0,
    data:newsList
  });
});
apiRoutes.all('/login',function(req,res){
  res.json({
    errno:0,
    data:login
  });
});
apiRoutes.all('/createOrder',function(req,res){
  res.json({
    errno:0,
    data:createOrder
  });
});
apiRoutes.all('/getPrice',function(req,res){
  res.json({
    errno:0,
    data:getPrice
  });
});
apiRoutes.all('/getOrderList',function(req,res){
  res.json({
    errno:0,
    data:getOrderList
  });
});
apiRoutes.all('/checkOrder',function(req,res){
  res.json({
    errno:0,
    data:checkOrder
  });
});
app.use('/api',apiRoutes);
/*end*/
```

### 2、prod.server.js 
> 创建 prod.server.js 
在根目录下创建 prod.server.js 内容如下：

``` bash
/*自定义小型server 在根目录下 element 11章（2）*/

var express = require('express'); //导入express
var config = require('./config/index'); //导入index.js(里面有很多配置)

var port = process.env.PORT || config.build.port;

var app = express();//实例化express

var router = express.Router();//初始化路由

router.get('/', function (req, res, next) {
  req.url = '/index.html'; //这里访问的是发布dist/index.html
  next();
});

app.use(router);

var appData = require('./db.json');;//读取模拟的数据文件
// 定义接口
/*my-mock-server*/
// newList API
var newsList =  appData.getNewsList;
// console.log(newsList)
var login =appData.login;
var createOrder =appData.createOrder;
var getOrderList =appData.getOrderList;
var getPrice =appData.getPrice;
var checkOrder =appData.checkOrder;

var apiRoutes = express.Router();

apiRoutes.all('/newsList',function(req,res){
  res.json({
    errno:0,
    data:newsList
  });
});
apiRoutes.all('/login',function(req,res){
  res.json({
    errno:0,
    data:login
  });
});
apiRoutes.all('/createOrder',function(req,res){
  res.json({
    errno:0,
    data:createOrder
  });
});
apiRoutes.all('/getPrice',function(req,res){
  res.json({
    errno:0,
    data:getPrice
  });
});
apiRoutes.all('/getOrderList',function(req,res){
  res.json({
    errno:0,
    data:getOrderList
  });
});
apiRoutes.all('/checkOrder',function(req,res){
  res.json({
    errno:0,
    data:checkOrder
  });
});
app.use('/api',apiRoutes);
/*end*/

app.use(express.static('./dist'));  //使用./dist作为web目录,所以能够找到.dist/index.html

module.exports = app.listen(port, function (err) {
  if (err) {
    console.log(err);
    return;
  }
  console.log('Listening at http://localhost:' + port + '\n'); // 手动运行node prod.server.js

});

```
同时 在 config 文件下 index.js  build 对象下添加 port ：9000
然后可以 在 cmd 窗口命令下： node prod.server.js  启动测试服务器（9000）


### 3、webpack 3.53 从头至尾 自定义玩法 [参考](https://segmentfault.com/a/1190000006178770) 
*webpack 3.8*

### 正式使用Webpack前的准备和基础配置
1. Webpack可以使用npm安装，新建一个空的练习文件夹（此处命名为webpack sample project），在终端中转到该文件夹后执行下述指令就可以完成安装。

2. 在上述练习文件夹中创建一个package.json文件，这是一个标准的npm说明文件，里面蕴含了丰富的信息，包括当前项目的依赖模块，自定义的脚本任务等等。在终端中使用npm init命令可以自动创建这个package.json文件
```` bash
npm init
````
输入这个命令后，终端会问你一系列诸如项目名称，项目描述，作者等信息，不过不用担心，如果你不准备在npm中发布你的模块，这些问题的答案都不重要，回车默认即可。

3. package.json文件已经就绪，我们在本项目中安装Webpack作为依赖包
```` bash
//全局安装
npm install -g webpack
//安装到你的项目目录
npm install --save-dev webpack
````
4. 回到之前的空文件夹，并在里面创建两个文件夹,app文件夹，app文件夹用来存放原始数据和我们将写的JavaScript模块。
* Greeter.js-- 放在app文件夹中;
* main.js-- 放在app文件夹中;

5. 通过配置文件来使用Webpack

```` bash
    module.exports = {
      entry:  __dirname + "/app/main.js",//已多次提及的唯一入口文件
      output: {
        path: __dirname + "/public",//打包后的文件存放的地方
        filename: "bundle.js"//打包后输出文件的文件名
      }
    }
````
> 注：“__dirname”是node.js中的一个全局变量，它指向当前执行脚本所在的目录。
6. 更快捷的执行打包任务 
       
       {
         "name": "webpack-sample-project",
         "version": "1.0.0",
         "description": "Sample webpack project",
         "scripts": {
           "start": "webpack" // 修改的是这里，JSON文件不支持注释，引用时请清除
         },
         "author": "zhang",
         "license": "ISC",
         "devDependencies": {
           "webpack": "^1.12.9"
         }
       }
       
> 注：package.json中的script会安照一定顺序寻找命令对应位置，本地的node_modules/.bin路径就在这个寻找清单中，所以无论是全局还是局部安装的Webpack，你都不需要写前面那指明详细的路径了。 
  
现在只需要使用npm start就可以打包文件了，有没有觉得webpack也不过如此嘛，不过不要太小瞧webpack，要充分发挥其强大的功能我们需要修改配置文件的其它选项，一项项来看。 

### Webpack的强大功能
#### 生成Source Maps（使调试更容易）
        
           module.exports = {
             devtool: 'eval-source-map',
             entry:  __dirname + "/app/main.js",
             output: {
               path: __dirname + "/public",
               filename: "bundle.js"
             }
           } 
             
> cheap-module-eval-source-map方法构建速度更快，但是不利于调试，推荐在大型项目考虑时间成本时使用。
#### 使用webpack构建本地服务器
把这些命令加到webpack的配置文件中，现在的配置文件webpack.config.js如下所示 
* contentBase : 默认webpack-dev-server会为根文件夹提供本地服务器，如果想为另外一个目录下的文件提供本地服务器，应该在这里设置其所在目录（本例设置到“public"目录） 
* port : 设置默认监听端口，如果省略，默认为”8080“
* inline : 设置为true，当源文件改变时会自动刷新页面
* historyApiFallback : 在开发单页应用时非常有用，它依赖于HTML5 history API，如果设置为true，所有的跳转将指向index.html。
       
        npm install --save-dev webpack-dev-server
        module.exports = {
          devtool: 'eval-source-map',
        
          entry:  __dirname + "/app/main.js",
          output: {
            path: __dirname + "/public",
            filename: "bundle.js"
          },
        
          devServer: {
            contentBase: "./public",//本地服务器所加载的页面所在的目录
            historyApiFallback: true,//不跳转
            inline: true//实时刷新
          } 
        }
在package.json中的scripts对象中添加如下命令，用以开启本地服务器：

          "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1",
            "start": "webpack",
            "server": "webpack-dev-server --open"
          },
          
在终端中输入npm run server即可在本地的8080端口查看结果

#### Loaders 
* test：一个用以匹配loaders所处理文件的拓展名的正则表达式（必须）
* loader：loader的名称（必须）
* query：为loaders提供额外的设置选项（可选）

#### Babel的安装与配置
Babel其实可以完全在 webpack.config.js 中进行配置，但是考虑到babel具有非常多的配置选项，在单一的webpack.config.js文件中进行配置往往使得这个文件显得太复杂，因此一些开发者支持把babel的配置选项放在一个单独的名为 ".babelrc" 的配置文件中。我们现在的babel的配置并不算复杂，不过之后我们会再加一些东西，因此现在我们就提取出相关部分，分两个配置文件进行配置（webpack会自动调用.babelrc里的babel配置选项），如下：
        
        // npm一次性安装多个依赖模块，模块之间用空格隔开
        npm install --save-dev babel-core babel-loader babel-preset-es2015
        
        module.exports = {
            entry: __dirname + "/app/main.js",//已多次提及的唯一入口文件
            output: {
                path: __dirname + "/public",//打包后的文件存放的地方
                filename: "bundle.js"//打包后输出文件的文件名
            },
            devtool: 'eval-source-map',
            devServer: {
                contentBase: "./public",//本地服务器所加载的页面所在的目录
                historyApiFallback: true,//不跳转
                inline: true//实时刷新
            },
            module: {
                rules: [
                    {
                        test: /\.js$/,
                        use: {
                            loader: "babel-loader"
                        },
                        exclude: /node_modules/
                    }
                ]
            }
        };
        
        //.babelrc
        {
          "presets": ["es2015"]
        }
        
接下来，在app文件夹里创建一个名字为"main.css"的文件，对一些元素设置样式
        
        /* main.css */
        html {
          box-sizing: border-box;
          -ms-text-size-adjust: 100%;
          -webkit-text-size-adjust: 100%;
        }
        
        *, *:before, *:after {
          box-sizing: inherit;
        }
        
        body {
          margin: 0;
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }
        
        h1, h2, h3, h4, h5, h6, p, ul {
          margin: 0;
          padding: 0;
        }
        
> 通常情况下，css会和js打包到同一个文件中，并不会打包为一个单独的css文件，不过通过合适的配置webpack也可以把css打包为单独的文件的。

在app文件夹下创建一个Greeter.css文件
        
        .root {
          background-color: #eee;
          padding: 10px;
          border: 3px solid #ccc;
        }

#### CSS预处理器

首先安装postcss-loader 和 autoprefixer（自动添加前缀的插件）

        npm install --save-dev postcss-loader autoprefixer
        
接下来，在webpack配置文件中添加postcss-loader，在根目录新建postcss.config.js,并添加如下代码之后，重新使用npm start打包时，你写的css会自动根据Can i use里的数据添加不同前缀了。

        // postcss.config.js
        module.exports = {
            plugins: [
                require('autoprefixer')
            ]
        }
        
#### 插件（Plugins） 
##### HtmlWebpackPlugin 
这个插件的作用是依据一个简单的index.html模板，生成一个自动引用你打包后的JS文件的新index.html。这在每次生成的js文件名称不同时非常有用（比如添加了hash值）。

        npm install --save-dev html-webpack-plugin

在app目录下，创建一个index.tmpl.html文件模板，这个模板包含title等必须元素，在编译过程中，插件会依据此模板生成最终的html页面，会自动添加所依赖的 css, js，favicon等文件，index.tmpl.html中的模板源代码如下

        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <title>Webpack Sample Project</title>
          </head>
          <body>
            <div id='root'>
            </div>
          </body>
        </html

更新 webpakc 配置文件

        const webpack = require('webpack');
        const HtmlWebpackPlugin = require('html-webpack-plugin');
        
        module.exports = {
            entry: __dirname + "/app/main.js",//已多次提及的唯一入口文件
            output: {
                path: __dirname + "/build",
                filename: "bundle.js"
            },
            devtool: 'eval-source-map',
            devServer: {
                contentBase: "./public",//本地服务器所加载的页面所在的目录
                historyApiFallback: true,//不跳转
                inline: true//实时刷新
            },
            module: {
                rules: [
                    {
                        test: /(\.jsx|\.js)$/,
                        use: {
                            loader: "babel-loader"
                        },
                        exclude: /node_modules/
                    },
                    {
                        test: /\.css$/,
                        use: [
                            {
                                loader: "style-loader"
                            }, {
                                loader: "css-loader",
                                options: {
                                    modules: true
                                }
                            }, {
                                loader: "postcss-loader"
                            }
                        ]
                    }
                ]
            },
            plugins: [
                new webpack.BannerPlugin('版权所有，翻版必究'),
                new HtmlWebpackPlugin({
                    template: __dirname + "/app/index.tmpl.html"//new 一个这个插件的实例，并传入相关的参数
                })
            ],
        };
        
        
### 产品阶段的构建和优化插件
对于复杂的项目来说，需要复杂的配置，这时候分解配置文件为多个小的文件可以使得事情井井有条，以上面的例子来说，我们创建一个webpack.production.config.js的文件，在里面加上基本的配置,它和原始的webpack.config.js很像，如下：
* OccurenceOrderPlugin :为组件分配ID，通过这个插件webpack可以分析和优先考虑使用最多的模块，并为它们分配最小的ID
* UglifyJsPlugin：压缩JS代码；
* ExtractTextPlugin：分离CSS和JS文件
      
我的目前最终基础版本：
```` bash
//webpack.common.js

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack = require('webpack');

const ExtractCSS = new ExtractTextPlugin('[name].bundle.css');

module.exports = {
    entry: {
        app: __dirname + "/src/index.js",
        vendor: ['jquery', 'bootstrap/dist/js/bootstrap.js']
    },
    output: {
        path: path.resolve(__dirname, 'dist')
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: __dirname + "/src/index.html" // new 一个插件实例，并传入相关参数
        }),
        new CleanWebpackPlugin(['dist']),
        ExtractCSS,
        new webpack.ProvidePlugin({ // 设置全局变量
            $: 'jquery',
            jQuery: "jquery",
            'window.$': 'jquery',
            'window.jQuery': 'jquery'
        }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'vendor' // 抽取出共用模块的模块名 将 vendor 入口处的代码放入 vendor 模块
        }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'runtime' // 将 webpack 自身的运行时代码放在 runtime 模块
        })
    ],
    module: {
        rules: [
            {
                test: /\.css$/,
                use: ExtractCSS.extract([
                    {
                        loader: 'css-loader',
                        options: {
                            minimize: true
                        } //css压缩
                    },
                    'postcss-loader'
                ])
            },
            {
                test: /\.less$/i,
                use: ExtractCSS.extract(['css-loader', 'less-loader'])
            },

            {
                test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
                use: {
                    loader: 'url-loader?limit=8192&name=images/[name].[ext]',
                }
            },
            { // 增加加载字体的规则
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            }
        ]
    }
    /* externals: {
     'jquery': 'window.jQuery' //如果要全局引用jQuery，不管你的jQuery有没有支持模块化，用externals就对了。
     }*/
}
// webpack.div.js 开发版本
const path = require('path');
const webpack = require('webpack');
const Merge = require('webpack-merge');
const CommonConfig = require('./webpack.common.js');

module.exports = Merge(CommonConfig, {
    devtool: 'cheap-module-eval-source-map',
    devServer: {
        contentBase: path.resolve(__dirname, 'dist'),
        hot: true,
        hotOnly: true
    },
    output: {
        filename: '[name].bundle.js'
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env.NODE_ENV': JSON.stringify('devlopment') // 在编译的代码里设置了`process.env.NODE_ENV`变量
        }),
        new webpack.HotModuleReplacementPlugin(),

        new webpack.NamedModulesPlugin(), //  打印日志信息时 webpack 默认使用模块的数字 ID 指代模块，不便于 debug，这个插件可以将其替换为模块的真实路径

    ]
})

// webpack.prod.js
const path = require('path');
const webpack = require('webpack');
const Merge = require('webpack-merge');
const CommonConfig = require('./webpack.common.js');

module.exports = Merge(CommonConfig,{
    devtool: 'cheap-module-source-map',
    output: {
      //  filename: '[name].[chunkhash:5].js'
        filename: '[name].bundle.js'
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env.NODE_ENV': JSON.stringify('production')
        }),
        new webpack.optimize.UglifyJsPlugin() // JS 压缩
    ]

})
````                        
        //package.json windown7 环境
          {
            "name": "webpack-project2",
            "version": "1.0.0",
            "scripts": {
              "test": "echo \"Error: no test specified\" && exit 1",
              "start": "webpack-dev-server --open",
              "dev": "webpack-dev-server --open --config webpack.dev.js",
              "build": "webpack --progress --config webpack.prod.js"
            },
            "devDependencies": {
              "autoprefixer": "^7.1.6",
              "babel-core": "^6.26.0",
              "babel-loader": "^7.1.2",
              "babel-preset-env": "^1.6.1",
              "babel-preset-es2015": "^6.24.1",
              "bootstrap": "^3.3.7",
              "clean-webpack-plugin": "^0.1.17",
              "cross-env": "^5.1.1",
              "css-loader": "^0.28.7",
              "extract-text-webpack-plugin": "^3.0.2",
              "file-loader": "^1.1.5",
              "html-webpack-plugin": "^2.30.1",
              "jquery": "^3.2.1",
              "less": "^2.7.3",
              "less-loader": "^4.0.5",
              "postcss-loader": "^2.0.8",
              "style-loader": "^0.19.0",
              "url-loader": "^0.6.2",
              "webpack": "^3.8.1",
              "webpack-dev-server": "^2.9.3",
              "webpack-merge": "^4.1.1"
            }
          }


#### 缓存 
webpack可以把一个哈希值添加到打包的文件名中，使用方法如下,添加特殊的字符串混合体（[name], [id] and [hash]）到输出文件名前
        
        const webpack = require('webpack');
        const HtmlWebpackPlugin = require('html-webpack-plugin');
        const ExtractTextPlugin = require('extract-text-webpack-plugin');
        
        module.exports = {
        ..
            output: {
                path: __dirname + "/build",
                filename: "bundle-[hash].js"
            },
           ...
        };
        
*以上转自[https://segmentfault.com/a/1190000006178770](https://segmentfault.com/a/1190000006178770)部分内容根据 win7 和实际webpack3.8环境略有调整！依然不断完善中ing*
