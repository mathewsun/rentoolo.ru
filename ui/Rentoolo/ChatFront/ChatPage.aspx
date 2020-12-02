<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChatPage.aspx.cs" Inherits="Rentoolo.ChatFront.ChatPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <head>
        <meta charset="utf-8" />
        <title></title>

        <style>
            .with-left-toolbar-container {
                display: grid;
                grid-template-columns: 20% 1fr;
            }


            .chat-template{

                display: grid;
                grid-template: 'chats messages';
                grid-template-columns: 20% 1fr;

            }


            div.button {
                display: inline-block;
                -webkit-appearance: button;
                padding: 3px 8px 3px 8px;
                font-size: 13px;
                position: relative;
                cursor: context-menu;
                box-shadow: 0 0 5px -1px rgba(0,0,0,0.2);
                border: 1px solid #CCC;
                background: #DDD;
                width: 200px;
            }

            div.button:active {
                color: red;
                box-shadow: 0 0 5px -1px rgba(0,0,0,0.6);
            }

            .chat-item{
              background-color: #ffe1e1;
              margin-top: 10px;
              margin-bottom: 10px;
              border-radius: 30px;
              padding: 50px;
              word-break: break-all;
            }
    
            .chat-footer{
              background-color: #dfeeff;
              padding: 10px;
            }
    
            .chat-box{
              height: 900px;
              overflow: auto;
            }



        </style>

    </head>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
        <div id="app">

            <h1>Chat tests</h1>
            <div class="button" @click="hideMetaInfo">show/hide meta info</div>

            
                    <div v-if="metaInfo">
                        <div>
                            <h5>user configs</h5>
                            <div>
                                UserId: {{userId}}
                            </div>
                        </div>

                        <div>
                            <h5>
                                Create chat
                            </h5>

                            <div>
                                <input type="text" v-model="chatName" />
                                <div class="button" @click="createChat" >create</div>
                            </div>

                        </div>
                    
                        <div v-if="inChat">
                            add new user in chat:<br />
                            <input type="text" v-model="newUserId" />
                            <div class="button" @click="addNewChatUser">add</div>
                        </div>
                    </div>

            <div class="chat-template">

                <div id="chats">
                    <div class="with-left-toolbar-container">
                        <div>

                            <div v-if="showChats">
                                <div>
                                    <div v-for="(chat,index) in chats" :key="index">

                                        <div class="button" @click="getMessages(chat.Id)">

                                            {{chat.ChatName}}
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <h3>{{message1}} </h3>

                        </div>

                    </div>
                </div>

                <div id="messages">

                        <div class="container" id="msgcont">
                             <div class="chat-box row">
                               <div class="col-md-12 chat-item" v-for="(message,index) in messages" :key="index">
                                    <div>
                                        From:{{message.FromUserId}} <br />
                                        Message: <br />
                                        {{message.Message}}
                                        
                                    </div>
                               </div>
                               <div id="bottom">
                                   bottom
                               </div>
                               
                             </div>
                        </div>

                    <div class="chat-footer">
                           <div class="container" style="display: flex">
                               
                             <input class="form-control"  v-model="message" type="text" placeholder="Message" />
                             <div class="button" @click="sendMessage">send</div>
                           </div>
                         </div>

                </div>

            </div>




