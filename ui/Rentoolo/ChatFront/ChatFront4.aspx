<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChatFront4.aspx.cs" Inherits="Rentoolo.ChatFront.ChatFront4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <link rel="stylesheet" href="/assets/css/chat.css" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" />
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    
    <link src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/js/bootstrap.bundle.min.js" ></script>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
    
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>

</head>
<body>
    
    <div>
        <div>
            
        <div id="app">

            <div class="container py-5 px-4">
                <!-- For demo purpose-->
                <header class="text-center">
                    <h1 class="display-4 text-white">Rentoolo messenger</h1>
                    
                </header>

                <div class="row rounded-lg overflow-hidden shadow">
                <!-- Users box-->
                <div class="col-5 px-0">
                  <div class="bg-white">

                    <div class="bg-gray px-4 py-2 bg-light">
                      <p class="h5 mb-0 py-1">Recent</p>
                    </div>

                    <div class="messages-box">
                      <div class="list-group rounded-0">



                          <div v-for="(chat,index) in chats" :key="index">


                            <a v-if="chat.Id === currentChatId"           class="list-group-item list-group-item-action active text-white rounded-0">
                              <div class="media"><img src="https://res.cloudinary.com/mhmd/image/upload/v1564960395/avatar_usae7z.svg" alt="user" width="50" class="rounded-circle">
                                <div class="media-body ml-4">
                                  <div class="d-flex align-items-center justify-content-between mb-1">
                                    <h6 class="mb-0">
                                        {{chat.ChatName}}
                                    </h6>
                                    <small class="small font-weight-bold">Date?</small>
                                  </div>
                                  <p class="font-italic mb-0 text-small">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore.</p>
                                </div>
                              </div>
                            </a>

                            <div v-if="chat.Id != currentChatId" @click="getMessages(chat.Id)" class="list-group-item list-group-item-action list-group-item-light rounded-0">
                              <div class="media"><img src="https://res.cloudinary.com/mhmd/image/upload/v1564960395/avatar_usae7z.svg" alt="user" width="50" class="rounded-circle">
                                <div class="media-body ml-4">
                                  <div class="d-flex align-items-center justify-content-between mb-1">
                                    <h6 class="mb-0">
                                        {{chat.ChatName}}
                                    </h6>
                                    <small class="small font-weight-bold">Date?</small>
                                  </div>
                                  <p class="font-italic text-muted mb-0 text-small">Lorem ipsum dolor sit amet, consectetur. incididunt ut labore.</p>
                                </div>
                              </div>
                            </div>


                        
                          </div>


                        

                      </div>
                    </div>
                  </div>
                </div>
                <!-- Chat Box-->
                <div class="col-7 px-0" id="scroll">
                  <div class="px-4 py-5 chat-box bg-white">

                    <div id="msgs">

                    <!-- Sender Message-->
                    <div class="media w-50 mb-3"><img src="https://res.cloudinary.com/mhmd/image/upload/v1564960395/avatar_usae7z.svg" alt="user" width="50" class="rounded-circle">
                      <div class="media-body ml-3">
                        <div class="bg-light rounded py-2 px-3 mb-2">
                          <p class="text-small mb-0 text-muted">Test which is a new approach all solutions</p>
                        </div>
                        <p class="small text-muted">12:00 PM | Aug 13</p>
                      </div>
                    </div>

                    <!-- Reciever Message-->
                    <div class="media w-50 ml-auto mb-3">
                      <div class="media-body">
                        <div class="bg-primary rounded py-2 px-3 mb-2">
                          <p class="text-small mb-0 text-white">Test which is a new approach to have all solutions</p>
                        </div>
                        <p class="small text-muted">12:00 PM | Aug 13</p>
                      </div>
                    </div>



                    <%--<div>

                        <div class="col-md-12 chat-item " style="max-width: 90%;" v-for="(message,index) in messages" :key="index">
                            <div>
                                From:{{message.FromUserId}} <br />
                                Message: <br />
                                {{message.Message}}
                            </div>
                        </div>


                    </div>--%>



                        <div class="col-md-12 chat-item " style="max-width: 90%;" v-for="(message,index) in messages" :key="index">
                            <div>
                                <!-- Sender Message-->
                                    <div v-if="message.UserId != userId" class="media w-50 mb-3"><img src="https://res.cloudinary.com/mhmd/image/upload/v1564960395/avatar_usae7z.svg" alt="user" width="50" class="rounded-circle">
                                      <div class="media-body ml-3">
                                        <div class="bg-light rounded py-2 px-3 mb-2">
                                          <p class="text-small mb-0 text-muted">{{message.Message}}</p>
                                        </div>
                                        <p class="small text-muted">{{message.Date}}</p>
                                      </div>
                                    </div>

                                <!-- Reciever Message-->
                                    <div v-else-if="message.UserId === userId" class="media w-50 ml-auto mb-3">
                                      <div class="media-body">
                                        <div class="bg-primary rounded py-2 px-3 mb-2">
                                          <p class="text-small mb-0 text-white">{{message.Message}}</p>
                                        </div>
                                        <p class="small text-muted">{{message.Date}}</p>
                                      </div>
                                    </div>
                            </div>
                        </div>


                      </div>
                    

                  </div>

                  <!-- Typing area -->
                  <div action="#" class="bg-light">
                    <div class="input-group">
                      <input v-model="message" type="text" placeholder="Type a message" aria-describedby="button-addon2" class="form-control rounded-0 border-0 py-4 bg-light">
                      <div class="input-group-append">
                        <button @click="sendMessage" id="button-addon2" class="btn btn-link"> <i class="fa fa-paper-plane"></i></button>
                      </div>
                    </div>
                  </div>

                </div>
              </div>
            </div>



        </div>
        </div>

        
        <script type="text/javascript">

            // NOTE: create dialog in UserProfile.aspx

            // TODO: scroll to down
            function scrollDown() {
                document.getElementById('msgs').scrollTop = document.getElementById('msgs').scrollHeight;
                console.log(document.getElementById('msgs').scrollHeight);
            }



            // deprecated ?
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
                    metaInfo: true,
                    startChat: "<%= StartChatId %>"
                },
                created: function () {
                    this.getChats();

                    if (this.startChat != "") {
                        console.log("chat redirect");
                        getMessages(this.startChat);
                    }

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

                    // used to join chat
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
                                //console.log(data);
                                //gotoBottom('bottom');
                            });
                        this.showMessages = true;

                        this.initWSConnection();

                        this.inChat = true;

                        setTimeout(scrollDown, 1500);

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



</body>
</html>
