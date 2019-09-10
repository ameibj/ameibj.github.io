#!/usr/bin/env sh

# ȷ���ű��׳������Ĵ���
set -e

# ���ɾ�̬�ļ�
npm run docs:build

# �������ɵ��ļ���
cd docs/.vuepress/dist

git init
git add -A
git commit -m 'deploy'

# ��������� https://<USERNAME>.github.io/<REPO> https://github.com/ameibj/ameibj.github.io
git push -f git@github.com:<ameibj>/<ameibj.github.io>.git master:Vuepress

cd -