<%--            <div>

                <div>

                    
                    <div v-if="metaInfo">
                        <div>
                            <h5>user configs</h5>
                            <div>
                                UserId: {{userId}}
                            </div>
                        </div>

                        <div>
                            <h5>
                                Create chat
                            </h5>

                            <div>
                                <input type="text" v-model="chatName" />
                                <div class="button" @click="createChat" >create</div>
                            </div>

                        </div>
                    
                        <div v-if="inChat">
                            add new user in chat:<br />
                            <input type="text" v-model="newUserId" />
                            <div class="button" @click="addNewChatUser">add</div>
                        </div>
                    </div>

                    <div>
                        <div class="container" id="msgcont">
                             <div class="chat-box row">
                               <div class="col-md-12 chat-item" v-for="(message,index) in messages" :key="index">
                                    <div>
                                        From:{{message.FromUserId}} <br />
                                        Message: <br />
                                        {{message.Message}}
                                        
                                    </div>
                               </div>
                               <div id="bottom">
                                   bottom
                               </div>
                               
                             </div>
                        </div>
    
                         <div class="chat-footer">
                           <div class="container" style="display: flex">
                               
                             <input class="form-control"  v-model="message" type="text" placeholder="Message" />
                             <div class="button" @click="sendMessage">send</div>
                           </div>
                         </div>
                    </div>


                </div>
                

                <hr>

                <div class="with-left-toolbar-container">
                    <div>

                        <div v-if="showChats">
                            <div>
                                <div v-for="(chat,index) in chats" :key="index">

                                    <div class="button" @click="getMessages(chat.Id)">

                                        {{chat.ChatName}}
                                    </div>

                                </div>
                            </div>
                        </div>

                        <h3>{{message1}} </h3>

                    </div>

                </div>

            </div>--%>


        </div>

        <script type="text/javascript">

            function gotoBottom(id) {
                id = 'bottom';
                var element = document.getElementById(id);
                //console.log(element);
                //console.log(element.scrollHeight);
                element.scrollIntoView({ block: "end", behavior: "smooth" });

                //element.scrollTop = element.scrollHeight;



                //element.scrollTop = element.scrollHeight - element.clientHeight;
                //element.scrollTop += 100;
                
            }

            let websock;


            let serverDomain = "http://localhost:53222";
            let wsServerDomain = "ws://localhost:4848";

            var app = new Vue({
                el: '#app',
                data: {
                    userId: "<%= CurUser.UserId %>",
                    currentChatId: null,
                    message1: 'Hello Vue!',
                    showChats: true,
                    chats: [],
                    messages: [],
                    message: "",
                    showMessages: false,
                    ws: null,
                    chatName: "",
                    domain: serverDomain,
                    inChat: false,
                    newUserId: "",
                    metaInfo: true
                },
                created: function () {
                    this.getChats();
                },
                methods: {

                    hideMetaInfo() {
                        this.metaInfo = !this.metaInfo;
                    },


                    createChat() {

                        let url = "http://localhost:53222/api/Chats?anotheruser=";

                        let bodyData = {
                            OwnerId: this.userId,
                            chatName: this.chatName,
                            chatType: 0
                        };

                        let data = {
                            method: "POST",
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(bodyData)
                        };

                        fetch(url, data)
                            .then((response) => {

                                return response;
                            })
                            .then((data) => {
                                //console.log(data);
                            });

                    },
                    addMessage(msg) {
                        let jsonedMsg = JSON.parse(msg);
                        //this.messages.unshift(jsonedMsg);
                        this.messages.push(jsonedMsg);
                        gotoBottom('msgcont');
                    },

                    initWSConnection() {
                        //console.log("this.msges");
                        //console.log(this.messages);
                        const addMessage = this.addMessage;
                        const addMsg = function (msg) {
                            //console.log(this.messages);
                            addMessage(msg);
                        }

                        let socket = new WebSocket(wsServerDomain);

                        let chatId = this.currentChatId;
                        let usrId = this.userId;


                        socket.onmessage = function (event) {
                            //console.log("Получены данные " + event.data);
                            addMsg(event.data);
                        };

                        socket.onopen = function () {

                            let data = {
                                type: "initUser",
                                chatId: chatId,
                                userId: usrId
                            }
                            //console.log("---------");
                            //console.log(data);

                            socket.send(JSON.stringify(data));
                        };

                        socket.onclose = function (event) {
                            if (event.wasClean) {
                                alert('Соединение закрыто чисто');
                            } else {
                                alert('Обрыв соединения'); // например, "убит" процесс сервера
                            }
                            alert('Код: ' + event.code + ' причина: ' + event.reason);
                        };



                        socket.onerror = function (error) {
                            alert("Ошибка " + error.message);
                        };





                        websock = socket;

                        //console.log("this.msges");
                        //console.log(this.messages);

                    },
                    showHideChats() {
                        this.showChats = !this.showChats;
                    },
                    showHideMessages() {
                        this.showMessages = !this.showMessages;
                    },
                    getChats() {
                        // dont forbid to change url
                        let url = this.domain + "/api/chats/" + this.userId;
                        let data = {
                            method: "GET",
                        };
                        fetch(url, data)
                            .then((response) => {
                                console.log(response);
                                return response.json();
                            })
                            .then((data) => {
                                console.log(data);
                                this.chats = data;
                            });

                    },
                    getMessages(chatId) {
                        let url = this.domain + "/api/Messages/" + chatId;
                        this.currentChatId = chatId;
                        let data = {
                            method: "GET"
                        };
                        fetch(url, data)
                            .then((response) => {
                                //console.log("message list");
                                //console.log(response);
                                return response.json();
                            })
                            .then((data) => {
                                //console.log(data);
                                this.messages = data;
                                gotoBottom('bottom');
                            });
                        this.showMessages = true;

                        this.initWSConnection();

                        this.inChat = true;

                    },
                    sendMessage() {
                        let bodyData = {
                            ChatId: this.currentChatId,
                            Message: this.message,
                            UserId: this.userId,

                        }

                        let url = this.domain + "/api/Messages";

                        let data = {
                            method: "POST",
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(bodyData)
                        };



                        fetch(url, data)
                            .then((response) => {

                                return response;
                            })
                            .then((data) => {
                                //console.log(data);
                            });

                        this.message = "";




                    },

                    addNewChatUser() {
                        let bodyData = {
                            chatId: this.currentChatId,
                            userId: this.newUserId

                        }

                        let url = this.domain + "/api/chats";

                        let data = {
                            method: "PUT",
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(bodyData)
                        };



                        fetch(url, data)
                            .then((response) => {

                                return response;
                            })
                            .then((data) => {
                                //console.log(data);
                            });
                    }


                }

            })

        </script>

    </div>
</asp:Content>
