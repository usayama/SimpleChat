# docker-vue-firebase
Vue Cli + Firebaseの環境をすぐつくるやつ

##### Vueのコンテナに入る

```bash
$ docker-compose exec vue ash
```

##### Vue CLIでアプリを作成

```
# vue create .
```

##### Vueアプリを起動

```
# npm run serve
```

##### Firebaseのコンテナに入る

```bash
$ docker-compose exec firebase ash
```

##### Firebaseにログイン

```
# firebase login --no-localhost
```

#####  Firebaseの設定

```
# firebase init
```

- 質問に答えていく
- ディレクトリは `dist` を指定する

##### vueのコンテナに入る

```bash
$ docker-compose exec vue ash
```

##### 本番ビルド

```
# npm run build
```

##### Firebaseデプロイ

```
# firebase deploy
```
