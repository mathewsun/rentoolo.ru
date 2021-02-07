<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageChat.aspx.cs" Inherits="Rentoolo.ChatFront.ManageChat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <link rel="stylesheet" href="/assets/css/chat2.css" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" />
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    
    <link src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/js/bootstrap.bundle.min.js" ></script>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
    
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>

</head>
<body>

    <div>
        <div>
            
        <div id="app" class="container">
            <div class="container py-5 px-4">
                <header class="text-center">
                    <h1 class="display-4 text-white">Rentoolo messenger</h1>
                </header>
            </div>
            
            <div class="row">
                <div class="col">
                    
                    

                    <select @change="onChange">
                        <option v-for="chat in chats">
                            {{ chat.ChatName }}
                        </option>
                    </select> 
                    <p>Selected index: {{ selectedIndex }}</p>



                    <br />
                    <div>
                        

                        <div>
                            
                        </div>


                    </div>

                </div>
            </div>
                    

         </div>




        <script>

            let groupChats = <%= GroupChats %>;

            let dialogUsers = <%= DialogUsers %>;

            var app = new Vue({
                el: '#app',
                data: {
                    userId: "<%= User.UserId %>",
                    chats: [],
                    selectedIndex: 0,
                    
                },
                created: function () {
                    console.log(groupChats);
                    console.log(this.userId);
                    console.log(dialogUsers);

                    this.chats = groupChats;

                },
                methods: {

                    onChange: function (event) {
                        let index = event.target.selectedIndex; // this selectedIndex is from event.
                        this.selectedIndex = index;

                    },
                    addUser() {
                        this.addedUsers.push(this.getUserId(this.addingUser));
                        console.log(this.addingUser);
                        console.log(this.addedUsers);
                        this.addingUser = "";
                    },

                    getUserId(userName) {
                        return this.users.filter(x => x.UserName == userName)[0].UserId;
                    },

                    createChat() {
                        let url = '/api/ChatManage';
                        let userIdList = this.addedUsers;
                        let ownerId = this.userId;
                        let chatName = this.chatName;
                        let data = {
                            OwnerId: ownerId,
                            ChatName: chatName,
                            UserIds: userIdList
                        };

                        fetch(url, {
                            method: 'POST', // *GET, POST, PUT, DELETE, etc.
                           headers: {
                                'Content-Type': 'application/json'
                                // 'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: JSON.stringify(data)
                        }).then((response) => {
                            return response.json();
                        })
                            .then((data) => {
                                console.log(data);
                            });

                    }

                },
                computed: {
                    // a computed getter
                    reversedMessage: function () {
                        // `this` points to the vm instance
                        return this.message.split('').reverse().join('')
                    },

                    unusedUsers: function () {
                        return this.users.filter(x => !this.addedUsers.includes(x.UserId));
                    },

                    usedUsers: function () {
                        return this.users.filter(x => this.addedUsers.includes(x.UserId));
                    }


                }

            })


        </script>


        </div>
     </div>
</body>
</html>
