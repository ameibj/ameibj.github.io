---
title: git学习笔记
date: 2017-11-11 13:11
tags: [git命令]
reward: true
toc: true
comment: true
---

### git删除github远程分支
git push  [远程主机名] :[远程分支名]
例如想删除远程主机 develop 分支，运行下面的命令：
        
        git push origin :develop
        
        注意origin后面有空格
        
### 在本地新建一个分支

	git branch Branch1 

### 切换到你的新分支 

	git checkout Branch1

### 添加当前工作目录文件到index

	git add .

### 生成一个commit
	
	git commit -m "some comments"

### 将新分支发布在github上

	git push origin Branch1
	
### 在本地新建一个分支 （hexo）
	git branch hexo
	
### 切换到你的新分支（hexo）
     git checkout hexo

### 在本地删除一个分支 

	git branch -d Branch1

### 在github远程端删除一个分支

	git push origin :Branch1   (分支名前的冒号代表删除)
	
### 获取最新
	git pull

