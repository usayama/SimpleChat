# docker-vue-firebase
Vue Cli + Firebaseの環境をすぐつくるやつ

## Create App

##### ビルド

```bash
$ docker-compose build
```

##### Vue CLIでアプリを作成

```bash
$ docker-compose run --rm vue vue create .
```



## Serve App

##### コンテナを起動すると、vueアプリを起動するコマンドが実行される

```bash
$ docker-compose up
```

##### エラーが出て起動できなかった場合は `npm install` する

```bash
$ docker-compose run --rm vue npm install
```



## Init Firebase

##### コンテナをバックグラウンドで起動

```bash
$ docker-compose up -d
```

##### Firebaseのコンテナに入る

```bash
$ docker-compose exec firebase ash
```

##### Firebaseにログイン

```
# firebase login --no-localhost
```

- ##### Firebaseを初期化

  ```
  # firebase init
  ```

  - publicディレクトリを使うかは `dist`
  - SPAにするかは `No`

  - index.htmlを上書きするかは `No`

##### Firebaseのコンテナを落としてもOK

```bash
$ docker-compose down
```



## Deploy

##### Vueアプリをビルドする

```bash
$ docker-compose run --rm vue npm run build
```

##### コンテナをバックグラウンドで立ち上げる

```bash
$ docker-compose up -d
```

##### Firebaseのコンテナに入る

```bash
$ docker-compose exec firebase ash
```

##### Firebaseログイン

```
# firebase login --no-localhost
```

##### Firebaseデプロイ

```
# firebase deploy
```



#### ★トークンでログインしてデプロイする方法

##### Firebaseログインのときに `:ci` をつけてトークンを発行

```
# firebase login:ci --no-localhost
```

##### docker-compose.ymlの環境変数にFirebaseのトークンを追加

```yaml
services:
  firebase:
    environment: 
      - FIREBASE_TOKEN=トークン
```

##### Firebaseデプロイ

```bash
$ docker-compose run --rm firebase firebase deploy
```



## Firebase APIをやりとりするための記述

##### index.htmlにFirebaseのコードを追加

1. Setting / 全般 / Firebase SDK snippet のコードを `index.html ` の `<body>` 内の下部に記述

2. `<%= VUE_APP_FIREBASE_HOST %>` をURLの先頭に追加する

3. docker-compose.yml の `environment` にサイトのURLを記述
4. 新規ファイル `vue.config.js` を作成し、外部ファイルを使うのでビルドファイルに必要ないモジュールを記述

```js
module.exports = {
  configureWebpack: {
    externals: {
      firebase: 'firebase',
      firebaseui: 'firebaseui'
    }
  }
}
```

5. 下記を `app.vue` に記述して、エラーが出ないかチェック

```js
import firebase from 'firebase'
```

6. 使用する機能を `index.html` のSDKスニペットに追加していく

