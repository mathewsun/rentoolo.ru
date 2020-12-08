<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChatPage2.aspx.cs" Inherits="Rentoolo.ChatFront.ChatPage2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <head>
        <meta charset="utf-8" />
        <title></title>

        <style>
            .with-left-toolbar-container {
                display: grid;
                grid-template-columns: 20% 1fr;
            }


            .chat-template {
                display: grid;
                grid-template: 'chats messages';
                grid-template-columns: 20% 80%;
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

            .chat-item {
                background-color: #ffe1e1;
                margin-top: 10px;
                margin-bottom: 10px;
                margin-left: 30px;
                border-radius: 30px;
                padding: 20px;
                word-break: break-all;
                
            }

            .chat-footer {
                background-color: #dfeeff;
                padding: 10px;
            }

            .chat-box {
                height: 450px;
                overflow: auto;
            }





            #chat-container {
                display: grid;
                grid-template: 'chats-podstilka messages' '. chat-footer';
                grid-template-columns: 20% 80%;
            }

            #chats {
                background-color: cyan;
                position: absolute;
                overflow: auto;
                height: 450px;
                
            }

            /*#messages {
                border: medium;
                border-bottom-color: blue;
                border-bottom-width: medium;
                background-color: bisque;
                overflow: auto;
                height: 500px;
            }*/

            #messages{
                background-color: cyan;
            }


        </style>

    </head>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        
        <div id="app">

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


            <div id="chat-container">
                <div id="chats">
                    
                    <%--<div v-for="(i, index) in Array.from(Array(80).keys())" :key="index">
                        {{i}}
                        A
                    </div>--%>

                        <div>
                          <div v-for="(chat,index) in chats" :key="index">

                            <div class="btn btn-block btn-primary btn-info" style="width: 100%; margin-top:10px;" @click="getMessages(chat.Id)">

                                {{chat.ChatName}}
                            </div>

                           </div>
                         </div>                    



                </div>
                <div id="chats-podstilka">

                </div>
                <div id="messages">

                    <%--<div v-for="(i, index) in Array.from(Array(20).keys())" :key="index">
                        {{i}} BB
                    </div>--%>

                    <div>
                        
                        <div class="container" id="msgcont">
                             <div class="chat-box row" id="mc">
                               <div class="col-md-12 chat-item " style="max-width: 90%;" v-for="(message,index) in messages" :key="index">
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

                    </div>
                    
                </div>
                <div>

                </div>
                <div class="chat-footer" id="chat-footer">
                    <div class="container" style="display: flex">
                               
                        <input class="form-control"  v-model="message" type="text" placeholder="Message" />
                        <div class="btn btn-primary btn-warning " @click="sendMessage">send</div>
                    </div>
                </div>

            </div>


        </div>

        <script type="text/javascript">

            function gotoBottom(id) {
                id = 'bottom';
                let element = document.getElementById('bottom');

                let scrollEL = document.getElementById('mc');
                //console.log(element);
                //console.log(element.scrollHeight);


                element.scrollIntoView(
                    {
                        block: "center",
                        behavior: "smooth",
                        inline: "center"
                    }
                );

                //element.scrollIntoView(false);

                //scrollEL.scrollTo(0, scrollEL.scrollHeight + 1000);

                console.log(scrollEL.scrollHeight);


                //element.scrollIntoView(true);

                

                //element.scrollTop = 0;



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
                            gotoBottom('msgcont');
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
