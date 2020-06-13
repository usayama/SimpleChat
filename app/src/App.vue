<template>
  <div id="app">
    <header class="header">
      <h1>Chat</h1>
      <!-- ログイン時 -->
      <div v-if="user.uid" key="login">
        {{ user.displayName }}
        <button type="button" @click="doLogout">ログアウト</button>
      </div>
      <!-- ログアウト時 -->
      <div v-else key="logout">
        <button type="button" @click="doLogin">ログイン</button>
      </div>
    </header>

    <transition-group name="chat" tag="div" class="list content">
      <section v-for="{ key, name, image, message } in posts" :key="key" class="item">
        <div class="item-image"><img :src="image" width="40" height="40" alt="" /></div>
        <div class="item-detail">
          <div class="item-name">{{ name }}</div>
          <div class="item-message">{{ message }}</div>
        </div>
      </section>
    </transition-group>

    <form @submit.prevent="doSend" class="form">
      <textarea v-model="inputedMessage" :disabled="!user.uid"> </textarea>
      <button type="submit" :disabled="!user.uid" class="send-button">Send</button>
    </form>
  </div>
</template>

<script>
import firebase from 'firebase'

export default {
  name: 'App',
  data() {
    return {
      user: {},
      posts: [],
      inputedMessage: ''
    }
  },
  computed: {},
  methods: {
    doLogin() {
      const provider = new firebase.auth.TwitterAuthProvider()
      firebase.auth().signInWithPopup(provider)
    },
    doLogout() {
      firebase.auth().signOut()
    },
    scrollBottom() {
      this.$nextTick(() => {
        window.scrollTo(0, document.body.clientHeight)
      })
    },
    // 受け取ったメッセージをpostsに追加
    // データベースに新しい要素が追加されると随時呼び出される
    childAdded(snap) {
      const post = snap.val()
      this.posts.push({
        key: snap.key,
        name: post.name,
        image: post.image,
        message: post.message
      }),
        this.scrollBottom()
    },
    async doSend() {
      if (this.user.uid && this.inputedMessage.length) {
        // Firebaseにメッセージを送信
        await firebase
          .database()
          .ref('post')
          .push({
            message: this.inputedMessage,
            name: this.user.displayName,
            image: this.user.photoURL
          })
        this.inputedMessage = ''
      }
    }
  },
  created() {
    firebase.auth().onAuthStateChanged(user => {
      this.user = user ? user : {}
      const ref_post = firebase.database().ref('post')
      if (user) {
        this.posts = []
        // message に変更があったときのハンドラを登録
        ref_post.limitToLast(10).on('child_added', this.childAdded)
      } else {
        // message に変更があったときのハンドラを登録
        ref_post.limitToLast(10).off('child_added', this.childAdded)
      }
    })
  }
}
</script>

<style>
* {
  margin: 0;
  box-sizing: border-box;
}
.header {
  background: #3ab383;
  margin-bottom: 1em;
  padding: 0.4em 0.8em;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.header button {
  margin-left: 8px;
}
.content {
  margin: 0 auto;
  padding: 0 10px;
  max-width: 600px;
}
.form {
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  bottom: 0;
  height: 80px;
  width: 100%;
  background: #f5f5f5;
}
.form textarea {
  border: 1px solid #ccc;
  border-radius: 2px;
  height: 4em;
  width: calc(100% - 6em);
  resize: none;
  margin-left: 12px;
}
.list {
  margin-bottom: 100px;
}
.item {
  position: relative;
  display: flex;
  align-items: flex-end;
  margin-bottom: 0.8em;
}
.item-image img {
  border-radius: 20px;
  vertical-align: top;
}
.item-detail {
  margin: 0 0 0 1.4em;
}
.item-name {
  font-size: 75%;
}
.item-message {
  position: relative;
  display: inline-block;
  padding: 0.8em;
  background: #deefe8;
  border-radius: 4px;
  line-height: 1.2em;
}
.item-message::before {
  position: absolute;
  content: ' ';
  display: block;
  left: -16px;
  bottom: 12px;
  border: 4px solid transparent;
  border-right: 12px solid #deefe8;
}
.send-button {
  margin-left: 12px;
  margin-right: 12px;
  height: 4em;
  background: #666;
  border: none;
  width: 88px;
  border-radius: 4px;
  color: #fff;
  outline: none;
}
/* トランジション用スタイル */
.chat-enter-active {
  transition: all 1s;
}
.chat-enter {
  opacity: 0;
  transform: translateX(-1em);
}
</style>
